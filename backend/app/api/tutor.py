from collections import Counter
from datetime import UTC, datetime

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import delete, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.ai.providers import ProviderMalformed, ProviderRequest, ProviderUnavailable
from app.ai.safety import safety_redirect
from app.core.config import get_settings
from app.db.session import get_db
from app.dependencies import current_user
from app.models import (
    AIUsageRecord,
    LearnerProfile,
    MistakeNotebookEntry,
    TutorConversation,
    TutorCorrection,
    TutorMessage,
    TutorSessionPreference,
    TutorSessionSummary,
    User,
)
from app.provider_credentials import build_user_provider
from app.schemas import (
    MistakeResponse,
    MistakeUpdateRequest,
    TutorConversationCreate,
    TutorConversationResponse,
    TutorConversationUpdate,
    TutorMessageRequest,
    TutorMessageResponse,
    TutorModeResponse,
    TutorResponsePayload,
    TutorSummaryResponse,
    TutorUsageResponse,
)

router = APIRouter(prefix="/tutor", tags=["tutor"])

MODES = [
    ("free_conversation", "Free conversation", "Practise a relaxed everyday conversation."),
    ("beginner_conversation", "Beginner conversation", "Use short, clear beginner English."),
    ("grammar_correction", "Grammar correction", "Find and understand important grammar mistakes."),
    ("sentence_improvement", "Sentence improvement", "Make a sentence clearer and more natural."),
    ("ml_to_english", "Malayalam to English", "Turn a Malayalam idea into useful English."),
    (
        "english_to_ml",
        "English explanation",
        "Understand an English sentence with Malayalam support.",
    ),
    ("guided_lesson", "Guided lesson support", "Ask for help with your current course lesson."),
    ("role_play", "Role-play foundation", "Practise a short text-only everyday scenario."),
    ("vocabulary_practice", "Vocabulary practice", "Learn and use a few practical words."),
    (
        "writing_correction",
        "Writing correction",
        "Improve a short message, paragraph, or email draft.",
    ),
]


def _conversation_response(conversation: TutorConversation) -> TutorConversationResponse:
    return TutorConversationResponse(
        id=conversation.id,
        mode=conversation.mode,
        title=conversation.title,
        learner_level_snapshot=conversation.learner_level_snapshot,
        explanation_language_snapshot=conversation.explanation_language_snapshot,
        correction_mode=conversation.correction_mode,
        status=conversation.status,
        created_at=conversation.created_at,
        updated_at=conversation.updated_at,
        archived_at=conversation.archived_at,
    )


def _message_response(message: TutorMessage) -> TutorMessageResponse:
    structured = (
        TutorResponsePayload.model_validate(message.structured_response)
        if message.structured_response
        else None
    )
    return TutorMessageResponse(
        id=message.id,
        conversation_id=message.conversation_id,
        role=message.role,
        original_learner_text=message.original_learner_text,
        tutor_reply=message.tutor_reply,
        structured_response=structured,
        sequence_number=message.sequence_number,
        created_at=message.created_at,
        error_state=message.error_state,
    )


async def _owned_conversation(
    conversation_id: str, user_id: str, db: AsyncSession
) -> TutorConversation:
    conversation = await db.scalar(
        select(TutorConversation).where(
            TutorConversation.id == conversation_id, TutorConversation.user_id == user_id
        )
    )
    if conversation is None:
        raise HTTPException(status_code=404, detail="Tutor conversation not found.")
    return conversation


async def _profile_snapshot(user: User, db: AsyncSession) -> tuple[str, str]:
    profile = await db.scalar(select(LearnerProfile).where(LearnerProfile.user_id == user.id))
    return ("A1", profile.explanation_language if profile else "en")


async def _usage_today(user_id: str, db: AsyncSession) -> tuple[int, int]:
    since = datetime.now(UTC).replace(hour=0, minute=0, second=0, microsecond=0)
    requests = int(
        await db.scalar(
            select(func.count(AIUsageRecord.id)).where(
                AIUsageRecord.user_id == user_id, AIUsageRecord.request_at >= since
            )
        )
        or 0
    )
    tokens = int(
        await db.scalar(
            select(func.coalesce(func.sum(AIUsageRecord.total_tokens), 0)).where(
                AIUsageRecord.user_id == user_id, AIUsageRecord.request_at >= since
            )
        )
        or 0
    )
    return requests, tokens


def _check_safety_and_limits(text: str) -> None:
    settings = get_settings()
    if len(text) > settings.ai_max_message_characters:
        raise HTTPException(
            status_code=413, detail="Tutor messages are limited to 2,000 characters."
        )
    if len(text) > 100 and len(set(text)) <= 3:
        raise HTTPException(
            status_code=422, detail="Please send a meaningful English-learning message."
        )


@router.get("/modes")
async def tutor_modes(user: User = Depends(current_user)) -> dict[str, list[TutorModeResponse]]:
    return {
        "modes": [
            TutorModeResponse(id=mode, title=title, description=description)
            for mode, title, description in MODES
        ]
    }


@router.post("/conversations", response_model=TutorConversationResponse, status_code=201)
async def create_conversation(
    payload: TutorConversationCreate,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> TutorConversationResponse:
    level, language = await _profile_snapshot(user, db)
    conversation = TutorConversation(
        user_id=user.id,
        mode=payload.mode,
        title="English practice",
        learner_level_snapshot=level,
        explanation_language_snapshot=language,
        correction_mode=payload.correction_mode,
        status="active",
    )
    db.add(conversation)
    await db.flush()
    db.add(
        TutorSessionPreference(
            conversation_id=conversation.id, correction_mode=payload.correction_mode
        )
    )
    await db.commit()
    return _conversation_response(conversation)


@router.get("/conversations")
async def list_conversations(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> dict[str, list[TutorConversationResponse]]:
    conversations = (
        await db.scalars(
            select(TutorConversation)
            .where(TutorConversation.user_id == user.id)
            .order_by(TutorConversation.updated_at.desc())
        )
    ).all()
    return {"conversations": [_conversation_response(item) for item in conversations]}


@router.get("/conversations/{conversation_id}", response_model=TutorConversationResponse)
async def get_conversation(
    conversation_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> TutorConversationResponse:
    return _conversation_response(await _owned_conversation(conversation_id, user.id, db))


@router.patch("/conversations/{conversation_id}", response_model=TutorConversationResponse)
async def update_conversation(
    conversation_id: str,
    payload: TutorConversationUpdate,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> TutorConversationResponse:
    conversation = await _owned_conversation(conversation_id, user.id, db)
    if payload.title is not None:
        conversation.title = payload.title
    if payload.correction_mode is not None:
        conversation.correction_mode = payload.correction_mode
    if payload.archived is not None:
        conversation.status = "archived" if payload.archived else "active"
        conversation.archived_at = datetime.now(UTC) if payload.archived else None
    await db.commit()
    return _conversation_response(conversation)


@router.delete("/conversations/{conversation_id}", status_code=204)
async def delete_conversation(
    conversation_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> None:
    conversation = await _owned_conversation(conversation_id, user.id, db)
    await db.delete(conversation)
    await db.commit()


@router.delete("/conversations", status_code=204)
async def delete_all_conversations(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> None:
    await db.execute(delete(TutorConversation).where(TutorConversation.user_id == user.id))
    await db.commit()


@router.get("/conversations/{conversation_id}/messages")
async def list_messages(
    conversation_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> dict[str, list[TutorMessageResponse]]:
    await _owned_conversation(conversation_id, user.id, db)
    messages = (
        await db.scalars(
            select(TutorMessage)
            .where(TutorMessage.conversation_id == conversation_id)
            .order_by(TutorMessage.sequence_number)
        )
    ).all()
    return {"messages": [_message_response(item) for item in messages]}


@router.post("/conversations/{conversation_id}/messages", response_model=TutorMessageResponse)
async def send_message(
    conversation_id: str,
    payload: TutorMessageRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> TutorMessageResponse:
    conversation = await _owned_conversation(conversation_id, user.id, db)
    if conversation.status != "active":
        raise HTTPException(
            status_code=409, detail="Archived conversations cannot receive new messages."
        )
    _check_safety_and_limits(payload.text)
    duplicate = await db.scalar(
        select(TutorMessage).where(TutorMessage.client_operation_id == payload.client_operation_id)
    )
    if duplicate is not None:
        if duplicate.conversation_id != conversation.id:
            raise HTTPException(
                status_code=409, detail="Message operation belongs to another conversation."
            )
        existing_reply = await db.scalar(
            select(TutorMessage).where(
                TutorMessage.conversation_id == conversation.id,
                TutorMessage.sequence_number == duplicate.sequence_number + 1,
                TutorMessage.role == "tutor",
            )
        )
        return _message_response(existing_reply or duplicate)
    requests, tokens = await _usage_today(user.id, db)
    settings = get_settings()
    if requests >= settings.ai_daily_request_limit or tokens >= settings.ai_daily_token_limit:
        raise HTTPException(
            status_code=429, detail="Daily tutor safety limit reached. Please try again tomorrow."
        )
    last_sequence = int(
        await db.scalar(
            select(func.max(TutorMessage.sequence_number)).where(
                TutorMessage.conversation_id == conversation.id
            )
        )
        or 0
    )
    learner_message = TutorMessage(
        conversation_id=conversation.id,
        client_operation_id=payload.client_operation_id,
        role="learner",
        original_learner_text=payload.text,
        sequence_number=last_sequence + 1,
    )
    db.add(learner_message)
    await db.flush()
    safety = safety_redirect(payload.text)
    provider = await build_user_provider("ai", user, db, settings)
    started = datetime.now(UTC)
    response: TutorResponsePayload
    provider_name = provider.name
    model = provider.model
    status = "success"
    failure: str | None = None
    if safety is not None:
        response = safety
        provider_name = "safety"
        model = "deterministic"
    else:
        context_messages = (
            await db.scalars(
                select(TutorMessage)
                .where(TutorMessage.conversation_id == conversation.id)
                .order_by(TutorMessage.sequence_number.desc())
                .limit(settings.ai_conversation_context_limit)
            )
        ).all()
        try:
            response = await provider.generate(
                ProviderRequest(
                    mode=conversation.mode,
                    text=payload.text,
                    explanation_language=conversation.explanation_language_snapshot,
                    learner_level=conversation.learner_level_snapshot,
                    correction_mode=conversation.correction_mode,
                    context=[
                        {
                            "role": item.role,
                            "text": item.original_learner_text or item.tutor_reply or "",
                        }
                        for item in reversed(context_messages)
                    ],
                )
            )
            response = TutorResponsePayload.model_validate(response.model_dump())
        except ProviderUnavailable as error:
            await db.rollback()
            raise HTTPException(status_code=503, detail=str(error)) from error
        except (ProviderMalformed, ValueError) as error:
            await db.rollback()
            raise HTTPException(
                status_code=502, detail="The tutor returned an invalid response. Please retry."
            ) from error
    output_tokens = max(len(response.reply_text) // 4, 1)
    input_tokens = max(len(payload.text) // 4, 1)
    tutor_message = TutorMessage(
        conversation_id=conversation.id,
        role="tutor",
        tutor_reply=response.reply_text,
        structured_response=response.model_dump(),
        provider=provider_name,
        model=model,
        input_tokens=input_tokens,
        output_tokens=output_tokens,
        sequence_number=last_sequence + 2,
    )
    db.add(tutor_message)
    await db.flush()
    if response.mistake_detected and response.corrected_sentence:
        correction = TutorCorrection(
            user_id=user.id,
            conversation_id=conversation.id,
            message_id=tutor_message.id,
            original_sentence=payload.text,
            corrected_sentence=response.corrected_sentence,
            natural_alternative=response.natural_alternative,
            mistake_category=response.mistake_category or "unnatural_expression",
            explanation_en=response.explanation_en or "Review this sentence pattern.",
            explanation_ml=response.explanation_ml,
            examples=response.examples,
        )
        db.add(correction)
        await db.flush()
        existing = await db.scalar(
            select(MistakeNotebookEntry).where(
                MistakeNotebookEntry.user_id == user.id,
                MistakeNotebookEntry.original_sentence == payload.text,
                MistakeNotebookEntry.mistake_category == correction.mistake_category,
            )
        )
        if existing is None:
            db.add(
                MistakeNotebookEntry(
                    user_id=user.id,
                    correction_id=correction.id,
                    original_sentence=correction.original_sentence,
                    corrected_sentence=correction.corrected_sentence,
                    natural_alternative=correction.natural_alternative,
                    mistake_category=correction.mistake_category,
                    explanation_en=correction.explanation_en,
                    explanation_ml=correction.explanation_ml,
                    examples=correction.examples,
                )
            )
        else:
            existing.repeat_count += 1
            existing.last_seen_at = datetime.now(UTC)
    db.add(
        AIUsageRecord(
            user_id=user.id,
            conversation_id=conversation.id,
            provider=provider_name,
            model=model,
            input_tokens=input_tokens,
            output_tokens=output_tokens,
            total_tokens=input_tokens + output_tokens,
            request_status=status,
            latency_ms=int((datetime.now(UTC) - started).total_seconds() * 1000),
            failure_category=failure,
        )
    )
    conversation.updated_at = datetime.now(UTC)
    await db.commit()
    return _message_response(tutor_message)


@router.post("/conversations/{conversation_id}/complete", response_model=TutorSummaryResponse)
async def complete_conversation(
    conversation_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> TutorSummaryResponse:
    conversation = await _owned_conversation(conversation_id, user.id, db)
    messages = (
        await db.scalars(
            select(TutorMessage)
            .where(TutorMessage.conversation_id == conversation.id)
            .order_by(TutorMessage.sequence_number)
        )
    ).all()
    corrections = (
        await db.scalars(
            select(TutorCorrection).where(TutorCorrection.conversation_id == conversation.id)
        )
    ).all()
    categories = Counter(item.mistake_category for item in corrections)
    vocabulary = [
        word
        for message in messages
        if message.structured_response
        for word in message.structured_response.get("vocabulary_items", [])
    ]
    summary = await db.scalar(
        select(TutorSessionSummary).where(TutorSessionSummary.conversation_id == conversation.id)
    )
    if summary is None:
        summary = TutorSessionSummary(
            conversation_id=conversation.id,
            message_count=len(messages),
            learner_message_count=sum(item.role == "learner" for item in messages),
            corrected_sentences=[item.corrected_sentence for item in corrections],
            frequent_mistake_categories=list(categories),
            new_vocabulary=list(dict.fromkeys(vocabulary)),
            strengths=["You completed a focused English practice session."],
            improvement_areas=list(categories) or ["Keep building short, clear sentences."],
            suggested_next_practice="Write three short sentences using today’s corrected pattern.",
            session_duration_seconds=0,
        )
        db.add(summary)
    conversation.status = "completed"
    await db.commit()
    return TutorSummaryResponse(
        conversation_id=conversation.id,
        message_count=summary.message_count,
        learner_message_count=summary.learner_message_count,
        corrected_sentences=summary.corrected_sentences,
        frequent_mistake_categories=summary.frequent_mistake_categories,
        new_vocabulary=summary.new_vocabulary,
        strengths=summary.strengths,
        improvement_areas=summary.improvement_areas,
        suggested_next_practice=summary.suggested_next_practice,
        session_duration_seconds=summary.session_duration_seconds,
        generated_at=summary.generated_at,
    )


@router.get("/conversations/{conversation_id}/summary", response_model=TutorSummaryResponse)
async def conversation_summary(
    conversation_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> TutorSummaryResponse:
    await _owned_conversation(conversation_id, user.id, db)
    summary = await db.scalar(
        select(TutorSessionSummary).where(TutorSessionSummary.conversation_id == conversation_id)
    )
    if summary is None:
        raise HTTPException(status_code=404, detail="Session summary is not available yet.")
    return TutorSummaryResponse.model_validate(summary, from_attributes=True)


@router.get("/usage", response_model=TutorUsageResponse)
async def tutor_usage(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> TutorUsageResponse:
    requests, tokens = await _usage_today(user.id, db)
    settings = get_settings()
    return TutorUsageResponse(
        requests_today=requests,
        tokens_today=tokens,
        daily_request_limit=settings.ai_daily_request_limit,
        daily_token_limit=settings.ai_daily_token_limit,
        provider_enabled=settings.ai_provider_enabled,
        provider=settings.ai_provider,
    )


@router.get("/mistakes")
async def list_mistakes(
    category: str | None = Query(default=None),
    mastered: bool | None = Query(default=None),
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> dict[str, list[MistakeResponse]]:
    query = select(MistakeNotebookEntry).where(MistakeNotebookEntry.user_id == user.id)
    if category is not None:
        query = query.where(MistakeNotebookEntry.mistake_category == category)
    if mastered is not None:
        query = query.where(MistakeNotebookEntry.mastered.is_(mastered))
    entries = (await db.scalars(query.order_by(MistakeNotebookEntry.last_seen_at.desc()))).all()
    return {
        "mistakes": [MistakeResponse.model_validate(item, from_attributes=True) for item in entries]
    }


@router.get("/mistakes/{mistake_id}", response_model=MistakeResponse)
async def get_mistake(
    mistake_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> MistakeResponse:
    entry = await db.scalar(
        select(MistakeNotebookEntry).where(
            MistakeNotebookEntry.id == mistake_id, MistakeNotebookEntry.user_id == user.id
        )
    )
    if entry is None:
        raise HTTPException(status_code=404, detail="Mistake not found.")
    return MistakeResponse.model_validate(entry, from_attributes=True)


@router.patch("/mistakes/{mistake_id}", response_model=MistakeResponse)
async def update_mistake(
    mistake_id: str,
    payload: MistakeUpdateRequest,
    user: User = Depends(current_user),
    db: AsyncSession = Depends(get_db),
) -> MistakeResponse:
    entry = await db.scalar(
        select(MistakeNotebookEntry).where(
            MistakeNotebookEntry.id == mistake_id, MistakeNotebookEntry.user_id == user.id
        )
    )
    if entry is None:
        raise HTTPException(status_code=404, detail="Mistake not found.")
    if payload.review_status is not None:
        entry.review_status = payload.review_status
    if payload.mastered is not None:
        entry.mastered = payload.mastered
        entry.mastered_at = datetime.now(UTC) if payload.mastered else None
    await db.commit()
    return MistakeResponse.model_validate(entry, from_attributes=True)


@router.post("/mistakes/{mistake_id}/master", response_model=MistakeResponse)
async def master_mistake(
    mistake_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> MistakeResponse:
    return await update_mistake(
        mistake_id, MistakeUpdateRequest(mastered=True, review_status="reviewed"), user, db
    )


@router.delete("/mistakes/{mistake_id}", status_code=204)
async def delete_mistake(
    mistake_id: str, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> None:
    entry = await db.scalar(
        select(MistakeNotebookEntry).where(
            MistakeNotebookEntry.id == mistake_id, MistakeNotebookEntry.user_id == user.id
        )
    )
    if entry is None:
        raise HTTPException(status_code=404, detail="Mistake not found.")
    await db.delete(entry)
    await db.commit()
