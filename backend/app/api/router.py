from fastapi import APIRouter

from app.api.auth import router as auth_router
from app.api.courses import router as courses_router
from app.api.health import router as health_router
from app.api.learning_plan import router as learning_plan_router
from app.api.placement import router as placement_router
from app.api.profile import router as profile_router
from app.api.sync import router as sync_router
from app.api.tutor import router as tutor_router

api_router = APIRouter(prefix="/api/v1")
api_router.include_router(health_router)
api_router.include_router(auth_router)
api_router.include_router(profile_router)
api_router.include_router(placement_router)
api_router.include_router(learning_plan_router)
api_router.include_router(courses_router)
api_router.include_router(tutor_router)
api_router.include_router(sync_router)
