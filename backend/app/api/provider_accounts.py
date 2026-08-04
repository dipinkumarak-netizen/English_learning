from datetime import UTC, datetime

import httpx
from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.transport import effective_scheme
from app.db.session import get_db
from app.dependencies import current_user
from app.models import ProviderAccount, ProviderCapabilityConfig, ProviderCredentialAudit, User
from app.provider_credentials import enforce_rate_limit
from app.provider_crypto import decrypt_credential, encrypt_credential
from app.schemas import (
    ProviderAccountCreate,
    ProviderAccountListResponse,
    ProviderAccountSummary,
    ProviderAccountUpdate,
)

router = APIRouter(prefix="/settings", tags=["provider-accounts"])


def _secure(request: Request) -> None:
    settings = get_settings()
    if effective_scheme(request, settings) != "https" and settings.app_env != "development":
        raise HTTPException(status_code=400, detail="Secure HTTPS transport is required.")


async def _audit(db: AsyncSession, user: User, action: str, outcome: str) -> None:
    db.add(
        ProviderCredentialAudit(
            user_id=user.id, capability="account", action=action, outcome=outcome
        )
    )


async def _summaries(user: User, db: AsyncSession) -> list[ProviderAccountSummary]:
    accounts = (
        await db.scalars(select(ProviderAccount).where(ProviderAccount.user_id == user.id))
    ).all()
    configs = (
        await db.scalars(
            select(ProviderCapabilityConfig).where(ProviderCapabilityConfig.user_id == user.id)
        )
    ).all()
    by_account: dict[str, list[str]] = {}
    for config in configs:
        if config.provider_account_id:
            by_account.setdefault(config.provider_account_id, []).append(config.capability)
    return [
        ProviderAccountSummary(
            id=account.id,
            provider=account.provider,
            configured=bool(account.encrypted_api_key),
            key_last4=account.key_last4,
            last_test_status=account.last_test_status,
            last_test_message_safe=account.last_test_message_safe,
            last_tested_at=account.last_tested_at,
            capabilities_using_account=by_account.get(account.id, []),
            created_at=account.created_at,
            updated_at=account.updated_at,
        )
        for account in accounts
    ]


@router.get("/provider-accounts", response_model=ProviderAccountListResponse)
async def list_accounts(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> ProviderAccountListResponse:
    return ProviderAccountListResponse(accounts=await _summaries(user, db))


@router.post("/provider-accounts", response_model=ProviderAccountListResponse, status_code=201)
async def create_account(
    payload: ProviderAccountCreate,
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderAccountListResponse:
    _secure(request)
    settings = get_settings()
    await enforce_rate_limit(db, user, "account", settings)
    existing = await db.scalar(
        select(ProviderAccount).where(
            ProviderAccount.user_id == user.id, ProviderAccount.provider == payload.provider
        )
    )
    if existing is not None:
        raise HTTPException(status_code=409, detail="A provider account already exists.")
    account = ProviderAccount(
        user_id=user.id,
        provider=payload.provider,
        encrypted_api_key=encrypt_credential(payload.api_key, settings.credential_encryption_key),
        key_last4=payload.api_key[-4:],
    )
    db.add(account)
    await _audit(db, user, "account_create", "success")
    await db.commit()
    return ProviderAccountListResponse(accounts=await _summaries(user, db))


@router.put("/provider-accounts/{account_id}", response_model=ProviderAccountListResponse)
async def update_account(
    account_id: str,
    payload: ProviderAccountUpdate,
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderAccountListResponse:
    _secure(request)
    settings = get_settings()
    await enforce_rate_limit(db, user, "account", settings)
    account = await db.scalar(
        select(ProviderAccount).where(
            ProviderAccount.id == account_id, ProviderAccount.user_id == user.id
        )
    )
    if account is None:
        raise HTTPException(status_code=404, detail="Provider account not found.")
    if payload.api_key is not None:
        account.encrypted_api_key = encrypt_credential(
            payload.api_key, settings.credential_encryption_key
        )
        account.key_last4 = payload.api_key[-4:]
    await _audit(db, user, "account_update", "success")
    await db.commit()
    return ProviderAccountListResponse(accounts=await _summaries(user, db))


@router.delete("/provider-accounts/{account_id}", response_model=ProviderAccountListResponse)
async def delete_account(
    account_id: str,
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderAccountListResponse:
    _secure(request)
    settings = get_settings()
    await enforce_rate_limit(db, user, "account", settings)
    account = await db.scalar(
        select(ProviderAccount).where(
            ProviderAccount.id == account_id, ProviderAccount.user_id == user.id
        )
    )
    if account is None:
        raise HTTPException(status_code=404, detail="Provider account not found.")
    dependents = (
        await db.scalars(
            select(ProviderCapabilityConfig.capability).where(
                ProviderCapabilityConfig.provider_account_id == account_id,
                ProviderCapabilityConfig.user_id == user.id,
            )
        )
    ).all()
    if dependents:
        await _audit(db, user, "account_delete", "blocked_dependency")
        await db.commit()
        raise HTTPException(
            status_code=409,
            detail="Provider account is used by: " + ", ".join(sorted(dependents)),
        )
    await db.delete(account)
    await _audit(db, user, "account_delete", "success")
    await db.commit()
    return ProviderAccountListResponse(accounts=await _summaries(user, db))


@router.post("/provider-accounts/{account_id}/test", response_model=ProviderAccountListResponse)
async def test_account(
    account_id: str,
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderAccountListResponse:
    _secure(request)
    settings = get_settings()
    await enforce_rate_limit(db, user, "account", settings)
    account = await db.scalar(
        select(ProviderAccount).where(
            ProviderAccount.id == account_id, ProviderAccount.user_id == user.id
        )
    )
    if account is None:
        raise HTTPException(status_code=404, detail="Provider account not found.")
    key = decrypt_credential(account.encrypted_api_key, settings.credential_encryption_key)
    url, headers = (
        ("https://api.openai.com/v1/models", {"Authorization": f"Bearer {key}"})
        if account.provider == "openai"
        else (
            "https://generativelanguage.googleapis.com/v1beta/models",
            {"x-goog-api-key": key},
        )
    )
    try:
        async with httpx.AsyncClient(timeout=5) as client:
            response = await client.get(url, headers=headers)
        if response.status_code in (401, 403):
            status, message = "failed", "The provider rejected this credential."
        elif response.status_code == 429:
            status, message = "failed", "The provider rate limit was reached."
        elif response.status_code >= 400:
            status, message = "failed", "The provider connection could not be verified."
        else:
            status, message = "success", "Provider connection succeeded."
    except httpx.TimeoutException:
        status, message = "failed", "The provider connection timed out."
    except httpx.HTTPError:
        status, message = "failed", "The provider connection is unavailable."
    account.last_test_status = status
    account.last_test_message_safe = message
    account.last_tested_at = datetime.now(UTC)
    await _audit(db, user, "account_test", status)
    await db.commit()
    return ProviderAccountListResponse(accounts=await _summaries(user, db))
