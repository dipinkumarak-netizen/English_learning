from typing import Literal, cast

from fastapi import APIRouter, Depends, Request
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.transport import transport_state
from app.db.session import get_db
from app.dependencies import current_user
from app.models import ProviderCredential, User
from app.provider_credentials import CAPABILITIES, resolve_provider
from app.schemas import CapabilityState, CapabilityStatusResponse

router = APIRouter(tags=["capabilities"])


async def _capability_state(capability: str, user: User, db: AsyncSession) -> CapabilityState:
    settings = get_settings()
    row = await db.scalar(
        select(ProviderCredential).where(
            ProviderCredential.user_id == user.id,
            ProviderCredential.capability == capability,
        )
    )
    resolved = await resolve_provider(capability, user, db, settings)
    source = (
        "user_encrypted"
        if row is not None
        else ("environment" if resolved.api_key or resolved.provider == "mock" else "none")
    )
    state = (
        "disabled"
        if resolved.provider == "none" or not resolved.enabled
        else ("mock" if resolved.provider == "mock" else "real")
    )
    usable = state == "mock" or (state == "real" and bool(resolved.api_key))
    validation_message = None
    preview = resolved.provider == "gemini" and capability == "tts"
    if resolved.provider == "gemini" and capability == "stt":
        usable = False
        validation_message = (
            "Gemini speech-to-text is unavailable for the current M4A recording format."
        )
    provider_type = cast(Literal["disabled", "mock", "real"], state)
    return CapabilityState(
        state=provider_type,
        credential_source=cast(Literal["user_encrypted", "environment", "none"], source),
        usable=usable,
        enabled=resolved.enabled,
        provider=resolved.provider,
        provider_type=provider_type,
        preview=preview,
        validation_message=validation_message,
    )


@router.get("/capabilities", response_model=CapabilityStatusResponse)
async def get_capabilities(
    request: Request,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> CapabilityStatusResponse:
    settings = get_settings()
    state = transport_state(request, settings)
    capabilities = {
        capability: await _capability_state(capability, user, db) for capability in CAPABILITIES
    }
    return CapabilityStatusResponse(
        transport_state=cast(Literal["secure_https", "private_http", "insecure_or_invalid"], state),
        registration_available=settings.allow_registration,
        ai=capabilities["ai"],
        stt=capabilities["stt"],
        tts=capabilities["tts"],
        max_audio_duration_seconds=settings.stt_max_audio_seconds,
        max_upload_bytes=settings.stt_max_upload_bytes,
        voice_daily_transcription_seconds=settings.voice_daily_transcription_seconds,
        voice_daily_synthesis_characters=settings.voice_daily_synthesis_characters,
        voice_max_turns_per_session=settings.voice_max_turns_per_session,
        provider_mutations_allowed=state == "secure_https" or settings.app_env == "development",
    )
