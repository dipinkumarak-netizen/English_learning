from __future__ import annotations

import io
import wave
from dataclasses import dataclass
from typing import Protocol

import httpx

from app.core.config import Settings


class VoiceProviderError(Exception):
    """Sanitised provider boundary error."""


class VoiceProviderUnavailable(VoiceProviderError):
    pass


class VoiceProviderTimeout(VoiceProviderError):
    pass


class VoiceProviderRateLimited(VoiceProviderError):
    pass


class VoiceProviderMalformed(VoiceProviderError):
    pass


@dataclass(frozen=True)
class SpeechToTextRequest:
    audio_bytes: bytes
    mime_type: str
    language: str
    fixture: str | None = None


@dataclass(frozen=True)
class SpeechToTextResult:
    transcript: str
    detected_language: str | None
    duration_seconds: int
    provider: str
    model: str
    warnings: list[str]
    provider_usage: dict[str, int]


class SpeechToTextProvider(Protocol):
    name: str
    model: str

    async def transcribe(self, request: SpeechToTextRequest) -> SpeechToTextResult: ...


@dataclass(frozen=True)
class TextToSpeechRequest:
    text: str
    voice: str
    speed: float


@dataclass(frozen=True)
class TextToSpeechResult:
    audio_bytes: bytes
    mime_type: str
    duration_seconds: int
    voice: str
    provider: str
    model: str


class TextToSpeechProvider(Protocol):
    name: str
    model: str

    async def synthesise(self, request: TextToSpeechRequest) -> TextToSpeechResult: ...


class DisabledSpeechToTextProvider:
    name = "disabled"
    model = "disabled"

    async def transcribe(self, request: SpeechToTextRequest) -> SpeechToTextResult:
        raise VoiceProviderUnavailable("Speech transcription is not configured.")


class DisabledTextToSpeechProvider:
    name = "disabled"
    model = "disabled"

    async def synthesise(self, request: TextToSpeechRequest) -> TextToSpeechResult:
        raise VoiceProviderUnavailable("Tutor audio is not configured.")


class MockSpeechToTextProvider:
    name = "mock"
    model = "mock-stt-v1"

    async def transcribe(self, request: SpeechToTextRequest) -> SpeechToTextResult:
        fixture = request.fixture or "english_success"
        transcripts = {
            "english_success": ("I would like to practise English today.", "en"),
            "mixed_ml_en": ("എനിക്ക് English practise ചെയ്യണം.", "ml-en"),
            "unclear": ("I would like to practise English today.", None),
        }
        if fixture == "empty_audio":
            raise VoiceProviderMalformed("The audio did not contain speech.")
        if fixture == "timeout":
            raise VoiceProviderTimeout("Speech transcription timed out.")
        if fixture == "unavailable":
            raise VoiceProviderUnavailable("Speech transcription is temporarily unavailable.")
        if fixture == "invalid_audio":
            raise VoiceProviderMalformed("The audio format could not be read.")
        transcript, language = transcripts.get(fixture, transcripts["english_success"])
        return SpeechToTextResult(
            transcript=transcript,
            detected_language=language,
            duration_seconds=1,
            provider=self.name,
            model=self.model,
            warnings=["Speech confidence was not provided by the mock provider."]
            if fixture == "unclear"
            else [],
            provider_usage={"audio_seconds": 1},
        )


class MockTextToSpeechProvider:
    name = "mock"
    model = "mock-tts-v1"

    async def synthesise(self, request: TextToSpeechRequest) -> TextToSpeechResult:
        if not request.text.strip():
            raise VoiceProviderMalformed("Tutor audio text is empty.")
        if request.text.strip().lower() == "timeout":
            raise VoiceProviderTimeout("Tutor audio timed out.")
        if request.text.strip().lower() == "failure":
            raise VoiceProviderMalformed("Tutor audio could not be created.")
        buffer = io.BytesIO()
        with wave.open(buffer, "wb") as output:
            output.setnchannels(1)
            output.setsampwidth(2)
            output.setframerate(8_000)
            output.writeframes(b"\x00\x00" * 8_000)
        return TextToSpeechResult(
            audio_bytes=buffer.getvalue(),
            mime_type="audio/wav",
            duration_seconds=1,
            voice=request.voice,
            provider=self.name,
            model=self.model,
        )


def _api_key(settings: Settings, specific: str) -> str:
    return specific or settings.ai_api_key


def _base_url(configured: str) -> str:
    return (configured or "https://api.openai.com/v1").rstrip("/")


def _provider_error(response: httpx.Response, operation: str) -> VoiceProviderError:
    if response.status_code == 429:
        return VoiceProviderRateLimited(f"{operation} provider rate limit reached.")
    if response.status_code >= 500:
        return VoiceProviderUnavailable(f"{operation} provider is temporarily unavailable.")
    return VoiceProviderMalformed(f"{operation} provider rejected the request.")


class OpenAISpeechToTextProvider:
    name = "openai"

    def __init__(self, settings: Settings) -> None:
        self.model = settings.stt_model
        self._api_key = _api_key(settings, settings.stt_api_key)
        self._url = f"{_base_url(settings.stt_base_url)}/audio/transcriptions"
        self._timeout = settings.stt_request_timeout_seconds

    async def transcribe(self, request: SpeechToTextRequest) -> SpeechToTextResult:
        if not self._api_key:
            raise VoiceProviderUnavailable("Speech transcription is not configured.")
        if not request.audio_bytes:
            raise VoiceProviderMalformed("The uploaded audio is empty.")
        filename = "recording.m4a" if request.mime_type != "audio/aac" else "recording.aac"
        try:
            async with httpx.AsyncClient(timeout=self._timeout) as client:
                response = await client.post(
                    self._url,
                    headers={"Authorization": f"Bearer {self._api_key}"},
                    files={"file": (filename, request.audio_bytes, request.mime_type)},
                    # Leave language unset so the provider can detect mixed speech.
                    data={"model": self.model},
                )
        except httpx.TimeoutException as error:
            raise VoiceProviderTimeout("Speech transcription timed out.") from error
        except httpx.HTTPError as error:
            raise VoiceProviderUnavailable(
                "Speech transcription is temporarily unavailable."
            ) from error
        if response.status_code != 200:
            raise _provider_error(response, "Speech transcription")
        try:
            payload = response.json()
            transcript = payload.get("text")
            if not isinstance(transcript, str) or not transcript.strip():
                raise ValueError("missing text")
            usage = payload.get("usage") or {}
            audio_seconds = usage.get("seconds") or usage.get("duration") or 0
            return SpeechToTextResult(
                transcript=transcript.strip(),
                detected_language=payload.get("language")
                if isinstance(payload.get("language"), str)
                else None,
                duration_seconds=int(audio_seconds or 0),
                provider=self.name,
                model=self.model,
                warnings=[],
                provider_usage={"audio_seconds": int(audio_seconds or 0)},
            )
        except (ValueError, TypeError, AttributeError) as error:
            raise VoiceProviderMalformed(
                "Speech transcription returned an invalid response."
            ) from error


class OpenAITextToSpeechProvider:
    name = "openai"
    allowed_voices = {
        "alloy",
        "ash",
        "coral",
        "echo",
        "fable",
        "nova",
        "onyx",
        "sage",
        "shimmer",
        "marin",
        "cedar",
    }

    def __init__(self, settings: Settings) -> None:
        self.model = settings.tts_model
        self._api_key = _api_key(settings, settings.tts_api_key)
        self._url = f"{_base_url(settings.tts_base_url)}/audio/speech"
        self._timeout = settings.tts_request_timeout_seconds

    async def synthesise(self, request: TextToSpeechRequest) -> TextToSpeechResult:
        if not self._api_key:
            raise VoiceProviderUnavailable("Tutor audio is not configured.")
        if not request.text.strip():
            raise VoiceProviderMalformed("Tutor audio text is empty.")
        if request.voice not in self.allowed_voices:
            raise VoiceProviderMalformed("The configured tutor voice is not allowed.")
        try:
            async with httpx.AsyncClient(timeout=self._timeout) as client:
                response = await client.post(
                    self._url,
                    headers={"Authorization": f"Bearer {self._api_key}"},
                    json={
                        "model": self.model,
                        "input": request.text,
                        "voice": request.voice,
                        "response_format": "mp3",
                        "speed": request.speed,
                    },
                )
        except httpx.TimeoutException as error:
            raise VoiceProviderTimeout("Tutor audio timed out.") from error
        except httpx.HTTPError as error:
            raise VoiceProviderUnavailable("Tutor audio is temporarily unavailable.") from error
        if response.status_code != 200:
            raise _provider_error(response, "Tutor audio")
        if not response.content or not response.headers.get("content-type", "").startswith(
            "audio/"
        ):
            raise VoiceProviderMalformed("Tutor audio returned an invalid audio response.")
        mime_type = response.headers.get("content-type", "audio/mpeg").split(";", 1)[0]
        if mime_type not in {
            "audio/mpeg",
            "audio/mp3",
            "audio/wav",
            "audio/wave",
            "audio/ogg",
            "audio/opus",
        }:
            raise VoiceProviderMalformed("Tutor audio returned an unsupported audio format.")
        return TextToSpeechResult(
            audio_bytes=response.content,
            mime_type=mime_type,
            duration_seconds=0,
            voice=request.voice,
            provider=self.name,
            model=self.model,
        )


def build_stt_provider(settings: Settings) -> SpeechToTextProvider:
    if not settings.stt_enabled or settings.stt_provider in {"", "none"}:
        return DisabledSpeechToTextProvider()
    if settings.stt_provider == "mock":
        return MockSpeechToTextProvider()
    if settings.stt_provider == "openai":
        return OpenAISpeechToTextProvider(settings)
    raise VoiceProviderUnavailable("The configured speech provider is unsupported.")


def build_tts_provider(settings: Settings) -> TextToSpeechProvider:
    if not settings.tts_enabled or settings.tts_provider in {"", "none"}:
        return DisabledTextToSpeechProvider()
    if settings.tts_provider == "mock":
        return MockTextToSpeechProvider()
    if settings.tts_provider == "openai":
        return OpenAITextToSpeechProvider(settings)
    raise VoiceProviderUnavailable("The configured speech provider is unsupported.")
