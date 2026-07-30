from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.session import get_db
from app.dependencies import current_user
from app.models import LearningPlan, PlacementAttempt, PlacementResult, User
from app.schemas import LearningPlanResponse
from app.services import create_learning_plan

router = APIRouter(prefix="/learning-plan", tags=["learning-plan"])


@router.get("", response_model=LearningPlanResponse)
async def current_plan(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> LearningPlanResponse:
    plan = await db.scalar(
        select(LearningPlan)
        .where(LearningPlan.user_id == user.id, LearningPlan.active.is_(True))
        .order_by(LearningPlan.created_at.desc())
    )
    if plan is None:
        raise HTTPException(status_code=404, detail="No learning plan found.")
    return LearningPlanResponse.model_validate(plan)


@router.post("/recalculate", response_model=LearningPlanResponse)
async def recalculate_plan(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> LearningPlanResponse:
    result = await db.scalar(
        select(PlacementResult)
        .join(PlacementAttempt)
        .where(PlacementAttempt.user_id == user.id)
        .order_by(PlacementResult.created_at.desc())
    )
    plan = await create_learning_plan(db, user.id, result)
    await db.commit()
    return LearningPlanResponse.model_validate(plan)
