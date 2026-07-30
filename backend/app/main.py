from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.health import router as root_health_router
from app.api.router import api_router
from app.core.config import get_settings
from app.core.logging import configure_logging

settings = get_settings()
configure_logging(settings.log_level)

app = FastAPI(title="NilaSpeak API", version=settings.app_version)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Accept", "Content-Type"],
)
app.include_router(root_health_router)
app.include_router(api_router)
