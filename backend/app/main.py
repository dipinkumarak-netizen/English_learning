from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.core.validation import validate_settings

settings = get_settings()
if settings.app_env.lower() == "production":
    configuration_errors = validate_settings(settings)
    if configuration_errors:
        raise RuntimeError("Production configuration invalid: " + ", ".join(configuration_errors))
from app.api.health import router as root_health_router  # noqa: E402
from app.api.router import api_router  # noqa: E402
from app.core.logging import configure_logging  # noqa: E402

configure_logging(settings.log_level)

app = FastAPI(title="NilaSpeak API", version=settings.app_version)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Accept", "Content-Type", "Authorization", "X-Request-ID"],
)
app.include_router(root_health_router)
app.include_router(api_router)
