import base64
import os

from fastapi.testclient import TestClient

from app.core.config import Settings
from app.core.validation import validate_database_credentials, validate_settings


def valid_settings(**overrides: object) -> Settings:
    values: dict[str, object] = {
        "app_env": "production",
        "database_url": "postgresql+asyncpg://nilaspeak:password@db:5432/nilaspeak",
        "jwt_secret": "j" * 48,
        "credential_encryption_key": base64.urlsafe_b64encode(os.urandom(32)).decode(),
        "ai_provider": "none",
        "stt_provider": "none",
        "tts_provider": "none",
    }
    values.update(overrides)
    return Settings(**values)


def test_production_config_validation_rejects_missing_and_invalid_values() -> None:
    errors = validate_settings(
        Settings(
            app_env="production",
            database_url="",
            jwt_secret="short",
            credential_encryption_key="invalid",
            ai_provider="openai",
            ai_provider_enabled=True,
        )
    )
    assert "database_url_missing" in errors
    assert "jwt_secret_invalid" in errors
    assert "credential_encryption_key_invalid" in errors
    assert "ai_provider_credential_missing" in errors


def test_production_config_accepts_valid_disabled_provider_configuration() -> None:
    assert validate_settings(valid_settings()) == []


def test_database_consistency_check_never_returns_password() -> None:
    errors = validate_database_credentials(
        "postgresql+asyncpg://nilaspeak:actual@db:5432/nilaspeak",
        "different",
        "db",
        "nilaspeak",
        "nilaspeak",
    )
    assert errors == ["database_password_mismatch"]
    assert all("actual" not in item and "different" not in item for item in errors)


def test_readiness_reports_safe_success_schema(client: TestClient) -> None:
    response = client.get("/ready")
    assert response.status_code == 200
    assert response.json() == {
        "status": "ready",
        "checks": {"application": "ok", "database": "ok", "configuration": "ok"},
    }
