from functools import lru_cache

from pydantic import ValidationInfo, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_env: str = "development"
    app_version: str = "0.1.0"
    database_url: str = "sqlite+aiosqlite:///./runtime/nilaspeak.db"
    database_expected_host: str = ""
    backend_cors_origins: str = "http://localhost:3000,http://localhost:8080"
    log_level: str = "INFO"
    allow_registration: bool = True
    jwt_secret: str = ""
    credential_encryption_key: str = ""
    credential_encryption_previous_key: str = ""
    provider_allowed_base_urls: str = "https://api.openai.com/v1"
    provider_allow_local_urls: bool = False
    provider_settings_rate_limit_per_hour: int = 10
    trust_proxy_headers: bool = False
    trusted_proxy_networks: str = ""
    public_base_url: str = ""
    access_token_minutes: int = 15
    refresh_token_days: int = 30
    ai_provider: str = "none"
    ai_model: str = "mock-tutor-v1"
    ai_api_key: str = ""
    ai_base_url: str = ""
    ai_request_timeout_seconds: int = 20
    ai_max_output_tokens: int = 400
    ai_daily_request_limit: int = 50
    ai_daily_token_limit: int = 12000
    ai_max_message_characters: int = 2000
    ai_conversation_context_limit: int = 12
    ai_provider_enabled: bool = False
    stt_provider: str = "none"
    stt_model: str = "mock-stt-v1"
    stt_api_key: str = ""
    stt_base_url: str = ""
    stt_request_timeout_seconds: int = 20
    stt_max_audio_seconds: int = 60
    stt_max_upload_bytes: int = 5_000_000
    stt_enabled: bool = False
    tts_provider: str = "none"
    tts_model: str = "mock-tts-v1"
    tts_voice: str = "default"
    tts_api_key: str = ""
    tts_base_url: str = ""
    tts_request_timeout_seconds: int = 20
    tts_max_text_characters: int = 500
    tts_enabled: bool = False
    voice_daily_transcription_seconds: int = 600
    voice_daily_synthesis_characters: int = 10_000
    voice_max_turns_per_session: int = 20
    voice_temp_audio_retention_minutes: int = 30
    voice_audio_storage_path: str = "./runtime/audio"

    @field_validator("database_url", mode="before")
    @classmethod
    def development_database_fallback(cls, value: object, info: ValidationInfo) -> object:
        if value in (None, "") and info.data.get("app_env", "development") != "production":
            return "sqlite+aiosqlite:///./runtime/nilaspeak.db"
        return value

    model_config = SettingsConfigDict(env_file=".env", extra="ignore", case_sensitive=False)

    @property
    def cors_origins(self) -> list[str]:
        return [origin.strip() for origin in self.backend_cors_origins.split(",") if origin.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
