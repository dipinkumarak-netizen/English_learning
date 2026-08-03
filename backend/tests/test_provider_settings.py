import asyncio
import base64
import os

import pytest
from conftest import test_session_factory
from sqlalchemy import select

from app.models import ProviderCredential
from app.provider_crypto import decrypt_credential, encrypt_credential


def register(client, email: str) -> dict:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": "SafePass123", "display_name": "Learner"},
    )
    assert response.status_code == 201
    return response.json()


def headers(auth: dict) -> dict[str, str]:
    return {"Authorization": f"Bearer {auth['access_token']}"}


def test_encryption_is_authenticated_and_round_trips() -> None:
    encoded = base64.urlsafe_b64encode(os.urandom(32)).decode()
    ciphertext = encrypt_credential("fixture-value-1234", encoded)
    assert "fixture-value-1234" not in ciphertext
    assert decrypt_credential(ciphertext, encoded) == "fixture-value-1234"
    with pytest.raises(Exception):
        decrypt_credential(ciphertext[:-1] + "A", encoded)


def test_provider_key_is_encrypted_and_never_returned(client, monkeypatch) -> None:
    encoded = base64.urlsafe_b64encode(os.urandom(32)).decode()
    monkeypatch.setenv("CREDENTIAL_ENCRYPTION_KEY", encoded)
    from app.core.config import get_settings

    get_settings.cache_clear()
    auth = register(client, "provider-owner@example.com")
    response = client.put(
        "/api/v1/settings/providers/ai",
        headers=headers(auth),
        json={
            "provider": "openai",
            "api_key": "fixture-value-1234",
            "model": "gpt-test",
            "enabled": True,
        },
    )
    assert response.status_code == 200
    body = response.json()
    assert body["providers"][0]["key_last4"] == "1234"
    assert "fixture-value-1234" not in response.text
    assert "encrypted_api_key" not in response.text

    async def read_credential() -> ProviderCredential:
        async with test_session_factory() as session:
            return await session.scalar(select(ProviderCredential))

    credential = asyncio.run(read_credential())
    assert credential.encrypted_api_key != "fixture-value-1234"
    assert decrypt_credential(credential.encrypted_api_key, encoded) == "fixture-value-1234"


def test_provider_settings_are_owned_and_deleteable(client, monkeypatch) -> None:
    encoded = base64.urlsafe_b64encode(os.urandom(32)).decode()
    monkeypatch.setenv("CREDENTIAL_ENCRYPTION_KEY", encoded)
    from app.core.config import get_settings

    get_settings.cache_clear()
    owner = register(client, "provider-owner-2@example.com")
    other = register(client, "provider-other@example.com")
    assert (
        client.put(
            "/api/v1/settings/providers/stt",
            headers=headers(owner),
            json={"provider": "mock", "api_key": "owner-key", "enabled": True},
        ).status_code
        == 200
    )
    other_settings = client.get("/api/v1/settings/providers", headers=headers(other))
    assert all(item["key_last4"] is None for item in other_settings.json()["providers"])
    deleted = client.delete("/api/v1/settings/providers/stt", headers=headers(owner))
    assert deleted.status_code == 200
    assert deleted.json()["providers"][1]["configured"] is False


def test_provider_test_invalid_provider_and_rate_limit(client, monkeypatch) -> None:
    monkeypatch.setenv(
        "CREDENTIAL_ENCRYPTION_KEY", base64.urlsafe_b64encode(os.urandom(32)).decode()
    )
    monkeypatch.setenv("PROVIDER_SETTINGS_RATE_LIMIT_PER_HOUR", "1")
    from app.core.config import get_settings

    get_settings.cache_clear()
    auth = register(client, "provider-rate@example.com")
    test_response = client.post(
        "/api/v1/settings/providers/ai/test",
        headers=headers(auth),
        json={"provider": "mock"},
    )
    assert test_response.status_code == 200
    assert test_response.json()["status"] == "success"
    limited = client.post(
        "/api/v1/settings/providers/ai/test",
        headers=headers(auth),
        json={"provider": "mock"},
    )
    assert limited.status_code == 429
    invalid = client.put(
        "/api/v1/settings/providers/ai",
        headers=headers(auth),
        json={"provider": "unsupported", "enabled": True},
    )
    assert invalid.status_code == 422
