from __future__ import annotations

from urllib.parse import unquote, urlparse

from app.core.config import Settings
from app.provider_crypto import CredentialConfigurationError, _master_key


def validate_settings(settings: Settings) -> list[str]:
    """Return safe configuration categories; never include secret values."""
    errors: list[str] = []
    if not settings.database_url:
        errors.append("database_url_missing")
    else:
        parsed = urlparse(settings.database_url)
        if parsed.scheme not in {"postgresql", "postgresql+asyncpg"} or not parsed.hostname:
            errors.append("database_url_invalid")
        if settings.database_expected_host and parsed.hostname != settings.database_expected_host:
            errors.append("database_host_unexpected")
    if len(settings.jwt_secret.encode("utf-8")) < 32:
        errors.append("jwt_secret_invalid")
    try:
        _master_key(settings.credential_encryption_key)
    except CredentialConfigurationError:
        errors.append("credential_encryption_key_invalid")

    providers = (
        ("ai", settings.ai_provider, settings.ai_provider_enabled, settings.ai_api_key),
        ("stt", settings.stt_provider, settings.stt_enabled, settings.stt_api_key),
        ("tts", settings.tts_provider, settings.tts_enabled, settings.tts_api_key),
    )
    for capability, provider, enabled, api_key in providers:
        if provider not in {"none", "mock", "openai"}:
            errors.append(f"{capability}_provider_invalid")
        if enabled and provider == "none":
            errors.append(f"{capability}_provider_disabled")
        if enabled and provider == "openai" and not api_key:
            errors.append(f"{capability}_provider_credential_missing")
    return errors


def validate_database_credentials(
    database_url: str,
    postgres_password: str | None,
    expected_host: str | None = None,
    postgres_user: str | None = None,
    postgres_db: str | None = None,
) -> list[str]:
    """Validate deployment env consistency without returning passwords."""
    errors: list[str] = []
    if postgres_password is None:
        errors.append("postgres_password_missing")
    if not postgres_user:
        errors.append("postgres_user_missing")
    if not postgres_db:
        errors.append("postgres_db_missing")
    parsed = urlparse(database_url)
    if parsed.scheme not in {"postgresql", "postgresql+asyncpg"} or not parsed.hostname:
        return [*errors, "database_url_invalid"]
    if expected_host and parsed.hostname != expected_host:
        errors.append("database_host_unexpected")
    if postgres_password is not None and unquote(parsed.password or "") != postgres_password:
        errors.append("database_password_mismatch")
    return errors
