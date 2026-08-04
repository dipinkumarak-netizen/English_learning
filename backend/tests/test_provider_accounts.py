import base64
import os

from app.core.config import get_settings


def _register(client, email: str) -> dict:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": "SafePass123", "display_name": "Learner"},
    )
    assert response.status_code == 201
    return response.json()


def _headers(auth: dict) -> dict[str, str]:
    return {"Authorization": f"Bearer {auth['access_token']}"}


def test_shared_account_capability_assignment_and_dependency_delete(client, monkeypatch) -> None:
    monkeypatch.setenv("APP_ENV", "development")
    monkeypatch.setenv(
        "CREDENTIAL_ENCRYPTION_KEY", base64.urlsafe_b64encode(os.urandom(32)).decode()
    )
    get_settings.cache_clear()
    auth = _register(client, "account-owner@example.com")
    headers = _headers(auth)
    created = client.post(
        "/api/v1/settings/provider-accounts",
        headers=headers,
        json={"provider": "gemini", "api_key": "gemini-secret-1234"},
    )
    assert created.status_code == 201
    account = created.json()["accounts"][0]
    assert account["key_last4"] == "1234"
    assert "gemini-secret" not in created.text
    for capability in ("ai", "tts"):
        response = client.put(
            f"/api/v1/settings/provider-capabilities/{capability}",
            headers=headers,
            json={
                "provider": "gemini",
                "provider_account_id": account["id"],
                "enabled": True,
                "model": "gemini-2.5-flash",
            },
        )
        assert response.status_code == 200
    blocked = client.delete(f"/api/v1/settings/provider-accounts/{account['id']}", headers=headers)
    assert blocked.status_code == 409


def test_account_ownership_and_secure_transport(client, monkeypatch) -> None:
    monkeypatch.setenv("APP_ENV", "production")
    monkeypatch.setenv(
        "CREDENTIAL_ENCRYPTION_KEY", base64.urlsafe_b64encode(os.urandom(32)).decode()
    )
    get_settings.cache_clear()
    owner = _register(client, "account-owner-2@example.com")
    other = _register(client, "account-other@example.com")
    response = client.post(
        "/api/v1/settings/provider-accounts",
        headers=_headers(owner),
        json={"provider": "openai", "api_key": "openai-secret-1234"},
    )
    assert response.status_code == 400
    monkeypatch.setenv("APP_ENV", "development")
    get_settings.cache_clear()
    response = client.post(
        "/api/v1/settings/provider-accounts",
        headers=_headers(owner),
        json={"provider": "openai", "api_key": "openai-secret-1234"},
    )
    account_id = response.json()["accounts"][0]["id"]
    assert (
        client.delete(
            f"/api/v1/settings/provider-accounts/{account_id}", headers=_headers(other)
        ).status_code
        == 404
    )
