from fastapi import Request

from app.core.config import Settings
from app.core.transport import effective_scheme
from app.core.validation import validate_settings


def _request(client_ip: str, scheme: str = "http", forwarded: str | None = None) -> Request:
    headers = [] if forwarded is None else [(b"x-forwarded-proto", forwarded.encode())]
    return Request(
        {
            "type": "http",
            "scheme": scheme,
            "server": ("backend", 8000),
            "client": (client_ip, 40000),
            "headers": headers,
            "path": "/api/v1/capabilities",
            "raw_path": b"/api/v1/capabilities",
            "query_string": b"",
            "root_path": "",
        }
    )


def test_forwarded_proto_is_ignored_for_direct_clients() -> None:
    settings = Settings(trust_proxy_headers=True, trusted_proxy_networks="10.0.0.0/8")
    assert effective_scheme(_request("192.168.1.20", forwarded="https"), settings) == "http"


def test_forwarded_proto_is_accepted_only_from_trusted_proxy() -> None:
    settings = Settings(trust_proxy_headers=True, trusted_proxy_networks="10.0.0.0/8")
    assert effective_scheme(_request("10.1.2.3", forwarded="https"), settings) == "https"
    assert effective_scheme(_request("172.16.0.2", forwarded="https"), settings) == "http"


def test_direct_https_is_accepted_without_forwarding_headers() -> None:
    settings = Settings()
    assert effective_scheme(_request("192.168.1.20", scheme="https"), settings) == "https"


def test_malformed_proxy_configuration_is_reported_without_secrets() -> None:
    settings = Settings(
        app_env="production",
        jwt_secret="x" * 40,
        database_url="postgresql+asyncpg://user:pass@db:5432/app",
        credential_encryption_key="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
        trust_proxy_headers=True,
        trusted_proxy_networks="not-a-network",
        public_base_url="http://example.invalid",
    )
    errors = validate_settings(settings)
    assert "trusted_proxy_networks_invalid" in errors
    assert "public_base_url_must_be_https" in errors


def test_capability_endpoint_has_safe_contract(client, monkeypatch) -> None:
    monkeypatch.setenv("APP_ENV", "production")
    from app.core.config import get_settings

    get_settings.cache_clear()
    registered = client.post(
        "/api/v1/auth/register",
        json={"email": "phase7@example.com", "password": "Password123", "display_name": "Learner"},
    )
    assert registered.status_code == 201
    response = client.get(
        "/api/v1/capabilities",
        headers={"Authorization": f"Bearer {registered.json()['access_token']}"},
    )
    assert response.status_code == 200
    body = response.json()
    assert body["transport_state"] == "private_http"
    assert body["provider_mutations_allowed"] is False
    assert set(body["ai"]) == {"state", "credential_source", "usable", "enabled", "provider"}
    assert "api_key" not in response.text
    assert "database" not in response.text
