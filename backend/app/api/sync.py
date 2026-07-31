from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.courses import sync_progress
from app.api.profile import load_profile, profile_response
from app.db.session import get_db
from app.dependencies import current_user
from app.models import ExerciseDefinition, Lesson, LessonStep, OfflineSyncOperation, User
from app.schemas import (
    LocalImportRequest,
    LocalImportResponse,
    ProgressSyncRequest,
    SyncOperationRequest,
)

router = APIRouter(prefix="/sync", tags=["sync"])


@router.post("/local-import", response_model=LocalImportResponse)
async def import_local_state(
    payload: LocalImportRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> LocalImportResponse:
    existing = await db.scalar(
        select(OfflineSyncOperation).where(
            OfflineSyncOperation.user_id == user.id,
            OfflineSyncOperation.client_operation_id == payload.client_import_operation_id,
        )
    )
    if existing is not None and existing.sync_status == "synced":
        profile = await load_profile(user.id, db)
        return LocalImportResponse(
            import_operation_id=payload.client_import_operation_id,
            imported_entities=[],
            merged_entities=["import"],
            skipped_entities=[],
            conflicts=[],
            warnings=["This import operation was already processed."],
            final_profile_state=profile_response(profile),
            final_progress_summary={},
        )

    # Validate every curriculum reference before changing learner data.
    for operation in payload.progress:
        if operation.operation_type == "submit_exercise":
            exercise = await db.get(ExerciseDefinition, operation.entity_id)
            if (
                exercise is None
                or int(operation.payload.get("content_version", exercise.content_version))
                != exercise.content_version
            ):
                raise HTTPException(
                    status_code=422, detail="Invalid exercise or curriculum version."
                )
        elif operation.operation_type == "complete_step":
            step = await db.get(LessonStep, operation.entity_id)
            if step is None or await db.get(Lesson, operation.payload.get("lesson_id")) is None:
                raise HTTPException(status_code=422, detail="Invalid lesson step reference.")
        else:
            lesson = await db.get(Lesson, operation.entity_id)
            if lesson is None:
                raise HTTPException(status_code=422, detail="Invalid lesson reference.")

    profile = await load_profile(user.id, db)
    imported: list[str] = []
    merged: list[str] = []
    skipped: list[str] = []
    if payload.mode == "merge":
        values = payload.profile.model_dump(exclude_unset=True)
        # Account identity remains authoritative; only learner preferences are imported.
        for field in (
            "native_language",
            "explanation_language",
            "confidence_level",
            "daily_study_minutes",
        ):
            value = values.get(field)
            if value is not None and getattr(profile, field) in (None, ""):
                setattr(profile, field, value)
                merged.append(field)
        user_fields = values.get("display_name")
        if user_fields and not user.display_name:
            user.display_name = user_fields
            merged.append("display_name")
        if values.get("learning_goals") and not profile.goals:
            from app.models import LearningGoalSelection

            profile.goals = [
                LearningGoalSelection(goal=value, profile_id=profile.id)
                for value in values["learning_goals"]
            ]
            merged.append("learning_goals")
        if values.get("difficult_areas") and not profile.difficult_areas:
            from app.models import DifficultAreaSelection

            profile.difficult_areas = [
                DifficultAreaSelection(area=value, profile_id=profile.id)
                for value in values["difficult_areas"]
            ]
            merged.append("difficult_areas")
        if payload.profile.model_dump(exclude_unset=True).get("onboarding_complete"):
            profile.onboarding_complete = True
            merged.append("onboarding_complete")
    else:
        skipped.append("local_profile")

    if payload.progress:
        await sync_progress(
            ProgressSyncRequest(
                operations=[
                    SyncOperationRequest.model_validate(item.model_dump())
                    for item in payload.progress
                ]
            ),
            user,
            db,
        )
        imported.extend(operation.client_operation_id for operation in payload.progress)

    marker = existing or OfflineSyncOperation(
        user_id=user.id,
        client_operation_id=payload.client_import_operation_id,
        operation_type="local_import",
        entity_id=user.id,
        payload=payload.model_dump(mode="json"),
    )
    marker.sync_status = "synced"
    db.add(marker)
    await db.commit()
    return LocalImportResponse(
        import_operation_id=payload.client_import_operation_id,
        imported_entities=imported,
        merged_entities=merged,
        skipped_entities=skipped,
        conflicts=[],
        warnings=["Scores were recalculated by the server."],
        final_profile_state=profile_response(await load_profile(user.id, db)),
        final_progress_summary={},
    )
