from typing import Literal, cast

from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.transport import effective_scheme
from app.db.session import get_db
from app.dependencies import current_user
from app.models import ProviderAccount, ProviderCapabilityConfig, User
from app.provider_credentials import CAPABILITIES, _env_provider, resolve_provider
from app.schemas import (
    ProviderCapabilityListResponse,
    ProviderCapabilitySummary,
    ProviderCapabilityUpdate,
)

router = APIRouter(prefix="/settings", tags=["provider-capabilities"])


def _secure(request: Request) -> None:
    settings = get_settings()
    if effective_scheme(request, settings) != "https" and settings.app_env != "development":
        raise HTTPException(status_code=400, detail="Secure HTTPS transport is required.")


async def _summary(capability: str, user: User, db: AsyncSession) -> ProviderCapabilitySummary:
    settings = get_settings()
    config = await db.scalar(
        select(ProviderCapabilityConfig).where(
            ProviderCapabilityConfig.user_id == user.id,
            ProviderCapabilityConfig.capability == capability,
        )
    )
    resolved = await resolve_provider(capability, user, db, settings)
    source = "legacy_encrypted"
    if config is not None:
        source = (
            "user_encrypted"
            if config.provider_account_id
            else ("environment" if _env_provider(capability, settings).api_key else "none")
        )
    provider_type = (
        "disabled"
        if resolved.provider == "none" or not resolved.enabled
        else ("mock" if resolved.provider == "mock" else "real")
    )
    usable = provider_type == "mock" or (provider_type == "real" and bool(resolved.api_key))
    return ProviderCapabilitySummary(
        capability=cast(Literal["ai", "stt", "tts"], capability),
        provider=resolved.provider,
        provider_account_id=config.provider_account_id if config else None,
        enabled=resolved.enabled,
        model=resolved.model or None,
        voice=resolved.voice or None,
        credential_source=source,
        provider_type=provider_type,
        usable=usable,
        validation_message=None
        if usable or provider_type == "disabled"
        else "A provider account is required.",
        preview=resolved.provider == "gemini" and capability == "tts",
    )


async def _all(user: User, db: AsyncSession) -> ProviderCapabilityListResponse:
    return ProviderCapabilityListResponse(
        capabilities=[await _summary(capability, user, db) for capability in CAPABILITIES]
    )


@router.get("/provider-capabilities", response_model=ProviderCapabilityListResponse)
async def list_capabilities(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> ProviderCapabilityListResponse:
    return await _all(user, db)


@router.put("/provider-capabilities/{capability}", response_model=ProviderCapabilityListResponse)
async def update_capability(
    capability: str,
    payload: ProviderCapabilityUpdate,
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProviderCapabilityListResponse:
    _secure(request)
    if capability not in CAPABILITIES:
        raise HTTPException(status_code=404, detail="Provider capability not found.")
    if payload.provider == "none":
        if payload.enabled or payload.provider_account_id:
            raise HTTPException(
                status_code=422, detail="Disabled capability must not be enabled or assigned."
            )
    elif payload.provider == "mock":
        if not payload.enabled or payload.provider_account_id:
            raise HTTPException(
                status_code=422, detail="Mock capability does not use a provider account."
            )
    else:
        if not payload.enabled or not payload.model:
            raise HTTPException(
                status_code=422, detail="Enabled real capabilities require a model."
            )
        account = await db.scalar(
            select(ProviderAccount).where(
                ProviderAccount.id == payload.provider_account_id,
                ProviderAccount.user_id == user.id,
            )
        )
        if account is None or account.provider != payload.provider:
            raise HTTPException(
                status_code=422, detail="The selected provider account does not match."
            )
    if capability != "tts" and payload.voice:
        raise HTTPException(status_code=422, detail="Voice is supported only for text-to-speech.")
    config = await db.scalar(
        select(ProviderCapabilityConfig).where(
            ProviderCapabilityConfig.user_id == user.id,
            ProviderCapabilityConfig.capability == capability,
        )
    )
    if config is None:
        config = ProviderCapabilityConfig(user_id=user.id, capability=capability)
        db.add(config)
    config.provider = payload.provider
    config.provider_account_id = payload.provider_account_id
    config.enabled = payload.enabled and payload.provider != "none"
    config.model = payload.model
    config.voice = payload.voice
    await db.commit()
    return await _all(user, db)
