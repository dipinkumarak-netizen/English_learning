import asyncio

import httpx
from conftest import get_settings

from app.core.config import Settings
from app.voice.providers import (
    MockSpeechToTextProvider,
    MockTextToSpeechProvider,
    OpenAISpeechToTextProvider,
    OpenAITextToSpeechProvider,
    SpeechToTextRequest,
    TextToSpeechRequest,
)


def register(client, email: str) -> dict:
    return client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": "Password123", "display_name": "Learner"},
    ).json()


def auth(auth: dict) -> dict[str, str]:
    return {"Authorization": f"Bearer {auth['access_token']}"}


def create_conversation(client, account: dict) -> dict:
    response = client.post(
        "/api/v1/tutor/conversations",
        headers=auth(account),
        json={"mode": "grammar_correction", "correction_mode": "important"},
    )
    assert response.status_code == 201
    return response.json()


def fake_m4a() -> bytes:
    return b"\x00\x00\x00\x18ftypM4A " + b"\x00" * 32


class StubProviderClient:
    def __init__(self, response: httpx.Response | Exception) -> None:
        self.response = response
        self.request: dict = {}

    async def __aenter__(self):
        return self

    async def __aexit__(self, *_):
        return False

    async def post(self, url: str, **kwargs):
        self.request = {"url": url, **kwargs}
        if isinstance(self.response, Exception):
            raise self.response
        return self.response


def test_mock_voice_providers_are_deterministic():
    async def run() -> None:
        stt = await MockSpeechToTextProvider().transcribe(
            SpeechToTextRequest(fake_m4a(), "audio/mp4", "en")
        )
        tts = await MockTextToSpeechProvider().synthesise(
            TextToSpeechRequest("Keep practising.", "default", 1.0)
        )
        assert stt.transcript == "I would like to practise English today."
        assert tts.mime_type == "audio/wav"
        assert tts.audio_bytes[:4] == b"RIFF"

    asyncio.run(run())


def test_openai_provider_adapters_build_requests_and_parse_responses(monkeypatch):
    stt_response = httpx.Response(
        200,
        json={"text": "Actual spoken text.", "language": "en"},
        request=httpx.Request("POST", "https://provider.test/v1/audio/transcriptions"),
    )
    stt_client = StubProviderClient(stt_response)
    monkeypatch.setattr("app.voice.providers.httpx.AsyncClient", lambda **_: stt_client)
    settings = Settings(
        stt_enabled=True,
        stt_provider="openai",
        stt_model="transcribe-test",
        stt_api_key="test-key",
        stt_base_url="https://provider.test/v1",
    )

    async def run() -> None:
        result = await OpenAISpeechToTextProvider(settings).transcribe(
            SpeechToTextRequest(b"audio", "audio/mp4", "en")
        )
        assert result.transcript == "Actual spoken text."
        assert stt_client.request["url"].endswith("/audio/transcriptions")
        assert stt_client.request["data"]["model"] == "transcribe-test"
        assert stt_client.request["files"]["file"][2] == "audio/mp4"

    asyncio.run(run())

    tts_response = httpx.Response(
        200,
        content=b"ID3real-audio",
        headers={"content-type": "audio/mpeg"},
        request=httpx.Request("POST", "https://provider.test/v1/audio/speech"),
    )
    tts_client = StubProviderClient(tts_response)
    monkeypatch.setattr("app.voice.providers.httpx.AsyncClient", lambda **_: tts_client)
    tts_settings = settings.model_copy(
        update={
            "tts_enabled": True,
            "tts_provider": "openai",
            "tts_model": "synthesis-test",
            "tts_api_key": "test-key",
            "tts_base_url": "https://provider.test/v1",
            "tts_voice": "alloy",
        }
    )

    async def synthesize() -> None:
        result = await OpenAITextToSpeechProvider(tts_settings).synthesise(
            TextToSpeechRequest("Actual tutor reply.", "alloy", 1.0)
        )
        assert result.audio_bytes.startswith(b"ID3")
        assert result.mime_type == "audio/mpeg"
        assert tts_client.request["json"]["response_format"] == "mp3"

    asyncio.run(synthesize())


def test_openai_provider_timeout_is_sanitised(monkeypatch):
    client = StubProviderClient(httpx.ReadTimeout("provider timed out"))
    monkeypatch.setattr("app.voice.providers.httpx.AsyncClient", lambda **_: client)
    settings = Settings(
        stt_enabled=True,
        stt_provider="openai",
        stt_model="transcribe-test",
        stt_api_key="test-key",
    )

    async def run() -> None:
        try:
            await OpenAISpeechToTextProvider(settings).transcribe(
                SpeechToTextRequest(b"audio", "audio/mp4", "en")
            )
        except Exception as error:
            assert str(error) == "Speech transcription timed out."
        else:
            raise AssertionError("Expected provider timeout")

    asyncio.run(run())


def test_authenticated_voice_flow_reuses_text_tutor_and_is_idempotent(client, monkeypatch):
    monkeypatch.setenv("AI_PROVIDER_ENABLED", "true")
    monkeypatch.setenv("AI_PROVIDER", "mock")
    monkeypatch.setenv("STT_ENABLED", "true")
    monkeypatch.setenv("STT_PROVIDER", "mock")
    monkeypatch.setenv("TTS_ENABLED", "true")
    monkeypatch.setenv("TTS_PROVIDER", "mock")
    get_settings.cache_clear()
    owner = register(client, "voice-owner@example.com")
    other = register(client, "voice-other@example.com")
    conversation = create_conversation(client, owner)
    headers = auth(owner)
    session = client.post(
        "/api/v1/voice/sessions",
        headers=headers,
        json={"conversation_id": conversation["id"], "recording_mode": "tap"},
    )
    assert session.status_code == 201
    session_id = session.json()["id"]
    turn = client.post(
        f"/api/v1/voice/sessions/{session_id}/turns",
        headers=headers,
        data={"client_operation_id": "voice-turn-operation-001"},
    )
    assert turn.status_code == 201
    turn_id = turn.json()["id"]
    duplicate_turn = client.post(
        f"/api/v1/voice/sessions/{session_id}/turns",
        headers=headers,
        data={"client_operation_id": "voice-turn-operation-001"},
    )
    assert duplicate_turn.json()["id"] == turn_id
    upload = client.post(
        f"/api/v1/voice/turns/{turn_id}/audio",
        headers=headers,
        files={"audio": ("recording.m4a", fake_m4a(), "audio/mp4")},
        data={"declared_duration_seconds": "1", "operation_id": "voice-upload-operation-001"},
    )
    assert upload.status_code == 200
    invalid = client.post(
        f"/api/v1/voice/turns/{turn_id}/audio",
        headers=headers,
        files={"audio": ("bad.m4a", b"not audio", "audio/mp4")},
        data={"declared_duration_seconds": "1", "operation_id": "voice-upload-operation-002"},
    )
    assert invalid.status_code == 409
    transcript = client.post(
        f"/api/v1/voice/turns/{turn_id}/transcribe?operation_id=voice-stt-operation-001&fixture=english_success",
        headers=headers,
    )
    assert transcript.status_code == 200
    assert transcript.json()["transcript"] == "I would like to practise English today."
    edited = client.patch(
        f"/api/v1/voice/turns/{turn_id}/transcript",
        headers=headers,
        json={"transcript": "I am going to practise English today."},
    )
    assert edited.status_code == 200
    submitted = client.post(
        f"/api/v1/voice/turns/{turn_id}/submit",
        headers=headers,
        json={"client_operation_id": "voice-submit-operation-001"},
    )
    assert submitted.status_code == 200
    assert submitted.json()["learner_text"] == "I am going to practise English today."
    duplicate = client.post(
        f"/api/v1/voice/turns/{turn_id}/submit",
        headers=headers,
        json={"client_operation_id": "voice-submit-operation-001"},
    )
    assert duplicate.status_code == 200
    synthesised = client.post(
        f"/api/v1/voice/turns/{turn_id}/synthesise",
        headers=headers,
        json={"client_operation_id": "voice-tts-operation-001"},
    )
    assert synthesised.status_code == 200
    audio = client.get(f"/api/v1/voice/audio/{synthesised.json()['audio_id']}", headers=headers)
    assert audio.status_code == 200
    assert audio.headers["content-type"] == "audio/wav"
    forbidden = client.get(f"/api/v1/voice/sessions/{session_id}", headers=auth(other))
    assert forbidden.status_code == 404


def test_voice_disabled_provider_and_invalid_upload(client, monkeypatch):
    monkeypatch.setenv("STT_ENABLED", "false")
    monkeypatch.setenv("STT_PROVIDER", "none")
    get_settings.cache_clear()
    account = register(client, "voice-disabled@example.com")
    conversation = create_conversation(client, account)
    session = client.post(
        "/api/v1/voice/sessions",
        headers=auth(account),
        json={"conversation_id": conversation["id"]},
    ).json()
    turn = client.post(
        f"/api/v1/voice/sessions/{session['id']}/turns",
        headers=auth(account),
        data={"client_operation_id": "disabled-turn-operation"},
    ).json()
    invalid = client.post(
        f"/api/v1/voice/turns/{turn['id']}/audio",
        headers=auth(account),
        files={"audio": ("recording.txt", b"hello", "text/plain")},
        data={"declared_duration_seconds": "1", "operation_id": "disabled-upload-operation"},
    )
    assert invalid.status_code == 415
