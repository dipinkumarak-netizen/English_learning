from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from ipaddress import ip_address
from typing import Any
from urllib.parse import urlparse

import httpx
from fastapi import HTTPException
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import Settings
from app.models import (
    ProviderAccount,
    ProviderCapabilityConfig,
    ProviderCredential,
    ProviderCredentialAudit,
    User,
)
from app.provider_crypto import (
    CredentialConfigurationError,
    decrypt_credential,
    encrypt_credential,
)
from app.schemas import ProviderSettingsUpdate, ProviderTestRequest

CAPABILITIES = ("ai", "stt", "tts")
ALLOWED_PROVIDERS = {"none", "mock", "openai", "gemini"}


@dataclass(frozen=True)
class ResolvedProvider:
    provider: str
    enabled: bool
    api_key: str
    model: str
    base_url: str
    voice: str


def _decrypt_with_rotation(value: str, settings: Settings) -> str:
    try:
        return decrypt_credential(value, settings.credential_encryption_key)
    except CredentialConfigurationError:
        if not settings.credential_encryption_previous_key:
            raise
        return decrypt_credential(value, settings.credential_encryption_previous_key)


def _validate_base_url(value: str | None, settings: Settings) -> str:
    if not value:
        return "https://api.openai.com/v1"
    parsed = urlparse(value)
    if parsed.scheme != "https":
        if not (
            settings.app_env == "development"
            and settings.provider_allow_local_urls
            and parsed.scheme == "http"
            and parsed.hostname in {"localhost", "127.0.0.1", "::1"}
        ):
            raise HTTPException(status_code=422, detail="Provider base URL must use HTTPS.")
    if not parsed.hostname or parsed.username or parsed.password:
        raise HTTPException(status_code=422, detail="Provider base URL is invalid.")
    try:
        address = ip_address(parsed.hostname)
        if not (
            settings.app_env == "development"
            and settings.provider_allow_local_urls
            and address.is_loopback
        ) and (address.is_private or address.is_link_local or address.is_loopback):
            raise HTTPException(status_code=422, detail="Provider base URL is not allowed.")
    except ValueError:
        pass
    allowed = [item.strip().rstrip("/") for item in settings.provider_allowed_base_urls.split(",")]
    if value.rstrip("/") not in allowed and not (
        settings.app_env == "development" and settings.provider_allow_local_urls
    ):
        raise HTTPException(status_code=422, detail="Provider base URL is not allow-listed.")
    return value.rstrip("/")


def _env_provider(capability: str, settings: Settings) -> ResolvedProvider:
    if capability == "ai":
        enabled = settings.ai_provider_enabled
        prefix = "ai"
    else:
        enabled = getattr(settings, f"{capability}_enabled")
        prefix = capability
    return ResolvedProvider(
        provider=getattr(settings, f"{prefix}_provider"),
        enabled=enabled,
        api_key=getattr(settings, f"{prefix}_api_key") or settings.ai_api_key,
        model=getattr(settings, f"{prefix}_model"),
        base_url=getattr(settings, f"{prefix}_base_url"),
        voice=getattr(settings, "tts_voice", "default") if capability == "tts" else "",
    )


async def resolve_provider(
    capability: str, user: User, db: AsyncSession, settings: Settings
) -> ResolvedProvider:
    if capability not in CAPABILITIES:
        raise ValueError("Unsupported provider capability")
    config = await db.scalar(
        select(ProviderCapabilityConfig).where(
            ProviderCapabilityConfig.user_id == user.id,
            ProviderCapabilityConfig.capability == capability,
        )
    )
    if config is not None:
        if config.provider_account_id:
            account = await db.scalar(
                select(ProviderAccount).where(
                    ProviderAccount.id == config.provider_account_id,
                    ProviderAccount.user_id == user.id,
                )
            )
            if account is None or account.provider != config.provider:
                raise CredentialConfigurationError("Provider account configuration is invalid.")
            key = _decrypt_with_rotation(account.encrypted_api_key, settings)
        else:
            key = ""
        if config.provider in {"none", "mock"} or config.provider_account_id:
            return ResolvedProvider(
                provider=config.provider,
                enabled=config.enabled,
                api_key=key,
                model=config.model or "",
                base_url="",
                voice=config.voice or "default",
            )
        env = _env_provider(capability, settings)
        return ResolvedProvider(
            provider=config.provider,
            enabled=config.enabled,
            api_key=env.api_key,
            model=config.model or env.model,
            base_url="",
            voice=config.voice or env.voice,
        )
    row = await db.scalar(
        select(ProviderCredential).where(
            ProviderCredential.user_id == user.id,
            ProviderCredential.capability == capability,
        )
    )
    if row is None:
        return _env_provider(capability, settings)
    key = _decrypt_with_rotation(row.encrypted_api_key, settings) if row.encrypted_api_key else ""
    return ResolvedProvider(
        provider=row.provider,
        enabled=row.enabled,
        api_key=key,
        model=row.model or "",
        base_url=row.base_url or "",
        voice=row.voice or "default",
    )


async def build_user_provider(
    capability: str, user: User, db: AsyncSession, settings: Settings
) -> Any:
    resolved = await resolve_provider(capability, user, db, settings)
    if capability == "ai":
        from app.ai.providers import build_provider

        effective = settings.model_copy(
            update={
                "ai_provider": resolved.provider,
                "ai_provider_enabled": resolved.enabled,
                "ai_api_key": resolved.api_key,
                "ai_model": resolved.model or settings.ai_model,
                "ai_base_url": resolved.base_url or settings.ai_base_url,
            }
        )
        return build_provider(effective)
    if capability == "stt":
        from app.voice.providers import build_stt_provider

        effective = settings.model_copy(
            update={
                "stt_provider": resolved.provider,
                "stt_enabled": resolved.enabled,
                "stt_api_key": resolved.api_key,
                "stt_model": resolved.model or settings.stt_model,
                "stt_base_url": resolved.base_url or settings.stt_base_url,
            }
        )
        return build_stt_provider(effective)
    if capability == "tts":
        from app.voice.providers import build_tts_provider

        effective = settings.model_copy(
            update={
                "tts_provider": resolved.provider,
                "tts_enabled": resolved.enabled,
                "tts_api_key": resolved.api_key,
                "tts_model": resolved.model or settings.tts_model,
                "tts_base_url": resolved.base_url or settings.tts_base_url,
                "tts_voice": resolved.voice or settings.tts_voice,
            }
        )
        return build_tts_provider(effective)
    raise ValueError("Unsupported provider capability")


async def _audit(
    db: AsyncSession, user_id: str, capability: str, action: str, outcome: str
) -> None:
    db.add(
        ProviderCredentialAudit(
            user_id=user_id,
            capability=capability,
            action=action,
            outcome=outcome,
        )
    )


async def enforce_rate_limit(
    db: AsyncSession, user: User, capability: str, settings: Settings
) -> None:
    since = datetime.now(UTC) - timedelta(hours=1)
    count = await db.scalar(
        select(func.count(ProviderCredentialAudit.id)).where(
            ProviderCredentialAudit.user_id == user.id,
            ProviderCredentialAudit.capability == capability,
            ProviderCredentialAudit.action.in_(
                [
                    "save",
                    "test",
                    "delete",
                    "account_create",
                    "account_update",
                    "account_test",
                    "account_delete",
                ]
            ),
            ProviderCredentialAudit.created_at >= since,
        )
    )
    if int(count or 0) >= settings.provider_settings_rate_limit_per_hour:
        raise HTTPException(status_code=429, detail="Provider settings rate limit reached.")


async def save_provider(
    capability: str,
    payload: ProviderSettingsUpdate,
    user: User,
    db: AsyncSession,
    settings: Settings,
) -> None:
    if capability not in CAPABILITIES or payload.provider not in ALLOWED_PROVIDERS:
        raise HTTPException(status_code=422, detail="Provider configuration is invalid.")
    await enforce_rate_limit(db, user, capability, settings)
    base_url = (
        _validate_base_url(payload.base_url, settings) if payload.provider == "openai" else ""
    )
    row = await db.scalar(
        select(ProviderCredential).where(
            ProviderCredential.user_id == user.id,
            ProviderCredential.capability == capability,
        )
    )
    if row is None:
        row = ProviderCredential(user_id=user.id, capability=capability)
        db.add(row)
    row.provider = payload.provider
    row.enabled = payload.enabled and payload.provider != "none"
    row.model = payload.model
    row.base_url = base_url
    row.voice = payload.voice
    if payload.api_key is not None:
        row.encrypted_api_key = encrypt_credential(
            payload.api_key, settings.credential_encryption_key
        )
        row.key_last4 = payload.api_key[-4:]
    await _audit(db, user.id, capability, "save", "success")
    await db.commit()


async def delete_provider(
    capability: str, user: User, db: AsyncSession, settings: Settings
) -> None:
    if capability not in CAPABILITIES and capability != "all":
        raise HTTPException(status_code=404, detail="Provider capability not found.")
    await enforce_rate_limit(db, user, capability if capability != "all" else "ai", settings)
    query = select(ProviderCredential).where(ProviderCredential.user_id == user.id)
    if capability != "all":
        query = query.where(ProviderCredential.capability == capability)
    rows = (await db.scalars(query)).all()
    for row in rows:
        await db.delete(row)
        await _audit(db, user.id, row.capability, "delete", "success")
    await db.commit()


async def test_provider(
    capability: str,
    payload: ProviderTestRequest,
    user: User,
    db: AsyncSession,
    settings: Settings,
) -> tuple[str, str, datetime]:
    if capability not in CAPABILITIES or payload.provider not in ALLOWED_PROVIDERS:
        raise HTTPException(status_code=422, detail="Provider configuration is invalid.")
    await enforce_rate_limit(db, user, capability, settings)
    tested_at = datetime.now(UTC)
    try:
        if payload.provider == "none":
            raise ValueError("Provider is disabled.")
        if payload.provider == "mock":
            status, message = "success", "Mock provider is available."
        else:
            base_url = _validate_base_url(payload.base_url, settings)
            key = payload.api_key or ""
            if not key:
                raise ValueError("API key is required for the selected provider.")
            async with httpx.AsyncClient(timeout=5) as client:
                response = await client.get(
                    f"{base_url}/models",
                    headers={"Authorization": f"Bearer {key}"},
                )
            if response.status_code != 200:
                raise ValueError("Provider connection was rejected.")
            status, message = "success", "Provider connection succeeded."
    except (httpx.TimeoutException, httpx.HTTPError):
        status, message = "failed", "Provider connection timed out or is unavailable."
    except ValueError as error:
        status, message = "failed", str(error)
    await _audit(db, user.id, capability, "test", status)
    row = await db.scalar(
        select(ProviderCredential).where(
            ProviderCredential.user_id == user.id,
            ProviderCredential.capability == capability,
        )
    )
    if row is not None:
        row.last_test_status = status
        row.last_tested_at = tested_at
    await db.commit()
    return status, message, tested_at
