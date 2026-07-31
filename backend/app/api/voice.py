from __future__ import annotations

import secrets
from datetime import UTC, datetime, timedelta
from pathlib import Path

from fastapi import APIRouter, Depends, File, Form, HTTPException, Query, UploadFile
from fastapi.responses import FileResponse
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.tutor import send_message
from app.core.config import get_settings
from app.db.session import get_db
from app.dependencies import current_user
from app.models import (
    AudioAsset,
    TutorConversation,
    TutorMessage,
    User,
    VoiceConversationSession,
    VoicePreference,
    VoiceTurn,
    VoiceUsageRecord,
)
from app.provider_credentials import build_user_provider
from app.schemas import (
    TutorMessageRequest,
    VoicePreferenceUpdate,
    VoiceSessionCreate,
    VoiceSubmitRequest,
    VoiceSynthesisRequest,
    VoiceTranscriptUpdate,
)
from app.voice.providers import (
    SpeechToTextRequest,
    TextToSpeechRequest,
    VoiceProviderMalformed,
    VoiceProviderRateLimited,
    VoiceProviderTimeout,
    VoiceProviderUnavailable,
)

router = APIRouter(prefix="/voice", tags=["voice"])
ALLOWED_INPUT_TYPES = {"audio/mp4", "audio/x-m4a", "audio/aac"}
ALLOWED_EXTENSIONS = {".m4a", ".mp4", ".aac"}


def _session_response(session: VoiceConversationSession) -> dict[str, object]:
    return {
        "id": session.id,
        "conversation_id": session.conversation_id,
        "tutor_mode": session.tutor_mode,
        "status": session.status,
        "language": session.language,
        "explanation_language": session.explanation_language,
        "recording_mode": session.recording_mode,
        "auto_play": session.auto_play,
        "playback_speed": session.playback_speed,
        "total_voice_turns": session.total_voice_turns,
        "started_at": session.started_at,
        "completed_at": session.completed_at,
    }


def _turn_response(turn: VoiceTurn) -> dict[str, object]:
    return {
        "id": turn.id,
        "session_id": turn.session_id,
        "turn_number": turn.turn_number,
        "transcription_status": turn.transcription_status,
        "transcript": turn.transcript,
        "edited_transcript": turn.edited_transcript,
        "detected_language": turn.detected_language,
        "recording_duration_seconds": turn.recording_duration_seconds,
        "tutor_message_id": turn.tutor_message_id,
        "synthesis_status": turn.synthesis_status,
        "tutor_audio_id": turn.tutor_audio_id,
        "failure_category": turn.failure_category,
        "created_at": turn.created_at,
        "completed_at": turn.completed_at,
    }


async def _owned_session(
    session_id: str, user_id: str, db: AsyncSession
) -> VoiceConversationSession:
    session = await db.scalar(
        select(VoiceConversationSession).where(
            VoiceConversationSession.id == session_id,
            VoiceConversationSession.user_id == user_id,
        )
    )
    if session is None:
        raise HTTPException(status_code=404, detail="Voice session not found.")
    if session.status != "active":
        raise HTTPException(status_code=409, detail="This voice session is no longer active.")
    return session


async def _owned_turn(turn_id: str, user_id: str, db: AsyncSession) -> VoiceTurn:
    turn = await db.scalar(
        select(VoiceTurn).where(VoiceTurn.id == turn_id, VoiceTurn.user_id == user_id)
    )
    if turn is None:
        raise HTTPException(status_code=404, detail="Voice turn not found.")
    return turn


def _storage_root() -> Path:
    root = Path(get_settings().voice_audio_storage_path).resolve()
    root.mkdir(parents=True, exist_ok=True)
    return root


def _validate_audio(
    filename: str | None, content_type: str | None, data: bytes, duration: int
) -> None:
    settings = get_settings()
    suffix = Path(filename or "").suffix.lower()
    if content_type not in ALLOWED_INPUT_TYPES or suffix not in ALLOWED_EXTENSIONS:
        raise HTTPException(status_code=415, detail="Only M4A/AAC audio is accepted.")
    if not data or len(data) > settings.stt_max_upload_bytes:
        raise HTTPException(status_code=413, detail="Audio size is outside the allowed limit.")
    if suffix in {".m4a", ".mp4"} and len(data) < 12:
        raise HTTPException(status_code=415, detail="The audio container is invalid.")
    if suffix in {".m4a", ".mp4"} and data[4:8] != b"ftyp":
        raise HTTPException(status_code=415, detail="The audio container is invalid.")
    if duration < 1 or duration > settings.stt_max_audio_seconds:
        raise HTTPException(
            status_code=413, detail="Recording duration is outside the allowed limit."
        )


async def _daily_seconds(user_id: str, db: AsyncSession) -> int:
    since = datetime.now(UTC).replace(hour=0, minute=0, second=0, microsecond=0)
    return int(
        await db.scalar(
            select(func.coalesce(func.sum(VoiceUsageRecord.audio_duration_seconds), 0)).where(
                VoiceUsageRecord.user_id == user_id,
                VoiceUsageRecord.operation == "transcribe",
                VoiceUsageRecord.created_at >= since,
            )
        )
        or 0
    )


async def _daily_synthesis_characters(user_id: str, db: AsyncSession) -> int:
    since = datetime.now(UTC).replace(hour=0, minute=0, second=0, microsecond=0)
    return int(
        await db.scalar(
            select(func.coalesce(func.sum(VoiceUsageRecord.synthesis_characters), 0)).where(
                VoiceUsageRecord.user_id == user_id,
                VoiceUsageRecord.operation == "synthesise",
                VoiceUsageRecord.created_at >= since,
            )
        )
        or 0
    )


@router.post("/sessions", status_code=201)
async def create_session(
    payload: VoiceSessionCreate,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, object]:
    conversation = await db.scalar(
        select(TutorConversation).where(
            TutorConversation.id == payload.conversation_id,
            TutorConversation.user_id == user.id,
            TutorConversation.status == "active",
        )
    )
    if conversation is None:
        raise HTTPException(status_code=404, detail="Active tutor conversation not found.")
    session = VoiceConversationSession(
        user_id=user.id,
        conversation_id=conversation.id,
        tutor_mode=conversation.mode,
        explanation_language=conversation.explanation_language_snapshot,
        recording_mode=payload.recording_mode,
        auto_play=payload.auto_play,
        playback_speed=payload.playback_speed,
    )
    db.add(session)
    await db.commit()
    return _session_response(session)


@router.get("/sessions/{session_id}")
async def get_session(
    session_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> dict[str, object]:
    session = await _owned_session(session_id, user.id, db)
    turns = (
        await db.scalars(
            select(VoiceTurn)
            .where(VoiceTurn.session_id == session.id)
            .order_by(VoiceTurn.turn_number)
        )
    ).all()
    return {
        "session": _session_response(session),
        "turns": [_turn_response(item) for item in turns],
    }


@router.post("/sessions/{session_id}/turns", status_code=201)
async def create_turn(
    session_id: str,
    client_operation_id: str = Form(..., min_length=8, max_length=80),
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, object]:
    session = await _owned_session(session_id, user.id, db)
    duplicate = await db.scalar(
        select(VoiceTurn).where(
            VoiceTurn.session_id == session.id,
            VoiceTurn.client_operation_id == client_operation_id,
        )
    )
    if duplicate is not None:
        return _turn_response(duplicate)
    if session.total_voice_turns >= get_settings().voice_max_turns_per_session:
        raise HTTPException(
            status_code=429, detail="This voice session has reached its safety limit."
        )
    turn = VoiceTurn(
        user_id=user.id,
        session_id=session.id,
        conversation_id=session.conversation_id,
        turn_number=session.total_voice_turns + 1,
        client_operation_id=client_operation_id,
    )
    session.total_voice_turns += 1
    db.add(turn)
    await db.commit()
    return _turn_response(turn)


@router.post("/turns/{turn_id}/audio")
async def upload_audio(
    turn_id: str,
    audio: UploadFile = File(...),
    declared_duration_seconds: int = Form(..., ge=1),
    operation_id: str = Form(..., min_length=8, max_length=80),
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, object]:
    turn = await _owned_turn(turn_id, user.id, db)
    if turn.transcription_status not in {"pending", "failed"}:
        raise HTTPException(status_code=409, detail="This turn already has an audio upload.")
    existing = await db.scalar(
        select(AudioAsset).where(AudioAsset.turn_id == turn.id, AudioAsset.asset_type == "learner")
    )
    if existing is not None:
        return {"audio_id": existing.id, "status": existing.status}
    data = await audio.read(get_settings().stt_max_upload_bytes + 1)
    _validate_audio(audio.filename, audio.content_type, data, declared_duration_seconds)
    if (
        await _daily_seconds(user.id, db) + declared_duration_seconds
        > get_settings().voice_daily_transcription_seconds
    ):
        raise HTTPException(status_code=429, detail="Daily transcription safety limit reached.")
    key = f"learner/{secrets.token_urlsafe(24)}{Path(audio.filename or 'recording.m4a').suffix.lower()}"
    path = _storage_root() / key
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    asset = AudioAsset(
        user_id=user.id,
        session_id=turn.session_id,
        turn_id=turn.id,
        asset_type="learner",
        storage_key=key,
        mime_type=audio.content_type or "audio/mp4",
        byte_size=len(data),
        duration_seconds=declared_duration_seconds,
        expires_at=datetime.now(UTC)
        + timedelta(minutes=get_settings().voice_temp_audio_retention_minutes),
    )
    turn.recording_duration_seconds = declared_duration_seconds
    turn.transcription_status = "uploaded"
    db.add(asset)
    await db.flush()
    turn.learner_audio_id = asset.id
    await db.commit()
    return {"audio_id": asset.id, "status": "uploaded", "operation_id": operation_id}


@router.post("/turns/{turn_id}/transcribe")
async def transcribe(
    turn_id: str,
    operation_id: str = Query(..., min_length=8, max_length=80),
    fixture: str | None = Query(default=None),
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, object]:
    turn = await _owned_turn(turn_id, user.id, db)
    if turn.transcription_status == "transcript_ready":
        return _turn_response(turn)
    if turn.stt_operation_id == operation_id and turn.transcript:
        return _turn_response(turn)
    asset = await db.scalar(
        select(AudioAsset).where(
            AudioAsset.id == turn.learner_audio_id, AudioAsset.user_id == user.id
        )
    )
    if asset is None:
        raise HTTPException(status_code=409, detail="Upload a recording before transcription.")
    path = (_storage_root() / asset.storage_key).resolve()
    if _storage_root() not in path.parents:
        raise HTTPException(status_code=400, detail="Audio reference is invalid.")
    try:
        provider = await build_user_provider("stt", user, db, get_settings())
        result = await provider.transcribe(
            SpeechToTextRequest(
                audio_bytes=path.read_bytes(),
                mime_type=asset.mime_type,
                language="en",
                fixture=fixture,
            )
        )
    except VoiceProviderTimeout as error:
        turn.transcription_status = "failed"
        turn.failure_category = "timeout"
        await db.commit()
        raise HTTPException(status_code=504, detail=str(error)) from error
    except VoiceProviderRateLimited as error:
        turn.transcription_status = "failed"
        turn.failure_category = "provider_rate_limit"
        await db.commit()
        raise HTTPException(status_code=429, detail=str(error)) from error
    except (VoiceProviderUnavailable, VoiceProviderMalformed) as error:
        turn.transcription_status = "failed"
        turn.failure_category = "provider"
        await db.commit()
        raise HTTPException(status_code=503, detail=str(error)) from error
    turn.transcript = result.transcript
    turn.transcription_status = "transcript_ready"
    turn.detected_language = result.detected_language
    turn.stt_provider = result.provider
    turn.stt_model = result.model
    turn.stt_operation_id = operation_id
    db.add(
        VoiceUsageRecord(
            user_id=user.id,
            session_id=turn.session_id,
            turn_id=turn.id,
            provider=result.provider,
            model=result.model,
            operation="transcribe",
            audio_duration_seconds=asset.duration_seconds,
            request_status="success",
            provider_usage=result.provider_usage,
        )
    )
    await db.commit()
    return _turn_response(turn)


@router.patch("/turns/{turn_id}/transcript")
async def edit_transcript(
    turn_id: str,
    payload: VoiceTranscriptUpdate,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, object]:
    turn = await _owned_turn(turn_id, user.id, db)
    if turn.transcription_status != "transcript_ready":
        raise HTTPException(status_code=409, detail="A recognised transcript is required first.")
    turn.edited_transcript = payload.transcript.strip()
    await db.commit()
    return _turn_response(turn)


@router.post("/turns/{turn_id}/submit")
async def submit_transcript(
    turn_id: str,
    payload: VoiceSubmitRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, object]:
    turn = await _owned_turn(turn_id, user.id, db)
    text = (turn.edited_transcript or turn.transcript or "").strip()
    if not text:
        raise HTTPException(status_code=409, detail="Review a transcript before sending it.")
    result = await send_message(
        turn.conversation_id,
        TutorMessageRequest(text=text, client_operation_id=payload.client_operation_id),
        user,
        db,
    )
    turn.tutor_message_id = result.id
    turn.transcription_status = "submitted"
    await db.commit()
    return {
        "turn": _turn_response(turn),
        "learner_text": text,
        "message": result.model_dump(mode="json"),
    }


@router.post("/turns/{turn_id}/synthesise")
async def synthesise(
    turn_id: str,
    payload: VoiceSynthesisRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, object]:
    turn = await _owned_turn(turn_id, user.id, db)
    if turn.synthesis_operation_id == payload.client_operation_id and turn.tutor_audio_id:
        return {"audio_id": turn.tutor_audio_id, "status": "ready"}
    if turn.tutor_message_id is None:
        raise HTTPException(status_code=409, detail="Submit the transcript to the tutor first.")
    existing = await db.scalar(
        select(AudioAsset).where(AudioAsset.turn_id == turn.id, AudioAsset.asset_type == "tutor")
    )
    if existing is not None:
        return {"audio_id": existing.id, "mime_type": existing.mime_type, "status": existing.status}
    message = await db.scalar(
        select(TutorMessage).where(
            TutorMessage.id == turn.tutor_message_id,
            TutorMessage.conversation_id == turn.conversation_id,
        )
    )
    if message is None:
        raise HTTPException(status_code=404, detail="Tutor response not found.")
    structured = message.structured_response or {}
    text = {
        "reply": message.tutor_reply,
        "correction": structured.get("corrected_sentence"),
        "alternative": structured.get("natural_alternative"),
    }.get(payload.text_kind)
    text = (text or message.tutor_reply or "").strip()
    if len(text) > get_settings().tts_max_text_characters:
        raise HTTPException(status_code=413, detail="Tutor audio text is too long.")
    if (
        await _daily_synthesis_characters(user.id, db) + len(text)
        > get_settings().voice_daily_synthesis_characters
    ):
        raise HTTPException(status_code=429, detail="Daily tutor-audio safety limit reached.")
    try:
        provider = await build_user_provider("tts", user, db, get_settings())
        result = await provider.synthesise(
            TextToSpeechRequest(
                text=text,
                voice=get_settings().tts_voice,
                speed=1.0,
            )
        )
    except VoiceProviderTimeout as error:
        turn.synthesis_status = "failed"
        turn.failure_category = "timeout"
        await db.commit()
        raise HTTPException(status_code=504, detail=str(error)) from error
    except VoiceProviderRateLimited as error:
        turn.synthesis_status = "failed"
        turn.failure_category = "provider_rate_limit"
        await db.commit()
        raise HTTPException(status_code=429, detail=str(error)) from error
    except (VoiceProviderUnavailable, VoiceProviderMalformed) as error:
        turn.synthesis_status = "failed"
        turn.failure_category = "provider"
        await db.commit()
        raise HTTPException(status_code=503, detail=str(error)) from error
    extension = {
        "audio/mpeg": ".mp3",
        "audio/mp3": ".mp3",
        "audio/wav": ".wav",
        "audio/wave": ".wav",
        "audio/ogg": ".ogg",
        "audio/opus": ".opus",
    }.get(result.mime_type, ".audio")
    asset = AudioAsset(
        user_id=user.id,
        session_id=turn.session_id,
        turn_id=turn.id,
        asset_type="tutor",
        storage_key=f"tutor/{secrets.token_urlsafe(24)}{extension}",
        mime_type=result.mime_type,
        byte_size=len(result.audio_bytes),
        duration_seconds=result.duration_seconds,
        provider=result.provider,
        model=result.model,
        expires_at=datetime.now(UTC)
        + timedelta(minutes=get_settings().voice_temp_audio_retention_minutes),
    )
    path = _storage_root() / asset.storage_key
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(result.audio_bytes)
    turn.synthesis_status = "ready"
    session = await _owned_session(turn.session_id, user.id, db)
    session.total_tutor_audio_seconds += result.duration_seconds
    db.add(asset)
    await db.flush()
    turn.tutor_audio_id = asset.id
    turn.synthesis_operation_id = payload.client_operation_id
    db.add(
        VoiceUsageRecord(
            user_id=user.id,
            session_id=turn.session_id,
            turn_id=turn.id,
            provider=result.provider,
            model=result.model,
            operation="synthesise",
            synthesis_characters=len(text),
            request_status="success",
            provider_usage={"characters": len(text)},
        )
    )
    await db.commit()
    return {
        "audio_id": asset.id,
        "mime_type": asset.mime_type,
        "duration_seconds": asset.duration_seconds,
        "status": asset.status,
    }


@router.get("/audio/{audio_id}")
async def get_audio(
    audio_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> FileResponse:
    asset = await db.scalar(
        select(AudioAsset).where(AudioAsset.id == audio_id, AudioAsset.user_id == user.id)
    )
    if asset is None:
        raise HTTPException(status_code=404, detail="Audio is no longer available.")
    expires_at = (
        asset.expires_at.replace(tzinfo=UTC)
        if asset.expires_at.tzinfo is None
        else asset.expires_at
    )
    if expires_at < datetime.now(UTC):
        raise HTTPException(status_code=404, detail="Audio is no longer available.")
    path = (_storage_root() / asset.storage_key).resolve()
    if _storage_root() not in path.parents or not path.is_file():
        raise HTTPException(status_code=404, detail="Audio is no longer available.")
    return FileResponse(
        path,
        media_type=asset.mime_type,
        filename=Path(asset.storage_key).name,
    )


@router.post("/sessions/{session_id}/complete")
async def complete_session(
    session_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> dict[str, object]:
    session = await _owned_session(session_id, user.id, db)
    session.status = "completed"
    session.completed_at = datetime.now(UTC)
    await db.commit()
    return _session_response(session)


@router.get("/preferences")
async def get_preferences(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> dict[str, object]:
    preference = await db.scalar(select(VoicePreference).where(VoicePreference.user_id == user.id))
    if preference is None:
        preference = VoicePreference(user_id=user.id)
        db.add(preference)
        await db.commit()
    return {
        "voice": preference.voice,
        "auto_play": preference.auto_play,
        "playback_speed": preference.playback_speed,
        "transcript_visible": preference.transcript_visible,
        "recording_mode": preference.recording_mode,
    }


@router.put("/preferences")
async def update_preferences(
    payload: VoicePreferenceUpdate,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, object]:
    preference = await db.scalar(select(VoicePreference).where(VoicePreference.user_id == user.id))
    if preference is None:
        preference = VoicePreference(user_id=user.id)
        db.add(preference)
    preference.voice = payload.voice
    preference.auto_play = payload.auto_play
    preference.playback_speed = payload.playback_speed
    preference.transcript_visible = payload.transcript_visible
    preference.recording_mode = payload.recording_mode
    await db.commit()
    return {
        "voice": preference.voice,
        "auto_play": preference.auto_play,
        "playback_speed": preference.playback_speed,
        "transcript_visible": preference.transcript_visible,
        "recording_mode": preference.recording_mode,
    }


@router.delete("/retention/expired", include_in_schema=False)
async def cleanup_expired_audio(db: AsyncSession = Depends(get_db)) -> dict[str, int]:
    assets = (await db.scalars(select(AudioAsset))).all()
    removed = 0
    root = _storage_root()
    for asset in assets:
        expires_at = (
            asset.expires_at.replace(tzinfo=UTC)
            if asset.expires_at.tzinfo is None
            else asset.expires_at
        )
        if expires_at >= datetime.now(UTC):
            continue
        path = (root / asset.storage_key).resolve()
        if root in path.parents and path.is_file():
            path.unlink()
        await db.delete(asset)
        removed += 1
    await db.commit()
    return {"removed": removed}
