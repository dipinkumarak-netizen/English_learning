from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import delete, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.db.session import get_db
from app.dependencies import current_user
from app.models import (
    DifficultAreaSelection,
    LearnerProfile,
    LearningGoalSelection,
    OnboardingProgress,
    User,
)
from app.schemas import (
    CompleteOnboardingRequest,
    OnboardingProgressRequest,
    OnboardingProgressResponse,
    ProfileResponse,
    ProfileUpdate,
)

router = APIRouter(tags=["profile"])


async def load_profile(user_id: str, db: AsyncSession) -> LearnerProfile:
    profile = await db.scalar(
        select(LearnerProfile)
        .options(selectinload(LearnerProfile.goals), selectinload(LearnerProfile.difficult_areas))
        .where(LearnerProfile.user_id == user_id)
    )
    if profile is None:
        profile = LearnerProfile(user_id=user_id)
        db.add(profile)
        await db.flush()
        await db.refresh(profile, ["goals", "difficult_areas"])
    return profile


def profile_response(profile: LearnerProfile) -> ProfileResponse:
    return ProfileResponse(
        application_language=profile.application_language,
        native_language=profile.native_language,
        explanation_language=profile.explanation_language,
        confidence_level=profile.confidence_level,
        daily_study_minutes=profile.daily_study_minutes,
        onboarding_complete=profile.onboarding_complete,
        learning_goals=[item.goal for item in profile.goals],
        difficult_areas=[item.area for item in profile.difficult_areas],
        updated_at=profile.updated_at,
    )


@router.get("/profile", response_model=ProfileResponse)
async def get_profile(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> ProfileResponse:
    return profile_response(await load_profile(user.id, db))


@router.put("/profile", response_model=ProfileResponse)
async def update_profile(
    payload: ProfileUpdate, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> ProfileResponse:
    profile = await load_profile(user.id, db)
    values = payload.model_dump(exclude_unset=True)
    display_name = values.pop("display_name", None)
    if display_name is not None:
        user.display_name = display_name
    for field in (
        "application_language",
        "native_language",
        "explanation_language",
        "confidence_level",
        "daily_study_minutes",
    ):
        if field in values:
            setattr(profile, field, values[field])
    if "learning_goals" in values:
        await db.execute(
            delete(LearningGoalSelection).where(LearningGoalSelection.profile_id == profile.id)
        )
        profile.goals = [
            LearningGoalSelection(goal=value, profile_id=profile.id)
            for value in values["learning_goals"]
        ]
    if "difficult_areas" in values:
        await db.execute(
            delete(DifficultAreaSelection).where(DifficultAreaSelection.profile_id == profile.id)
        )
        profile.difficult_areas = [
            DifficultAreaSelection(area=value, profile_id=profile.id)
            for value in values["difficult_areas"]
        ]
    await db.commit()
    return profile_response(await load_profile(user.id, db))


@router.get("/onboarding/progress", response_model=OnboardingProgressResponse)
async def get_onboarding_progress(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> OnboardingProgressResponse:
    progress = await db.scalar(
        select(OnboardingProgress).where(OnboardingProgress.user_id == user.id)
    )
    if progress is None:
        progress = OnboardingProgress(user_id=user.id)
        db.add(progress)
        await db.commit()
        await db.refresh(progress)
    return OnboardingProgressResponse(
        current_step=progress.current_step,
        completed_steps=progress.completed_steps or [],
        draft=progress.draft or {},
        updated_at=progress.updated_at,
    )


@router.put("/onboarding/progress", response_model=OnboardingProgressResponse)
async def save_onboarding_progress(
    payload: OnboardingProgressRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> OnboardingProgressResponse:
    progress = await db.scalar(
        select(OnboardingProgress).where(OnboardingProgress.user_id == user.id)
    )
    if progress is None:
        progress = OnboardingProgress(user_id=user.id)
        db.add(progress)
    progress.current_step = payload.current_step
    progress.completed_steps = payload.completed_steps
    progress.draft = payload.draft
    await db.commit()
    await db.refresh(progress)
    return OnboardingProgressResponse(
        current_step=progress.current_step,
        completed_steps=progress.completed_steps,
        draft=progress.draft,
        updated_at=progress.updated_at,
    )


@router.post("/onboarding/complete", response_model=ProfileResponse)
async def complete_onboarding(
    payload: CompleteOnboardingRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProfileResponse:
    await update_profile(payload.profile, user, db)
    profile = await load_profile(user.id, db)
    if not profile.confidence_level or not profile.daily_study_minutes or not profile.goals:
        raise HTTPException(
            status_code=422, detail="Complete the required onboarding fields first."
        )
    profile.onboarding_complete = True
    await db.commit()
    return profile_response(await load_profile(user.id, db))
