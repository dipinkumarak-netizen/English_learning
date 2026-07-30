from datetime import datetime
from typing import Any, Literal

from pydantic import BaseModel, ConfigDict, EmailStr, Field, field_validator

Language = Literal["ml", "en"]
Confidence = Literal[
    "basics", "words", "sentences", "short_conversations", "frequent_mistakes", "comfortable"
]
Goals = Literal[
    "daily_spoken_english",
    "beginner_english",
    "grammar",
    "vocabulary",
    "pronunciation",
    "job_interview",
    "workplace",
    "travel",
    "writing",
    "fluency",
]
Areas = Literal[
    "speaking",
    "listening",
    "grammar",
    "vocabulary",
    "pronunciation",
    "reading",
    "writing",
    "confidence",
]


class UserPublic(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: str
    email: str
    display_name: str | None = None


class AuthResponse(BaseModel):
    user: UserPublic
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)
    display_name: str | None = Field(default=None, max_length=120)

    @field_validator("password")
    @classmethod
    def password_strength(cls, value: str) -> str:
        if not any(char.isalpha() for char in value) or not any(char.isdigit() for char in value):
            raise ValueError("Password must contain letters and numbers.")
        return value


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class RefreshRequest(BaseModel):
    refresh_token: str = Field(min_length=20)


class ProfileResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    application_language: str
    native_language: str
    explanation_language: str
    confidence_level: str | None
    daily_study_minutes: int | None
    onboarding_complete: bool
    learning_goals: list[str]
    difficult_areas: list[str]
    updated_at: datetime | None = None


class ProfileUpdate(BaseModel):
    application_language: Language | None = None
    native_language: Language | None = None
    explanation_language: Language | None = None
    confidence_level: Confidence | None = None
    daily_study_minutes: int | None = Field(default=None, ge=5, le=180)
    learning_goals: list[Goals] | None = None
    difficult_areas: list[Areas] | None = None
    display_name: str | None = Field(default=None, max_length=120)


class OnboardingProgressRequest(BaseModel):
    current_step: str = Field(min_length=1, max_length=50)
    completed_steps: list[str] = Field(default_factory=list)
    draft: dict[str, Any] = Field(default_factory=dict)


class OnboardingProgressResponse(OnboardingProgressRequest):
    updated_at: datetime | None = None


class CompleteOnboardingRequest(BaseModel):
    profile: ProfileUpdate


class PlacementQuestionResponse(BaseModel):
    id: str
    question_type: str
    prompt: str
    options: list[Any] | None
    difficulty: str
    skill_category: str
    cefr_hint: str | None


class PlacementAssessmentResponse(BaseModel):
    id: str
    version: str
    title: str
    questions: list[PlacementQuestionResponse]


class PlacementAttemptResponse(BaseModel):
    id: str
    status: str
    answers: dict[str, Any]


class PlacementAnswerRequest(BaseModel):
    answer: Any


class PlacementResultResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    raw_score: int
    percentage: float
    estimated_level: str
    skill_breakdown: dict[str, Any]
    strengths: list[Any]
    improvement_areas: list[Any]
    recommended_track: str
    is_estimate: bool


class LearningPlanResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    estimated_level: str
    recommended_track: str
    daily_study_minutes: int
    priority_skills: list[Any]
    weekly_target_minutes: int
    study_days_per_week: int
    first_activity_types: list[Any]
    explanation_language: str
    plan_version: str
    created_at: datetime | None = None
