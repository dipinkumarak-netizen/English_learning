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
    native_language: str
    explanation_language: str
    confidence_level: str | None
    daily_study_minutes: int | None
    onboarding_complete: bool
    learning_goals: list[str]
    difficult_areas: list[str]
    updated_at: datetime | None = None


class ProfileUpdate(BaseModel):
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


class ExerciseDefinitionResponse(BaseModel):
    id: str
    exercise_type: str
    learner_level: str
    skill_category: str
    prompt_en: str
    support_ml: str | None
    options: list[Any] | None
    explanation_en: str
    explanation_ml: str | None
    scoring_weight: int
    max_attempts: int
    retry_policy: str
    content_version: int


class LessonStepResponse(BaseModel):
    id: str
    step_type: str
    sort_order: int
    title: str
    content_en: str
    explanation_ml: str | None
    version: int
    is_required: bool
    completion_rule: str
    exercise: ExerciseDefinitionResponse | None = None


class LessonSummaryResponse(BaseModel):
    id: str
    slug: str
    title: str
    summary: str
    learning_objectives: list[Any]
    grammar_focus: str
    vocabulary_focus: list[Any]
    estimated_minutes: int
    difficulty: str
    sort_order: int
    version: int
    is_published: bool
    offline_eligible: bool
    unlocked: bool = False
    completed: bool = False
    score: float = 0


class ModuleResponse(BaseModel):
    id: str
    title: str
    description: str
    sort_order: int
    estimated_minutes: int
    unlock_rule: str
    version: int
    is_published: bool
    lessons: list[LessonSummaryResponse] = []
    unlocked: bool = False


class CourseResponse(BaseModel):
    id: str
    slug: str
    title: str
    short_description: str
    full_description: str
    learner_level: str
    native_language_support: list[Any]
    explanation_languages: list[Any]
    estimated_total_minutes: int
    version: int
    is_published: bool
    thumbnail_ref: str | None
    completion_percentage: float = 0
    downloaded: bool = False
    modules: list[ModuleResponse] = []


class LessonDetailResponse(LessonSummaryResponse):
    module_id: str
    steps: list[LessonStepResponse]


class StepProgressRequest(BaseModel):
    completed: bool = True
    client_operation_id: str = Field(min_length=8, max_length=80)


class ExerciseAttemptRequest(BaseModel):
    answer: Any
    client_operation_id: str = Field(min_length=8, max_length=80)


class ExerciseAttemptResponse(BaseModel):
    attempt_id: str
    is_correct: bool
    score: float
    attempt_number: int
    attempts_remaining: int
    explanation_en: str
    explanation_ml: str | None
    completed: bool


class LessonCompletionResponse(BaseModel):
    lesson_id: str
    completed: bool
    score: float
    completed_exercises: int
    correct_answers: int
    incorrect_answers: int
    attempt_count: int
    next_lesson_id: str | None
    vocabulary_reviewed: list[Any]
    grammar_focus: str
    completed_at: datetime | None


class ProgressSummaryResponse(BaseModel):
    courses_started: int
    lessons_completed: int
    lessons_available: int
    completion_percentage: float
    current_lesson_id: str | None


class SyncOperationRequest(BaseModel):
    client_operation_id: str = Field(min_length=8, max_length=80)
    operation_type: Literal["start_lesson", "complete_step", "submit_exercise", "complete_lesson"]
    entity_id: str
    payload: dict[str, Any] = Field(default_factory=dict)


class ProgressSyncRequest(BaseModel):
    operations: list[SyncOperationRequest] = Field(max_length=50)


class ProgressSyncResponse(BaseModel):
    processed: list[str]
    failed: list[dict[str, str]]
