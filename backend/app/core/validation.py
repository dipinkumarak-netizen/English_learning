from __future__ import annotations

from ipaddress import ip_network
from urllib.parse import unquote, urlparse

from app.core.config import Settings
from app.provider_crypto import CredentialConfigurationError, _master_key


def validate_settings(settings: Settings) -> list[str]:
    """Return safe configuration categories; never include secret values."""
    errors: list[str] = []
    if settings.public_base_url:
        public_url = urlparse(settings.public_base_url)
        if (
            public_url.scheme != "https"
            or not public_url.hostname
            or public_url.username
            or public_url.password
            or public_url.query
            or public_url.fragment
        ):
            errors.append("public_base_url_must_be_https")
    if settings.trust_proxy_headers:
        if not settings.trusted_proxy_networks.strip():
            errors.append("trusted_proxy_networks_missing")
        else:
            for network in settings.trusted_proxy_networks.split(","):
                try:
                    ip_network(network.strip(), strict=False)
                except ValueError:
                    errors.append("trusted_proxy_networks_invalid")
                    break
        if not settings.public_base_url:
            errors.append("public_base_url_missing")
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
