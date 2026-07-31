from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_env: str = "development"
    app_version: str = "0.1.0"
    database_url: str = "postgresql+asyncpg://nilaspeak:change-me-local@localhost:5432/nilaspeak"
    backend_cors_origins: str = "http://localhost:3000,http://localhost:8080"
    log_level: str = "INFO"
    allow_registration: bool = True
    jwt_secret: str = "local-development-secret-change-before-remote-use"
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

    model_config = SettingsConfigDict(env_file=".env", extra="ignore", case_sensitive=False)

    @property
    def cors_origins(self) -> list[str]:
        return [origin.strip() for origin in self.backend_cors_origins.split(",") if origin.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
