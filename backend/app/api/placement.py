from datetime import UTC, datetime

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.db.session import get_db
from app.dependencies import current_user
from app.models import PlacementAnswer, PlacementAttempt, PlacementQuestion, PlacementResult, User
from app.schemas import (
    PlacementAnswerRequest,
    PlacementAssessmentResponse,
    PlacementAttemptResponse,
    PlacementQuestionResponse,
    PlacementResultResponse,
)
from app.services import create_learning_plan, get_or_seed_assessment, score_attempt

router = APIRouter(prefix="/placement", tags=["placement"])


@router.get("/assessment", response_model=PlacementAssessmentResponse)
async def assessment(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> PlacementAssessmentResponse:
    value = await get_or_seed_assessment(db)
    await db.commit()
    return PlacementAssessmentResponse(
        id=value.id,
        version=value.version,
        title=value.title,
        questions=[
            PlacementQuestionResponse(
                id=q.id,
                question_type=q.question_type,
                prompt=q.prompt,
                options=q.options,
                difficulty=q.difficulty,
                skill_category=q.skill_category,
                cefr_hint=q.cefr_hint,
            )
            for q in value.questions
        ],
    )


@router.post("/attempts", response_model=PlacementAttemptResponse, status_code=201)
async def start_attempt(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> PlacementAttemptResponse:
    value = await get_or_seed_assessment(db)
    attempt = PlacementAttempt(user_id=user.id, assessment_id=value.id)
    db.add(attempt)
    await db.commit()
    return PlacementAttemptResponse(id=attempt.id, status=attempt.status, answers={})


async def owned_attempt(attempt_id: str, user_id: str, db: AsyncSession) -> PlacementAttempt:
    attempt = await db.scalar(
        select(PlacementAttempt)
        .options(selectinload(PlacementAttempt.answers), selectinload(PlacementAttempt.result))
        .where(PlacementAttempt.id == attempt_id, PlacementAttempt.user_id == user_id)
    )
    if attempt is None:
        raise HTTPException(status_code=404, detail="Placement attempt not found.")
    return attempt


@router.get("/attempts/{attempt_id}", response_model=PlacementAttemptResponse)
async def get_attempt(
    attempt_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> PlacementAttemptResponse:
    attempt = await owned_attempt(attempt_id, user.id, db)
    return PlacementAttemptResponse(
        id=attempt.id,
        status=attempt.status,
        answers={answer.question_id: answer.answer for answer in attempt.answers},
    )


@router.put("/attempts/{attempt_id}/answers/{question_id}", response_model=PlacementAttemptResponse)
async def save_answer(
    attempt_id: str,
    question_id: str,
    payload: PlacementAnswerRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> PlacementAttemptResponse:
    attempt = await owned_attempt(attempt_id, user.id, db)
    if attempt.status != "in_progress":
        raise HTTPException(status_code=409, detail="Submitted attempts cannot be changed.")
    question = await db.get(PlacementQuestion, question_id)
    if question is None or question.assessment_id != attempt.assessment_id:
        raise HTTPException(status_code=404, detail="Placement question not found.")
    existing = next(
        (answer for answer in attempt.answers if answer.question_id == question_id), None
    )
    if existing is None:
        attempt.answers.append(PlacementAnswer(question_id=question_id, answer=payload.answer))
    else:
        existing.answer = payload.answer
    await db.commit()
    return await get_attempt(attempt_id, user, db)


@router.post("/attempts/{attempt_id}/submit", response_model=PlacementResultResponse)
async def submit_attempt(
    attempt_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> PlacementResultResponse:
    attempt = await owned_attempt(attempt_id, user.id, db)
    if attempt.result is not None:
        return PlacementResultResponse.model_validate(attempt.result)
    assessment_value = await get_or_seed_assessment(db)
    if len(attempt.answers) < len(assessment_value.questions):
        raise HTTPException(
            status_code=422, detail="Answer every placement question before submitting."
        )
    scored = score_attempt(attempt, assessment_value.questions)
    result = PlacementResult(attempt_id=attempt.id, **scored)
    attempt.status = "submitted"
    attempt.submitted_at = datetime.now(UTC)
    db.add(result)
    await db.flush()
    await create_learning_plan(db, user.id, result)
    await db.commit()
    return PlacementResultResponse.model_validate(result)


@router.get("/results/latest", response_model=PlacementResultResponse)
async def latest_result(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> PlacementResultResponse:
    result = await db.scalar(
        select(PlacementResult)
        .join(PlacementAttempt)
        .where(PlacementAttempt.user_id == user.id)
        .order_by(PlacementResult.created_at.desc())
    )
    if result is None:
        raise HTTPException(status_code=404, detail="No placement result found.")
    return PlacementResultResponse.model_validate(result)
