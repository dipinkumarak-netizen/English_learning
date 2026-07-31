from typing import cast

from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.db.session import get_db
from app.dependencies import current_user
from app.models import ProviderCredential, User
from app.provider_credentials import (
    CAPABILITIES,
    _env_provider,
    delete_provider,
    save_provider,
    test_provider,
)
from app.provider_crypto import CredentialConfigurationError
from app.schemas import (
    ProviderCapability,
    ProviderSettingsResponse,
    ProviderSettingsSummary,
    ProviderSettingsUpdate,
    ProviderTestRequest,
    ProviderTestResponse,
    ProviderTestStatus,
)

router = APIRouter(prefix="/settings", tags=["settings"])


def _require_secure_transport(request: Request) -> None:
    settings = get_settings()
    scheme = request.headers.get("x-forwarded-proto", request.url.scheme).split(",")[0].strip()
    if scheme == "https":
        return
    if settings.app_env == "development":
        return
    raise HTTPException(status_code=400, detail="Secure HTTPS transport is required.")


async def _summaries(user: User, db: AsyncSession) -> list[ProviderSettingsSummary]:
    settings = get_settings()
    rows = {
        row.capability: row
        for row in (
            await db.scalars(
                select(ProviderCredential).where(ProviderCredential.user_id == user.id)
            )
        ).all()
    }
    result: list[ProviderSettingsSummary] = []
    for capability in CAPABILITIES:
        row = rows.get(capability)
        if row is None:
            resolved = _env_provider(capability, settings)
            last4 = resolved.api_key[-4:] if resolved.api_key else None
            result.append(
                ProviderSettingsSummary(
                    capability=cast(ProviderCapability, capability),
                    provider=resolved.provider,
                    configured=bool(resolved.api_key),
                    key_last4=last4,
                    model=resolved.model or None,
                    base_url=resolved.base_url or None,
                    voice=resolved.voice or None,
                    enabled=resolved.enabled,
                    last_test_status=None,
                    last_tested_at=None,
                    updated_at=None,
                )
            )
            continue
        result.append(
            ProviderSettingsSummary(
                capability=cast(ProviderCapability, capability),
                provider=row.provider,
                configured=bool(row.encrypted_api_key),
                key_last4=row.key_last4,
                model=row.model,
                base_url=row.base_url or None,
                voice=row.voice,
                enabled=row.enabled,
                last_test_status=row.last_test_status,
                last_tested_at=row.last_tested_at,
                updated_at=row.updated_at,
            )
        )
    return result


@router.get("/providers", response_model=ProviderSettingsResponse)
async def get_provider_settings(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> ProviderSettingsResponse:
    return ProviderSettingsResponse(providers=await _summaries(user, db))


@router.put("/providers/{capability}", response_model=ProviderSettingsResponse)
async def put_provider_settings(
    capability: str,
    payload: ProviderSettingsUpdate,
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderSettingsResponse:
    _require_secure_transport(request)
    try:
        await save_provider(capability, payload, user, db, get_settings())
    except CredentialConfigurationError as error:
        raise HTTPException(status_code=503, detail=str(error)) from error
    return ProviderSettingsResponse(providers=await _summaries(user, db))


@router.post("/providers/{capability}/test", response_model=ProviderTestResponse)
async def test_provider_settings(
    capability: str,
    payload: ProviderTestRequest,
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderTestResponse:
    _require_secure_transport(request)
    status, message, tested_at = await test_provider(capability, payload, user, db, get_settings())
    return ProviderTestResponse(
        status=cast(ProviderTestStatus, status),
        message=message,
        tested_at=tested_at,
    )


@router.delete("/providers", response_model=ProviderSettingsResponse)
async def delete_all_provider_settings(
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderSettingsResponse:
    _require_secure_transport(request)
    await delete_provider("all", user, db, get_settings())
    return ProviderSettingsResponse(providers=await _summaries(user, db))


@router.delete("/providers/{capability}", response_model=ProviderSettingsResponse)
async def delete_provider_settings(
    capability: str,
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderSettingsResponse:
    _require_secure_transport(request)
    await delete_provider(capability, user, db, get_settings())
    return ProviderSettingsResponse(providers=await _summaries(user, db))
