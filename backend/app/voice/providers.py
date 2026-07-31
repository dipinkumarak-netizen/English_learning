from __future__ import annotations

import io
import wave
from dataclasses import dataclass
from typing import Protocol

from app.core.config import Settings


class VoiceProviderError(Exception):
    """Sanitised provider boundary error."""


class VoiceProviderUnavailable(VoiceProviderError):
    pass


class VoiceProviderTimeout(VoiceProviderError):
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


def build_stt_provider(settings: Settings) -> SpeechToTextProvider:
    if not settings.stt_enabled or settings.stt_provider in {"", "none"}:
        return DisabledSpeechToTextProvider()
    if settings.stt_provider == "mock":
        return MockSpeechToTextProvider()
    raise VoiceProviderUnavailable("The configured speech provider is unsupported.")


def build_tts_provider(settings: Settings) -> TextToSpeechProvider:
    if not settings.tts_enabled or settings.tts_provider in {"", "none"}:
        return DisabledTextToSpeechProvider()
    if settings.tts_provider == "mock":
        return MockTextToSpeechProvider()
    raise VoiceProviderUnavailable("The configured speech provider is unsupported.")
