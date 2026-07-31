from datetime import UTC, datetime
from typing import Any

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.course_engine import score_answer
from app.db.session import get_db
from app.dependencies import current_user
from app.models import (
    Course,
    CourseEnrollment,
    CourseModule,
    ExerciseAttempt,
    ExerciseDefinition,
    Lesson,
    LessonProgress,
    LessonStep,
    LessonStepProgress,
    OfflineSyncOperation,
    User,
)
from app.schemas import (
    CourseResponse,
    ExerciseAttemptRequest,
    ExerciseAttemptResponse,
    ExerciseDefinitionResponse,
    LessonCompletionResponse,
    LessonDetailResponse,
    LessonStepResponse,
    LessonSummaryResponse,
    ModuleResponse,
    ProgressSummaryResponse,
    ProgressSyncRequest,
    ProgressSyncResponse,
    StepProgressRequest,
)

router = APIRouter(tags=["courses"])


async def _published_course(course_id: str, db: AsyncSession) -> Course:
    course = await db.scalar(
        select(Course).where(Course.id == course_id, Course.is_published.is_(True))
    )
    if course is None:
        raise HTTPException(status_code=404, detail="Course not found.")
    return course


async def _published_lesson(lesson_id: str, db: AsyncSession) -> Lesson:
    lesson = await db.scalar(
        select(Lesson).where(Lesson.id == lesson_id, Lesson.is_published.is_(True))
    )
    if lesson is None:
        raise HTTPException(status_code=404, detail="Lesson not found.")
    module = await db.scalar(
        select(CourseModule).where(
            CourseModule.id == lesson.module_id, CourseModule.is_published.is_(True)
        )
    )
    if (
        module is None
        or await db.scalar(
            select(Course).where(Course.id == module.course_id, Course.is_published.is_(True))
        )
        is None
    ):
        raise HTTPException(status_code=404, detail="Lesson not found.")
    return lesson


async def _lesson_context(lesson: Lesson, db: AsyncSession) -> tuple[CourseModule, Course]:
    module = await db.get(CourseModule, lesson.module_id)
    if module is None:
        raise HTTPException(status_code=404, detail="Lesson module not found.")
    course = await db.get(Course, module.course_id)
    if course is None:
        raise HTTPException(status_code=404, detail="Course not found.")
    return module, course


async def _flatten_lessons(course_id: str, db: AsyncSession) -> list[Lesson]:
    modules = (
        await db.scalars(
            select(CourseModule)
            .where(CourseModule.course_id == course_id, CourseModule.is_published.is_(True))
            .order_by(CourseModule.sort_order)
        )
    ).all()
    lessons: list[Lesson] = []
    for module in modules:
        lessons.extend(
            (
                await db.scalars(
                    select(Lesson)
                    .where(Lesson.module_id == module.id, Lesson.is_published.is_(True))
                    .order_by(Lesson.day_number)
                )
            ).all()
        )
    return lessons


async def _is_unlocked(user_id: str, lesson: Lesson, db: AsyncSession) -> bool:
    module, course = await _lesson_context(lesson, db)
    lessons = await _flatten_lessons(course.id, db)
    try:
        index = next(index for index, item in enumerate(lessons) if item.id == lesson.id)
    except StopIteration:
        return False
    if index == 0:
        return True
    previous = lessons[index - 1]
    completed = await db.scalar(
        select(LessonProgress).where(
            LessonProgress.user_id == user_id,
            LessonProgress.lesson_id == previous.id,
            LessonProgress.completed_at.is_not(None),
        )
    )
    return completed is not None


async def _step_response(step: LessonStep, db: AsyncSession) -> LessonStepResponse:
    exercise = await db.scalar(
        select(ExerciseDefinition).where(ExerciseDefinition.step_id == step.id)
    )
    exercise_response = (
        ExerciseDefinitionResponse.model_validate(exercise, from_attributes=True)
        if exercise is not None
        else None
    )
    return LessonStepResponse(
        id=step.id,
        step_type=step.step_type,
        sort_order=step.sort_order,
        title=step.title,
        content_en=step.content_en,
        explanation_ml=step.explanation_ml,
        version=step.version,
        is_required=step.is_required,
        completion_rule=step.completion_rule,
        exercise=exercise_response,
    )


async def _lesson_summary(user_id: str, lesson: Lesson, db: AsyncSession) -> LessonSummaryResponse:
    progress = await db.scalar(
        select(LessonProgress).where(
            LessonProgress.user_id == user_id, LessonProgress.lesson_id == lesson.id
        )
    )
    return LessonSummaryResponse(
        id=lesson.id,
        slug=lesson.slug,
        title=lesson.title,
        summary=lesson.summary,
        learning_objectives=lesson.learning_objectives,
        grammar_focus=lesson.grammar_focus,
        vocabulary_focus=lesson.vocabulary_focus,
        estimated_minutes=lesson.estimated_minutes,
        difficulty=lesson.difficulty,
        sort_order=lesson.sort_order,
        day_number=lesson.day_number,
        version=lesson.version,
        is_published=lesson.is_published,
        offline_eligible=lesson.offline_eligible,
        unlocked=await _is_unlocked(user_id, lesson, db),
        completed=progress is not None and progress.completed_at is not None,
        score=float(progress.score) if progress is not None else 0,
    )


async def _course_response(user_id: str, course: Course, db: AsyncSession) -> CourseResponse:
    modules = (
        await db.scalars(
            select(CourseModule)
            .where(CourseModule.course_id == course.id, CourseModule.is_published.is_(True))
            .order_by(CourseModule.sort_order)
        )
    ).all()
    module_responses: list[ModuleResponse] = []
    lessons = await _flatten_lessons(course.id, db)
    completed_count = 0
    for module in modules:
        module_lessons = [lesson for lesson in lessons if lesson.module_id == module.id]
        lesson_responses = [await _lesson_summary(user_id, lesson, db) for lesson in module_lessons]
        completed_count += sum(lesson.completed for lesson in lesson_responses)
        module_responses.append(
            ModuleResponse(
                id=module.id,
                title=module.title,
                description=module.description,
                sort_order=module.sort_order,
                estimated_minutes=module.estimated_minutes,
                unlock_rule=module.unlock_rule,
                version=module.version,
                is_published=module.is_published,
                lessons=lesson_responses,
                unlocked=any(lesson.unlocked for lesson in lesson_responses),
            )
        )
    percentage = (completed_count / len(lessons) * 100) if lessons else 0
    return CourseResponse(
        id=course.id,
        slug=course.slug,
        title=course.title,
        short_description=course.short_description,
        full_description=course.full_description,
        learner_level=course.learner_level,
        native_language_support=course.native_language_support,
        explanation_languages=course.explanation_languages,
        estimated_total_minutes=course.estimated_total_minutes,
        version=course.version,
        is_published=course.is_published,
        thumbnail_ref=course.thumbnail_ref,
        completion_percentage=percentage,
        modules=module_responses,
    )


@router.get("/courses")
async def list_courses(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> dict[str, list[CourseResponse]]:
    courses = (
        await db.scalars(
            select(Course).where(Course.is_published.is_(True)).order_by(Course.sort_order)
        )
    ).all()
    return {"courses": [await _course_response(user.id, course, db) for course in courses]}


@router.get("/courses/{course_id}", response_model=CourseResponse)
async def course_details(
    course_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> CourseResponse:
    return await _course_response(user.id, await _published_course(course_id, db), db)


@router.get("/courses/{course_id}/modules", response_model=list[ModuleResponse])
async def course_modules(
    course_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> list[ModuleResponse]:
    course = await _published_course(course_id, db)
    response = await _course_response(user.id, course, db)
    return response.modules


@router.get("/lessons/{lesson_id}", response_model=LessonDetailResponse)
async def lesson_details(
    lesson_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> LessonDetailResponse:
    lesson = await _published_lesson(lesson_id, db)
    module, _ = await _lesson_context(lesson, db)
    summary = await _lesson_summary(user.id, lesson, db)
    steps = (
        await db.scalars(
            select(LessonStep)
            .where(LessonStep.lesson_id == lesson.id)
            .order_by(LessonStep.sort_order)
        )
    ).all()
    return LessonDetailResponse(
        **summary.model_dump(),
        module_id=module.id,
        steps=[await _step_response(step, db) for step in steps],
    )


@router.get("/lessons/{lesson_id}/steps", response_model=list[LessonStepResponse])
async def lesson_steps(
    lesson_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> list[LessonStepResponse]:
    lesson = await _published_lesson(lesson_id, db)
    return [
        await _step_response(step, db)
        for step in (
            await db.scalars(
                select(LessonStep)
                .where(LessonStep.lesson_id == lesson.id)
                .order_by(LessonStep.sort_order)
            )
        ).all()
    ]


async def _ensure_progress(user_id: str, lesson: Lesson, db: AsyncSession) -> LessonProgress:
    progress = await db.scalar(
        select(LessonProgress).where(
            LessonProgress.user_id == user_id, LessonProgress.lesson_id == lesson.id
        )
    )
    now = datetime.now(UTC)
    if progress is None:
        progress = LessonProgress(
            user_id=user_id,
            lesson_id=lesson.id,
            started_at=now,
            score=0,
            total_attempts=0,
            sync_state="synced",
        )
        db.add(progress)
    progress.last_activity_at = now
    return progress


@router.get("/courses/{course_id}/progress")
async def course_progress(
    course_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> CourseResponse:
    return await _course_response(user.id, await _published_course(course_id, db), db)


@router.get("/lessons/{lesson_id}/progress")
async def lesson_progress(
    lesson_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> dict[str, Any]:
    lesson = await _published_lesson(lesson_id, db)
    progress = await db.scalar(
        select(LessonProgress).where(
            LessonProgress.user_id == user.id, LessonProgress.lesson_id == lesson.id
        )
    )
    steps = (
        await db.scalars(
            select(LessonStepProgress)
            .join(LessonStep, LessonStep.id == LessonStepProgress.step_id)
            .where(LessonStepProgress.user_id == user.id, LessonStep.lesson_id == lesson.id)
        )
    ).all()
    return {
        "lesson_id": lesson.id,
        "current_step_id": progress.current_step_id if progress else None,
        "completed_steps": [item.step_id for item in steps if item.completed_at is not None],
        "score": float(progress.score) if progress else 0,
        "completed": progress is not None and progress.completed_at is not None,
        "sync_state": progress.sync_state if progress else "synced",
    }


@router.post("/lessons/{lesson_id}/start")
async def start_lesson(
    lesson_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> dict[str, Any]:
    lesson = await _published_lesson(lesson_id, db)
    if not await _is_unlocked(user.id, lesson, db):
        raise HTTPException(status_code=423, detail="Complete the previous lesson first.")
    progress = await _ensure_progress(user.id, lesson, db)
    module, course = await _lesson_context(lesson, db)
    enrollment = await db.scalar(
        select(CourseEnrollment).where(
            CourseEnrollment.user_id == user.id, CourseEnrollment.course_id == course.id
        )
    )
    if enrollment is None:
        enrollment = CourseEnrollment(user_id=user.id, course_id=course.id)
        db.add(enrollment)
    enrollment.current_lesson_id = lesson.id
    enrollment.last_activity_at = datetime.now(UTC)
    await db.commit()
    return {
        "lesson_id": lesson.id,
        "module_id": module.id,
        "current_step_id": progress.current_step_id,
    }


@router.put("/lessons/{lesson_id}/steps/{step_id}/progress")
async def complete_step(
    lesson_id: str,
    step_id: str,
    payload: StepProgressRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, Any]:
    lesson = await _published_lesson(lesson_id, db)
    if not await _is_unlocked(user.id, lesson, db):
        raise HTTPException(status_code=423, detail="Lesson is locked.")
    step = await db.scalar(
        select(LessonStep).where(LessonStep.id == step_id, LessonStep.lesson_id == lesson.id)
    )
    if step is None:
        raise HTTPException(status_code=400, detail="Step does not belong to this lesson.")
    if step.completion_rule == "exercise":
        exercise = await db.scalar(
            select(ExerciseDefinition).where(ExerciseDefinition.step_id == step.id)
        )
        if exercise is None:
            raise HTTPException(status_code=400, detail="Exercise definition is missing.")
        valid = await db.scalar(
            select(ExerciseAttempt).where(
                ExerciseAttempt.user_id == user.id,
                ExerciseAttempt.exercise_id == exercise.id,
                ExerciseAttempt.is_correct.is_(True),
            )
        )
        if valid is None:
            raise HTTPException(status_code=400, detail="Submit a correct exercise attempt first.")
    progress = await _ensure_progress(user.id, lesson, db)
    step_progress = await db.scalar(
        select(LessonStepProgress).where(
            LessonStepProgress.user_id == user.id, LessonStepProgress.step_id == step.id
        )
    )
    if step_progress is None:
        step_progress = LessonStepProgress(user_id=user.id, step_id=step.id)
        db.add(step_progress)
    if payload.completed:
        step_progress.completed_at = datetime.now(UTC)
    progress.current_step_id = step.id
    await db.commit()
    return {"step_id": step.id, "completed": step_progress.completed_at is not None}


@router.post("/exercises/{exercise_id}/attempts", response_model=ExerciseAttemptResponse)
async def submit_exercise(
    exercise_id: str,
    payload: ExerciseAttemptRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ExerciseAttemptResponse:
    exercise = await db.scalar(
        select(ExerciseDefinition).where(ExerciseDefinition.id == exercise_id)
    )
    if exercise is None:
        raise HTTPException(status_code=404, detail="Exercise not found.")
    step = await db.get(LessonStep, exercise.step_id)
    if step is None:
        raise HTTPException(status_code=404, detail="Exercise step not found.")
    lesson = await _published_lesson(step.lesson_id, db)
    if not await _is_unlocked(user.id, lesson, db):
        raise HTTPException(status_code=423, detail="Lesson is locked.")
    existing = await db.scalar(
        select(ExerciseAttempt).where(
            ExerciseAttempt.client_operation_id == payload.client_operation_id
        )
    )
    if existing is not None:
        return await _attempt_response(existing, exercise, db)
    attempts = (
        await db.scalars(
            select(ExerciseAttempt).where(
                ExerciseAttempt.user_id == user.id, ExerciseAttempt.exercise_id == exercise.id
            )
        )
    ).all()
    if len(attempts) >= exercise.max_attempts and not any(
        attempt.is_correct for attempt in attempts
    ):
        raise HTTPException(status_code=409, detail="Maximum attempts reached.")
    is_correct = score_answer(exercise.exercise_type, payload.answer, exercise.correct_answer)
    attempt = ExerciseAttempt(
        user_id=user.id,
        exercise_id=exercise.id,
        content_version=exercise.content_version,
        answer_snapshot=payload.answer,
        is_correct=is_correct,
        score=exercise.scoring_weight if is_correct else 0,
        attempt_number=len(attempts) + 1,
        client_operation_id=payload.client_operation_id,
    )
    db.add(attempt)
    progress = await _ensure_progress(user.id, lesson, db)
    progress.total_attempts += 1
    if is_correct:
        step_progress = await db.scalar(
            select(LessonStepProgress).where(
                LessonStepProgress.user_id == user.id, LessonStepProgress.step_id == step.id
            )
        )
        if step_progress is None:
            db.add(
                LessonStepProgress(user_id=user.id, step_id=step.id, completed_at=datetime.now(UTC))
            )
        else:
            step_progress.completed_at = datetime.now(UTC)
    await db.commit()
    return await _attempt_response(attempt, exercise, db)


async def _attempt_response(
    attempt: ExerciseAttempt, exercise: ExerciseDefinition, db: AsyncSession
) -> ExerciseAttemptResponse:
    attempts = await db.scalar(
        select(func.count(ExerciseAttempt.id)).where(
            ExerciseAttempt.user_id == attempt.user_id, ExerciseAttempt.exercise_id == exercise.id
        )
    )
    return ExerciseAttemptResponse(
        attempt_id=attempt.id,
        is_correct=attempt.is_correct,
        score=float(attempt.score),
        attempt_number=attempt.attempt_number,
        attempts_remaining=max(exercise.max_attempts - int(attempts or 0), 0),
        explanation_en=exercise.explanation_en,
        explanation_ml=exercise.explanation_ml,
        completed=attempt.is_correct,
    )


@router.post("/lessons/{lesson_id}/complete", response_model=LessonCompletionResponse)
async def complete_lesson(
    lesson_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> LessonCompletionResponse:
    lesson = await _published_lesson(lesson_id, db)
    if not await _is_unlocked(user.id, lesson, db):
        raise HTTPException(status_code=423, detail="Lesson is locked.")
    steps = (
        await db.scalars(
            select(LessonStep)
            .where(LessonStep.lesson_id == lesson.id)
            .order_by(LessonStep.sort_order)
        )
    ).all()
    required_ids = {step.id for step in steps if step.is_required}
    completed_ids = {
        item.step_id
        for item in (
            await db.scalars(
                select(LessonStepProgress).where(
                    LessonStepProgress.user_id == user.id,
                    LessonStepProgress.step_id.in_(required_ids),
                    LessonStepProgress.completed_at.is_not(None),
                )
            )
        ).all()
    }
    if required_ids - completed_ids:
        raise HTTPException(status_code=400, detail="Complete all required lesson steps first.")
    progress = await _ensure_progress(user.id, lesson, db)
    if progress.completed_at is None:
        progress.completed_at = datetime.now(UTC)
    exercises = (
        await db.scalars(
            select(ExerciseDefinition).join(LessonStep).where(LessonStep.lesson_id == lesson.id)
        )
    ).all()
    attempts = (
        await db.scalars(
            select(ExerciseAttempt).where(
                ExerciseAttempt.user_id == user.id,
                ExerciseAttempt.exercise_id.in_([exercise.id for exercise in exercises]),
            )
        )
    ).all()
    correct = sum(attempt.is_correct for attempt in attempts)
    if exercises and correct < len(exercises):
        raise HTTPException(status_code=400, detail="Complete required exercises correctly first.")
    progress.score = (correct / len(exercises) * 100) if exercises else 100
    await db.commit()
    lessons = await _flatten_lessons((await _lesson_context(lesson, db))[1].id, db)
    current_index = next(index for index, item in enumerate(lessons) if item.id == lesson.id)
    next_lesson_id = lessons[current_index + 1].id if current_index + 1 < len(lessons) else None
    return LessonCompletionResponse(
        lesson_id=lesson.id,
        completed=True,
        score=float(progress.score),
        completed_exercises=correct,
        correct_answers=correct,
        incorrect_answers=max(len(attempts) - correct, 0),
        attempt_count=len(attempts),
        next_lesson_id=next_lesson_id,
        vocabulary_reviewed=lesson.vocabulary_focus,
        grammar_focus=lesson.grammar_focus,
        completed_at=progress.completed_at,
    )


@router.get("/progress/summary", response_model=ProgressSummaryResponse)
async def progress_summary(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> ProgressSummaryResponse:
    total = int(
        await db.scalar(select(func.count(Lesson.id)).where(Lesson.is_published.is_(True))) or 0
    )
    completed = int(
        await db.scalar(
            select(func.count(LessonProgress.id)).where(
                LessonProgress.user_id == user.id, LessonProgress.completed_at.is_not(None)
            )
        )
        or 0
    )
    started = int(
        await db.scalar(
            select(func.count(CourseEnrollment.id)).where(CourseEnrollment.user_id == user.id)
        )
        or 0
    )
    current = await db.scalar(
        select(CourseEnrollment.current_lesson_id)
        .where(CourseEnrollment.user_id == user.id, CourseEnrollment.current_lesson_id.is_not(None))
        .order_by(CourseEnrollment.last_activity_at.desc())
    )
    return ProgressSummaryResponse(
        courses_started=started,
        lessons_completed=completed,
        lessons_available=total,
        completion_percentage=(completed / total * 100) if total else 0,
        current_lesson_id=current,
    )


@router.post("/progress/sync", response_model=ProgressSyncResponse)
async def sync_progress(
    payload: ProgressSyncRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> ProgressSyncResponse:
    processed: list[str] = []
    failed: list[dict[str, str]] = []
    for operation in payload.operations:
        existing = await db.scalar(
            select(OfflineSyncOperation).where(
                OfflineSyncOperation.user_id == user.id,
                OfflineSyncOperation.client_operation_id == operation.client_operation_id,
            )
        )
        if existing is not None and existing.sync_status == "synced":
            processed.append(operation.client_operation_id)
            continue
        if existing is None:
            existing = OfflineSyncOperation(
                user_id=user.id,
                client_operation_id=operation.client_operation_id,
                operation_type=operation.operation_type,
                entity_id=operation.entity_id,
                payload=operation.payload,
            )
            db.add(existing)
        try:
            if operation.operation_type == "start_lesson":
                lesson = await _published_lesson(operation.entity_id, db)
                if not await _is_unlocked(user.id, lesson, db):
                    raise HTTPException(status_code=423, detail="Lesson is locked.")
                await _ensure_progress(user.id, lesson, db)
            elif operation.operation_type == "complete_step":
                step_payload = StepProgressRequest.model_validate(operation.payload)
                lesson_id = str(operation.payload.get("lesson_id", ""))
                await complete_step(lesson_id, operation.entity_id, step_payload, user, db)
            elif operation.operation_type == "submit_exercise":
                attempt_payload = ExerciseAttemptRequest.model_validate(operation.payload)
                await submit_exercise(operation.entity_id, attempt_payload, user, db)
            elif operation.operation_type == "complete_lesson":
                await complete_lesson(operation.entity_id, user, db)
            existing.sync_status = "synced"
            existing.last_error = None
            existing.retry_count += 1
            processed.append(operation.client_operation_id)
        except (HTTPException, ValueError) as error:
            existing.sync_status = "failed"
            existing.last_error = str(error.detail if isinstance(error, HTTPException) else error)
            existing.retry_count += 1
            failed.append(
                {"client_operation_id": operation.client_operation_id, "error": existing.last_error}
            )
    await db.commit()
    return ProgressSyncResponse(processed=processed, failed=failed)
