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
    application_language: Mapped[str] = mapped_column(String(10), default="ml")
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
