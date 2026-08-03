from pathlib import Path

from alembic.config import Config
from alembic.script import ScriptDirectory
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.validation import validate_settings
from app.db.session import get_db

router = APIRouter(tags=["health"])


class HealthResponse(BaseModel):
    status: str
    service: str
    version: str
    environment: str


class ReadinessResponse(BaseModel):
    status: str
    checks: dict[str, str]


@router.get("/health", response_model=HealthResponse)
async def health() -> HealthResponse:
    settings = get_settings()
    return HealthResponse(
        status="ok",
        service="nilaspeak-backend",
        version=settings.app_version,
        environment=settings.app_env,
    )


@router.get("/ready", response_model=ReadinessResponse)
async def readiness(db: AsyncSession = Depends(get_db)) -> ReadinessResponse:
    settings = get_settings()
    configuration_errors = validate_settings(settings) if settings.app_env == "production" else []
    if configuration_errors:
        raise HTTPException(
            status_code=503,
            detail={"status": "not_ready", "checks": {"configuration": "configuration_invalid"}},
        )
    try:
        await db.execute(text("SELECT 1"))
    except Exception as error:
        del error
        raise HTTPException(
            status_code=503,
            detail={"status": "not_ready", "checks": {"database": "database_unavailable"}},
        ) from None
    if settings.app_env == "production":
        try:
            version = (await db.execute(text("SELECT version_num FROM alembic_version"))).scalar()
            alembic_config = Config(str(Path(__file__).parents[2] / "alembic.ini"))
            head = ScriptDirectory.from_config(alembic_config).get_current_head()
            if version != head:
                raise RuntimeError("migration mismatch")
        except Exception as error:
            del error
            raise HTTPException(
                status_code=503,
                detail={"status": "not_ready", "checks": {"migration": "migration_required"}},
            ) from None
    return ReadinessResponse(
        status="ready",
        checks={
            "application": "ok",
            "database": "ok",
            "configuration": "ok",
            **({"migration": "ok"} if settings.app_env == "production" else {}),
        },
    )
