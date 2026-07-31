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
TutorMode = Literal[
    "free_conversation",
    "beginner_conversation",
    "grammar_correction",
    "sentence_improvement",
    "ml_to_english",
    "english_to_ml",
    "guided_lesson",
    "role_play",
    "vocabulary_practice",
    "writing_correction",
]
CorrectionMode = Literal["important", "major_only", "finish_first", "session_end"]
MistakeCategory = Literal[
    "tense",
    "article",
    "preposition",
    "word_order",
    "subject_verb_agreement",
    "singular_plural",
    "pronoun",
    "vocabulary_choice",
    "spelling",
    "punctuation",
    "unnatural_expression",
    "no_significant_mistake",
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
    onboarding_complete: bool | None = None


class LocalImportProgress(BaseModel):
    client_operation_id: str = Field(min_length=8, max_length=80)
    operation_type: Literal["start_lesson", "complete_step", "submit_exercise", "complete_lesson"]
    entity_id: str = Field(min_length=1, max_length=80)
    payload: dict[str, Any] = Field(default_factory=dict)


class LocalImportRequest(BaseModel):
    client_import_operation_id: str = Field(min_length=8, max_length=80)
    mode: Literal["merge", "account"] = "merge"
    profile: ProfileUpdate = Field(default_factory=ProfileUpdate)
    progress: list[LocalImportProgress] = Field(default_factory=list, max_length=500)


class LocalImportResponse(BaseModel):
    import_operation_id: str
    imported_entities: list[str]
    merged_entities: list[str]
    skipped_entities: list[str]
    conflicts: list[dict[str, Any]]
    warnings: list[str]
    final_profile_state: ProfileResponse
    final_progress_summary: dict[str, Any]


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
    day_number: int
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


class TutorConversationCreate(BaseModel):
    mode: TutorMode
    correction_mode: CorrectionMode = "important"


class TutorConversationUpdate(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=160)
    archived: bool | None = None
    correction_mode: CorrectionMode | None = None


class TutorConversationResponse(BaseModel):
    id: str
    mode: str
    title: str
    learner_level_snapshot: str
    explanation_language_snapshot: str
    correction_mode: str
    status: str
    created_at: datetime | None
    updated_at: datetime | None
    archived_at: datetime | None


class TutorMessageRequest(BaseModel):
    text: str = Field(min_length=1, max_length=2000)
    client_operation_id: str = Field(min_length=8, max_length=80)

    @field_validator("text")
    @classmethod
    def meaningful_text(cls, value: str) -> str:
        if not value.strip() or len(set(value.strip())) < 2:
            raise ValueError("Please enter a meaningful learning message.")
        return value.strip()


class TutorResponsePayload(BaseModel):
    reply_text: str
    corrected_sentence: str | None = None
    natural_alternative: str | None = None
    mistake_detected: bool = False
    mistake_category: MistakeCategory | None = None
    explanation_en: str | None = None
    explanation_ml: str | None = None
    examples: list[str] = Field(default_factory=list, max_length=3)
    encouragement: str | None = None
    follow_up_question: str | None = None
    vocabulary_items: list[str] = Field(default_factory=list, max_length=8)
    safety_status: Literal["safe", "redirected"] = "safe"
    provider_usage: dict[str, Any] = Field(default_factory=dict)


class TutorMessageResponse(BaseModel):
    id: str
    conversation_id: str
    role: str
    original_learner_text: str | None
    tutor_reply: str | None
    structured_response: TutorResponsePayload | None
    sequence_number: int
    created_at: datetime | None
    error_state: str | None


class MistakeResponse(BaseModel):
    id: str
    original_sentence: str
    corrected_sentence: str
    natural_alternative: str | None
    mistake_category: str
    explanation_en: str
    explanation_ml: str | None
    examples: list[Any]
    repeat_count: int
    review_status: str
    mastered: bool
    mastered_at: datetime | None


class MistakeUpdateRequest(BaseModel):
    review_status: Literal["unreviewed", "reviewed"] | None = None
    mastered: bool | None = None


class TutorSummaryResponse(BaseModel):
    conversation_id: str
    message_count: int
    learner_message_count: int
    corrected_sentences: list[Any]
    frequent_mistake_categories: list[Any]
    new_vocabulary: list[Any]
    strengths: list[Any]
    improvement_areas: list[Any]
    suggested_next_practice: str
    session_duration_seconds: int
    generated_at: datetime | None


class TutorUsageResponse(BaseModel):
    requests_today: int
    tokens_today: int
    daily_request_limit: int
    daily_token_limit: int
    provider_enabled: bool
    provider: str


ProviderCapability = Literal["ai", "stt", "tts"]
ProviderName = Literal["none", "mock", "openai"]
ProviderTestStatus = Literal["success", "failed"]


class ProviderSettingsUpdate(BaseModel):
    provider: ProviderName
    api_key: str | None = Field(default=None, min_length=1, max_length=500)
    model: str | None = Field(default=None, max_length=160)
    base_url: str | None = Field(default=None, max_length=240)
    voice: str | None = Field(default=None, max_length=40)
    enabled: bool = False


class ProviderSettingsSummary(BaseModel):
    capability: ProviderCapability
    provider: str
    configured: bool
    key_last4: str | None
    model: str | None
    base_url: str | None
    voice: str | None
    enabled: bool
    last_test_status: str | None
    last_tested_at: datetime | None
    updated_at: datetime | None


class ProviderSettingsResponse(BaseModel):
    providers: list[ProviderSettingsSummary]


class ProviderTestRequest(BaseModel):
    provider: ProviderName
    api_key: str | None = Field(default=None, min_length=1, max_length=500)
    model: str | None = Field(default=None, max_length=160)
    base_url: str | None = Field(default=None, max_length=240)
    voice: str | None = Field(default=None, max_length=40)


class ProviderTestResponse(BaseModel):
    status: ProviderTestStatus
    message: str
    tested_at: datetime


class TutorModeResponse(BaseModel):
    id: str
    title: str
    description: str


class VoiceSessionCreate(BaseModel):
    conversation_id: str
    recording_mode: Literal["tap"] = "tap"
    auto_play: bool = False
    playback_speed: float = 1.0

    @field_validator("playback_speed")
    @classmethod
    def supported_speed(cls, value: float) -> float:
        if value not in {0.75, 1.0, 1.25}:
            raise ValueError("Playback speed must be 0.75, 1.0, or 1.25.")
        return value


class VoiceTranscriptUpdate(BaseModel):
    transcript: str = Field(min_length=1, max_length=2000)


class VoiceSubmitRequest(BaseModel):
    client_operation_id: str = Field(min_length=8, max_length=80)


class VoiceSynthesisRequest(BaseModel):
    client_operation_id: str = Field(min_length=8, max_length=80)
    text_kind: Literal["reply", "correction", "alternative"] = "reply"


class VoicePreferenceUpdate(BaseModel):
    voice: str = Field(default="default", min_length=1, max_length=40)
    auto_play: bool = False
    playback_speed: float = 1.0
    transcript_visible: bool = True
    recording_mode: Literal["tap"] = "tap"

    @field_validator("playback_speed")
    @classmethod
    def supported_speed(cls, value: float) -> float:
        if value not in {0.75, 1.0, 1.25}:
            raise ValueError("Playback speed must be 0.75, 1.0, or 1.25.")
        return value
