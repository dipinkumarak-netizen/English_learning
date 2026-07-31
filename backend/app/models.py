from datetime import datetime
from typing import Any
from uuid import uuid4

from sqlalchemy import (
    JSON,
    Boolean,
    DateTime,
    ForeignKey,
    Integer,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base


def new_id() -> str:
    return str(uuid4())


class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )


class User(TimestampMixin, Base):
    __tablename__ = "users"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    email: Mapped[str] = mapped_column(String(320), unique=True, index=True)
    display_name: Mapped[str | None] = mapped_column(String(120), nullable=True)
    password_hash: Mapped[str] = mapped_column(Text)
    refresh_sessions: Mapped[list["RefreshSession"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )
    profile: Mapped["LearnerProfile | None"] = relationship(
        back_populates="user", cascade="all, delete-orphan", uselist=False
    )


class RefreshSession(Base):
    __tablename__ = "refresh_sessions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    token_hash: Mapped[str] = mapped_column(String(64), unique=True, index=True)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    revoked_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    user: Mapped[User] = relationship(back_populates="refresh_sessions")


class LearnerProfile(TimestampMixin, Base):
    __tablename__ = "learner_profiles"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), unique=True, index=True
    )
    native_language: Mapped[str] = mapped_column(String(10), default="ml")
    explanation_language: Mapped[str] = mapped_column(String(10), default="ml")
    confidence_level: Mapped[str | None] = mapped_column(String(40), nullable=True)
    daily_study_minutes: Mapped[int | None] = mapped_column(Integer, nullable=True)
    onboarding_complete: Mapped[bool] = mapped_column(Boolean, default=False)
    user: Mapped[User] = relationship(back_populates="profile")
    goals: Mapped[list["LearningGoalSelection"]] = relationship(cascade="all, delete-orphan")
    difficult_areas: Mapped[list["DifficultAreaSelection"]] = relationship(
        cascade="all, delete-orphan"
    )


class LearningGoalSelection(Base):
    __tablename__ = "learning_goal_selections"
    __table_args__ = (UniqueConstraint("profile_id", "goal"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    profile_id: Mapped[str] = mapped_column(
        ForeignKey("learner_profiles.id", ondelete="CASCADE"), index=True
    )
    goal: Mapped[str] = mapped_column(String(50))


class DifficultAreaSelection(Base):
    __tablename__ = "difficult_area_selections"
    __table_args__ = (UniqueConstraint("profile_id", "area"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    profile_id: Mapped[str] = mapped_column(
        ForeignKey("learner_profiles.id", ondelete="CASCADE"), index=True
    )
    area: Mapped[str] = mapped_column(String(50))


class OnboardingProgress(Base):
    __tablename__ = "onboarding_progress"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), unique=True, index=True
    )
    current_step: Mapped[str] = mapped_column(String(50), default="welcome")
    completed_steps: Mapped[list[Any]] = mapped_column(JSON, default=list)
    draft: Mapped[dict[str, Any]] = mapped_column(JSON, default=dict)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )


class PlacementAssessment(Base):
    __tablename__ = "placement_assessments"

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    version: Mapped[str] = mapped_column(String(20))
    title: Mapped[str] = mapped_column(String(160))
    active: Mapped[bool] = mapped_column(Boolean, default=True)
    questions: Mapped[list["PlacementQuestion"]] = relationship(cascade="all, delete-orphan")


class PlacementQuestion(Base):
    __tablename__ = "placement_questions"

    id: Mapped[str] = mapped_column(String(80), primary_key=True)
    assessment_id: Mapped[str] = mapped_column(
        ForeignKey("placement_assessments.id", ondelete="CASCADE"), index=True
    )
    question_type: Mapped[str] = mapped_column(String(40))
    prompt: Mapped[str] = mapped_column(Text)
    options: Mapped[list[Any] | None] = mapped_column(JSON, nullable=True)
    correct_answer: Mapped[Any] = mapped_column(JSON)
    explanation_en: Mapped[str] = mapped_column(Text)
    explanation_ml: Mapped[str] = mapped_column(Text)
    score_weight: Mapped[int] = mapped_column(Integer, default=1)
    difficulty: Mapped[str] = mapped_column(String(20))
    skill_category: Mapped[str] = mapped_column(String(40))
    cefr_hint: Mapped[str | None] = mapped_column(String(10), nullable=True)
    content_version: Mapped[str] = mapped_column(String(20), default="1")


class PlacementAttempt(Base):
    __tablename__ = "placement_attempts"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    assessment_id: Mapped[str] = mapped_column(ForeignKey("placement_assessments.id"))
    status: Mapped[str] = mapped_column(String(20), default="in_progress")
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    submitted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    answers: Mapped[list["PlacementAnswer"]] = relationship(cascade="all, delete-orphan")
    result: Mapped["PlacementResult | None"] = relationship(
        cascade="all, delete-orphan", uselist=False
    )


class PlacementAnswer(Base):
    __tablename__ = "placement_answers"
    __table_args__ = (UniqueConstraint("attempt_id", "question_id"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    attempt_id: Mapped[str] = mapped_column(
        ForeignKey("placement_attempts.id", ondelete="CASCADE"), index=True
    )
    question_id: Mapped[str] = mapped_column(ForeignKey("placement_questions.id"))
    answer: Mapped[Any] = mapped_column(JSON)
    is_correct: Mapped[bool | None] = mapped_column(Boolean, nullable=True)


class PlacementResult(Base):
    __tablename__ = "placement_results"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    attempt_id: Mapped[str] = mapped_column(
        ForeignKey("placement_attempts.id", ondelete="CASCADE"), unique=True
    )
    raw_score: Mapped[int] = mapped_column(Integer)
    percentage: Mapped[float] = mapped_column()
    estimated_level: Mapped[str] = mapped_column(String(10))
    skill_breakdown: Mapped[dict[str, Any]] = mapped_column(JSON)
    strengths: Mapped[list[Any]] = mapped_column(JSON)
    improvement_areas: Mapped[list[Any]] = mapped_column(JSON)
    recommended_track: Mapped[str] = mapped_column(String(80))
    is_estimate: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class LearningPlan(Base):
    __tablename__ = "learning_plans"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    placement_result_id: Mapped[str | None] = mapped_column(
        ForeignKey("placement_results.id"), nullable=True
    )
    estimated_level: Mapped[str] = mapped_column(String(10))
    recommended_track: Mapped[str] = mapped_column(String(80))
    daily_study_minutes: Mapped[int] = mapped_column(Integer)
    priority_skills: Mapped[list[Any]] = mapped_column(JSON)
    weekly_target_minutes: Mapped[int] = mapped_column(Integer)
    study_days_per_week: Mapped[int] = mapped_column(Integer)
    first_activity_types: Mapped[list[Any]] = mapped_column(JSON)
    explanation_language: Mapped[str] = mapped_column(String(10))
    plan_version: Mapped[str] = mapped_column(String(20))
    active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class Course(TimestampMixin, Base):
    __tablename__ = "courses"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    slug: Mapped[str] = mapped_column(String(120), unique=True, index=True)
    title: Mapped[str] = mapped_column(String(200))
    short_description: Mapped[str] = mapped_column(String(500))
    full_description: Mapped[str] = mapped_column(Text)
    learner_level: Mapped[str] = mapped_column(String(10), default="A1")
    native_language_support: Mapped[list[Any]] = mapped_column(JSON, default=list)
    explanation_languages: Mapped[list[Any]] = mapped_column(JSON, default=list)
    estimated_total_minutes: Mapped[int] = mapped_column(Integer)
    version: Mapped[int] = mapped_column(Integer, default=1)
    is_published: Mapped[bool] = mapped_column(Boolean, default=False, index=True)
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    thumbnail_ref: Mapped[str | None] = mapped_column(String(200), nullable=True)


class CourseModule(TimestampMixin, Base):
    __tablename__ = "course_modules"
    __table_args__ = (UniqueConstraint("course_id", "sort_order"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    course_id: Mapped[str] = mapped_column(ForeignKey("courses.id", ondelete="CASCADE"), index=True)
    title: Mapped[str] = mapped_column(String(200))
    description: Mapped[str] = mapped_column(Text)
    sort_order: Mapped[int] = mapped_column(Integer)
    estimated_minutes: Mapped[int] = mapped_column(Integer)
    unlock_rule: Mapped[str] = mapped_column(String(40), default="previous_module")
    version: Mapped[int] = mapped_column(Integer, default=1)
    is_published: Mapped[bool] = mapped_column(Boolean, default=False, index=True)


class Lesson(TimestampMixin, Base):
    __tablename__ = "lessons"
    __table_args__ = (
        UniqueConstraint("module_id", "sort_order"),
        UniqueConstraint("course_id", "day_number"),
    )

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    module_id: Mapped[str] = mapped_column(
        ForeignKey("course_modules.id", ondelete="CASCADE"), index=True
    )
    course_id: Mapped[str] = mapped_column(ForeignKey("courses.id", ondelete="CASCADE"), index=True)
    day_number: Mapped[int] = mapped_column(Integer, index=True)
    slug: Mapped[str] = mapped_column(String(140), unique=True, index=True)
    title: Mapped[str] = mapped_column(String(200))
    summary: Mapped[str] = mapped_column(Text)
    learning_objectives: Mapped[list[Any]] = mapped_column(JSON, default=list)
    grammar_focus: Mapped[str] = mapped_column(String(160))
    vocabulary_focus: Mapped[list[Any]] = mapped_column(JSON, default=list)
    estimated_minutes: Mapped[int] = mapped_column(Integer)
    difficulty: Mapped[str] = mapped_column(String(20), default="beginner")
    sort_order: Mapped[int] = mapped_column(Integer)
    version: Mapped[int] = mapped_column(Integer, default=1)
    is_published: Mapped[bool] = mapped_column(Boolean, default=False, index=True)
    prerequisite_lesson_id: Mapped[str | None] = mapped_column(
        ForeignKey("lessons.id", ondelete="SET NULL"), nullable=True
    )
    offline_eligible: Mapped[bool] = mapped_column(Boolean, default=True)


class LessonStep(TimestampMixin, Base):
    __tablename__ = "lesson_steps"
    __table_args__ = (UniqueConstraint("lesson_id", "sort_order"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    lesson_id: Mapped[str] = mapped_column(ForeignKey("lessons.id", ondelete="CASCADE"), index=True)
    step_type: Mapped[str] = mapped_column(String(30))
    sort_order: Mapped[int] = mapped_column(Integer)
    title: Mapped[str] = mapped_column(String(200))
    content_en: Mapped[str] = mapped_column(Text)
    explanation_ml: Mapped[str | None] = mapped_column(Text, nullable=True)
    audio_ref: Mapped[str | None] = mapped_column(String(200), nullable=True)
    version: Mapped[int] = mapped_column(Integer, default=1)
    is_required: Mapped[bool] = mapped_column(Boolean, default=True)
    completion_rule: Mapped[str] = mapped_column(String(40), default="view")


class ExerciseDefinition(Base):
    __tablename__ = "exercise_definitions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    step_id: Mapped[str] = mapped_column(
        ForeignKey("lesson_steps.id", ondelete="CASCADE"), unique=True, index=True
    )
    exercise_type: Mapped[str] = mapped_column(String(40))
    learner_level: Mapped[str] = mapped_column(String(10), default="A1")
    skill_category: Mapped[str] = mapped_column(String(40))
    prompt_en: Mapped[str] = mapped_column(Text)
    support_ml: Mapped[str | None] = mapped_column(Text, nullable=True)
    options: Mapped[list[Any] | None] = mapped_column(JSON, nullable=True)
    correct_answer: Mapped[Any] = mapped_column(JSON)
    explanation_en: Mapped[str] = mapped_column(Text)
    explanation_ml: Mapped[str | None] = mapped_column(Text, nullable=True)
    scoring_weight: Mapped[int] = mapped_column(Integer, default=1)
    max_attempts: Mapped[int] = mapped_column(Integer, default=3)
    retry_policy: Mapped[str] = mapped_column(String(30), default="until_correct")
    content_version: Mapped[int] = mapped_column(Integer, default=1)
    scoring_config: Mapped[dict[str, Any]] = mapped_column(JSON, default=dict)


class CourseEnrollment(Base):
    __tablename__ = "course_enrollments"
    __table_args__ = (UniqueConstraint("user_id", "course_id"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    course_id: Mapped[str] = mapped_column(ForeignKey("courses.id", ondelete="CASCADE"), index=True)
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    current_lesson_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    last_activity_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )


class LessonProgress(Base):
    __tablename__ = "lesson_progress"
    __table_args__ = (UniqueConstraint("user_id", "lesson_id"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    lesson_id: Mapped[str] = mapped_column(ForeignKey("lessons.id", ondelete="CASCADE"), index=True)
    current_step_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    started_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    last_activity_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    score: Mapped[float] = mapped_column(default=0)
    total_attempts: Mapped[int] = mapped_column(Integer, default=0)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    sync_state: Mapped[str] = mapped_column(String(20), default="synced")


class LessonStepProgress(Base):
    __tablename__ = "lesson_step_progress"
    __table_args__ = (UniqueConstraint("user_id", "step_id"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    step_id: Mapped[str] = mapped_column(
        ForeignKey("lesson_steps.id", ondelete="CASCADE"), index=True
    )
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class ExerciseAttempt(Base):
    __tablename__ = "exercise_attempts"
    __table_args__ = (UniqueConstraint("client_operation_id"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    exercise_id: Mapped[str] = mapped_column(ForeignKey("exercise_definitions.id"), index=True)
    content_version: Mapped[int] = mapped_column(Integer)
    answer_snapshot: Mapped[Any] = mapped_column(JSON)
    is_correct: Mapped[bool] = mapped_column(Boolean)
    score: Mapped[float] = mapped_column()
    attempt_number: Mapped[int] = mapped_column(Integer)
    client_operation_id: Mapped[str] = mapped_column(String(80), index=True)
    submitted_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )


class OfflineSyncOperation(Base):
    __tablename__ = "offline_sync_operations"
    __table_args__ = (UniqueConstraint("user_id", "client_operation_id"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    client_operation_id: Mapped[str] = mapped_column(String(80))
    operation_type: Mapped[str] = mapped_column(String(40))
    entity_id: Mapped[str] = mapped_column(String(36))
    payload: Mapped[dict[str, Any]] = mapped_column(JSON)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    retry_count: Mapped[int] = mapped_column(Integer, default=0)
    last_error: Mapped[str | None] = mapped_column(Text, nullable=True)
    sync_status: Mapped[str] = mapped_column(String(20), default="pending")


class TutorConversation(TimestampMixin, Base):
    __tablename__ = "tutor_conversations"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    mode: Mapped[str] = mapped_column(String(40))
    title: Mapped[str] = mapped_column(String(160), default="English practice")
    learner_level_snapshot: Mapped[str] = mapped_column(String(10), default="A1")
    explanation_language_snapshot: Mapped[str] = mapped_column(String(10), default="en")
    correction_mode: Mapped[str] = mapped_column(String(40), default="important")
    status: Mapped[str] = mapped_column(String(20), default="active", index=True)
    archived_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)


class TutorMessage(Base):
    __tablename__ = "tutor_messages"
    __table_args__ = (UniqueConstraint("conversation_id", "sequence_number"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    conversation_id: Mapped[str] = mapped_column(
        ForeignKey("tutor_conversations.id", ondelete="CASCADE"), index=True
    )
    client_operation_id: Mapped[str | None] = mapped_column(String(80), unique=True, nullable=True)
    role: Mapped[str] = mapped_column(String(20))
    original_learner_text: Mapped[str | None] = mapped_column(Text, nullable=True)
    tutor_reply: Mapped[str | None] = mapped_column(Text, nullable=True)
    structured_response: Mapped[dict[str, Any] | None] = mapped_column(JSON, nullable=True)
    provider: Mapped[str | None] = mapped_column(String(40), nullable=True)
    model: Mapped[str | None] = mapped_column(String(100), nullable=True)
    input_tokens: Mapped[int | None] = mapped_column(Integer, nullable=True)
    output_tokens: Mapped[int | None] = mapped_column(Integer, nullable=True)
    sequence_number: Mapped[int] = mapped_column(Integer)
    error_state: Mapped[str | None] = mapped_column(String(40), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class TutorSessionPreference(Base):
    __tablename__ = "tutor_session_preferences"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    conversation_id: Mapped[str] = mapped_column(
        ForeignKey("tutor_conversations.id", ondelete="CASCADE"), unique=True
    )
    correction_mode: Mapped[str] = mapped_column(String(40))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class TutorCorrection(Base):
    __tablename__ = "tutor_corrections"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    conversation_id: Mapped[str] = mapped_column(
        ForeignKey("tutor_conversations.id", ondelete="CASCADE"), index=True
    )
    message_id: Mapped[str] = mapped_column(
        ForeignKey("tutor_messages.id", ondelete="CASCADE"), index=True
    )
    original_sentence: Mapped[str] = mapped_column(Text)
    corrected_sentence: Mapped[str] = mapped_column(Text)
    natural_alternative: Mapped[str | None] = mapped_column(Text, nullable=True)
    mistake_category: Mapped[str] = mapped_column(String(40), index=True)
    explanation_en: Mapped[str] = mapped_column(Text)
    explanation_ml: Mapped[str | None] = mapped_column(Text, nullable=True)
    examples: Mapped[list[Any]] = mapped_column(JSON, default=list)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class MistakeNotebookEntry(Base):
    __tablename__ = "mistake_notebook_entries"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    correction_id: Mapped[str] = mapped_column(
        ForeignKey("tutor_corrections.id", ondelete="CASCADE"), index=True
    )
    original_sentence: Mapped[str] = mapped_column(Text)
    corrected_sentence: Mapped[str] = mapped_column(Text)
    natural_alternative: Mapped[str | None] = mapped_column(Text, nullable=True)
    mistake_category: Mapped[str] = mapped_column(String(40), index=True)
    explanation_en: Mapped[str] = mapped_column(Text)
    explanation_ml: Mapped[str | None] = mapped_column(Text, nullable=True)
    examples: Mapped[list[Any]] = mapped_column(JSON, default=list)
    first_seen_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    last_seen_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    repeat_count: Mapped[int] = mapped_column(Integer, default=1)
    review_status: Mapped[str] = mapped_column(String(20), default="unreviewed")
    mastered: Mapped[bool] = mapped_column(Boolean, default=False)
    mastered_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)


class TutorSessionSummary(Base):
    __tablename__ = "tutor_session_summaries"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    conversation_id: Mapped[str] = mapped_column(
        ForeignKey("tutor_conversations.id", ondelete="CASCADE"), unique=True
    )
    message_count: Mapped[int] = mapped_column(Integer)
    learner_message_count: Mapped[int] = mapped_column(Integer)
    corrected_sentences: Mapped[list[Any]] = mapped_column(JSON, default=list)
    frequent_mistake_categories: Mapped[list[Any]] = mapped_column(JSON, default=list)
    new_vocabulary: Mapped[list[Any]] = mapped_column(JSON, default=list)
    strengths: Mapped[list[Any]] = mapped_column(JSON, default=list)
    improvement_areas: Mapped[list[Any]] = mapped_column(JSON, default=list)
    suggested_next_practice: Mapped[str] = mapped_column(Text)
    session_duration_seconds: Mapped[int] = mapped_column(Integer, default=0)
    generated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )


class AIUsageRecord(Base):
    __tablename__ = "ai_usage_records"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    conversation_id: Mapped[str | None] = mapped_column(
        ForeignKey("tutor_conversations.id", ondelete="SET NULL"), nullable=True, index=True
    )
    provider: Mapped[str] = mapped_column(String(40))
    model: Mapped[str] = mapped_column(String(100))
    request_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), index=True
    )
    input_tokens: Mapped[int] = mapped_column(Integer, default=0)
    output_tokens: Mapped[int] = mapped_column(Integer, default=0)
    total_tokens: Mapped[int] = mapped_column(Integer, default=0)
    request_status: Mapped[str] = mapped_column(String(30))
    latency_ms: Mapped[int | None] = mapped_column(Integer, nullable=True)
    estimated_cost: Mapped[float | None] = mapped_column(nullable=True)
    failure_category: Mapped[str | None] = mapped_column(String(40), nullable=True)


class VoiceConversationSession(TimestampMixin, Base):
    __tablename__ = "voice_conversation_sessions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    conversation_id: Mapped[str] = mapped_column(
        ForeignKey("tutor_conversations.id", ondelete="CASCADE"), index=True
    )
    tutor_mode: Mapped[str] = mapped_column(String(40))
    status: Mapped[str] = mapped_column(String(20), default="active", index=True)
    language: Mapped[str] = mapped_column(String(10), default="en")
    explanation_language: Mapped[str] = mapped_column(String(10), default="en")
    recording_mode: Mapped[str] = mapped_column(String(20), default="tap")
    auto_play: Mapped[bool] = mapped_column(Boolean, default=False)
    playback_speed: Mapped[float] = mapped_column(default=1.0)
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    total_learner_audio_seconds: Mapped[int] = mapped_column(Integer, default=0)
    total_tutor_audio_seconds: Mapped[int] = mapped_column(Integer, default=0)
    total_voice_turns: Mapped[int] = mapped_column(Integer, default=0)


class VoiceTurn(Base):
    __tablename__ = "voice_turns"
    __table_args__ = (
        UniqueConstraint("session_id", "client_operation_id"),
        UniqueConstraint("session_id", "turn_number"),
    )

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    session_id: Mapped[str] = mapped_column(
        ForeignKey("voice_conversation_sessions.id", ondelete="CASCADE"), index=True
    )
    conversation_id: Mapped[str] = mapped_column(
        ForeignKey("tutor_conversations.id", ondelete="CASCADE"), index=True
    )
    turn_number: Mapped[int] = mapped_column(Integer)
    client_operation_id: Mapped[str] = mapped_column(String(80))
    learner_audio_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    recording_duration_seconds: Mapped[int] = mapped_column(Integer, default=0)
    transcription_status: Mapped[str] = mapped_column(String(24), default="pending")
    transcript: Mapped[str | None] = mapped_column(Text, nullable=True)
    edited_transcript: Mapped[str | None] = mapped_column(Text, nullable=True)
    detected_language: Mapped[str | None] = mapped_column(String(20), nullable=True)
    stt_provider: Mapped[str | None] = mapped_column(String(40), nullable=True)
    stt_model: Mapped[str | None] = mapped_column(String(100), nullable=True)
    stt_operation_id: Mapped[str | None] = mapped_column(String(80), nullable=True, unique=True)
    tutor_message_id: Mapped[str | None] = mapped_column(String(36), nullable=True, index=True)
    tutor_audio_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    synthesis_status: Mapped[str] = mapped_column(String(24), default="not_requested")
    synthesis_operation_id: Mapped[str | None] = mapped_column(
        String(80), nullable=True, unique=True
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    failure_category: Mapped[str | None] = mapped_column(String(40), nullable=True)


class AudioAsset(Base):
    __tablename__ = "voice_audio_assets"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    session_id: Mapped[str] = mapped_column(
        ForeignKey("voice_conversation_sessions.id", ondelete="CASCADE"), index=True
    )
    turn_id: Mapped[str] = mapped_column(
        ForeignKey("voice_turns.id", ondelete="CASCADE"), index=True
    )
    asset_type: Mapped[str] = mapped_column(String(20))
    storage_key: Mapped[str] = mapped_column(String(240), unique=True)
    mime_type: Mapped[str] = mapped_column(String(80))
    byte_size: Mapped[int] = mapped_column(Integer)
    duration_seconds: Mapped[int] = mapped_column(Integer, default=0)
    provider: Mapped[str | None] = mapped_column(String(40), nullable=True)
    model: Mapped[str | None] = mapped_column(String(100), nullable=True)
    status: Mapped[str] = mapped_column(String(24), default="temporary")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)


class VoicePreference(Base):
    __tablename__ = "voice_preferences"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), unique=True)
    voice: Mapped[str] = mapped_column(String(40), default="default")
    auto_play: Mapped[bool] = mapped_column(Boolean, default=False)
    playback_speed: Mapped[float] = mapped_column(default=1.0)
    transcript_visible: Mapped[bool] = mapped_column(Boolean, default=True)
    recording_mode: Mapped[str] = mapped_column(String(20), default="tap")
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class VoiceUsageRecord(Base):
    __tablename__ = "voice_usage_records"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    session_id: Mapped[str | None] = mapped_column(
        ForeignKey("voice_conversation_sessions.id", ondelete="SET NULL"), nullable=True, index=True
    )
    turn_id: Mapped[str | None] = mapped_column(
        ForeignKey("voice_turns.id", ondelete="SET NULL"), nullable=True, index=True
    )
    provider: Mapped[str] = mapped_column(String(40))
    model: Mapped[str] = mapped_column(String(100))
    operation: Mapped[str] = mapped_column(String(30))
    audio_duration_seconds: Mapped[int] = mapped_column(Integer, default=0)
    synthesis_characters: Mapped[int] = mapped_column(Integer, default=0)
    request_status: Mapped[str] = mapped_column(String(30))
    latency_ms: Mapped[int | None] = mapped_column(Integer, nullable=True)
    provider_usage: Mapped[dict[str, Any]] = mapped_column(JSON, default=dict)
    failure_category: Mapped[str | None] = mapped_column(String(40), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class PromptTemplateVersion(Base):
    __tablename__ = "prompt_template_versions"
    __table_args__ = (UniqueConstraint("task", "version"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_id)
    task: Mapped[str] = mapped_column(String(50), index=True)
    version: Mapped[int] = mapped_column(Integer)
    template_text: Mapped[str] = mapped_column(Text)
    active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
