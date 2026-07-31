from dataclasses import dataclass
from typing import Protocol

from app.core.config import Settings
from app.schemas import TutorResponsePayload


class ProviderUnavailable(Exception):
    pass


class ProviderTimeout(Exception):
    pass


class ProviderMalformed(Exception):
    pass


@dataclass(frozen=True)
class ProviderRequest:
    mode: str
    text: str
    explanation_language: str
    learner_level: str
    correction_mode: str
    context: list[dict[str, str]]


class TextGenerationProvider(Protocol):
    name: str
    model: str

    async def generate(self, request: ProviderRequest) -> TutorResponsePayload: ...


class DisabledProvider:
    name = "disabled"
    model = "none"

    async def generate(self, request: ProviderRequest) -> TutorResponsePayload:
        raise ProviderUnavailable("AI tutor is not configured.")


class MockTutorProvider:
    name = "mock"
    model = "mock-tutor-v1"

    async def generate(self, request: ProviderRequest) -> TutorResponsePayload:
        text = request.text.strip()
        if request.mode in {"grammar_correction", "writing_correction", "sentence_improvement"}:
            if text.casefold() in {"i am go school", "i go to school yesterday"}:
                corrected = (
                    "I am going to school." if "am go" in text else "I went to school yesterday."
                )
                explanation_ml = "വാക്യത്തിലെ ക്രിയയുടെ രൂപം ശരിയാക്കി."
                return TutorResponsePayload(
                    reply_text="Here is a clearer version of your sentence.",
                    corrected_sentence=corrected,
                    natural_alternative=corrected,
                    mistake_detected=True,
                    mistake_category="tense",
                    explanation_en="Use the correct verb form for the time in the sentence.",
                    explanation_ml=explanation_ml if request.explanation_language == "ml" else None,
                    examples=["I am going to school now."],
                    encouragement="Good attempt—keep practising.",
                    follow_up_question="Can you write one more sentence about today?",
                )
            return TutorResponsePayload(
                reply_text="Your sentence is clear. A natural alternative is to keep it short.",
                mistake_detected=False,
                mistake_category="no_significant_mistake",
                encouragement="Nice work.",
                follow_up_question="Would you like to practise another sentence?",
            )
        if request.mode == "ml_to_english":
            return TutorResponsePayload(
                reply_text="A useful English version is: I want water.",
                explanation_en="Use ‘I want’ to express a simple need.",
                explanation_ml="ഒരു ആവശ്യം പറയാൻ ‘I want’ ഉപയോഗിക്കാം.",
                examples=["I want tea."],
                vocabulary_items=["want", "water"],
                follow_up_question="What else do you want?",
            )
        return TutorResponsePayload(
            reply_text=f"Let us practise together. You wrote: “{text}”",
            encouragement="Every short sentence is useful practice.",
            follow_up_question="Can you add one more detail?",
            vocabulary_items=["practise", "detail"],
        )


def build_provider(settings: Settings) -> TextGenerationProvider:
    if not settings.ai_provider_enabled or settings.ai_provider in {"", "none"}:
        return DisabledProvider()
    if settings.ai_provider == "mock":
        return MockTutorProvider()
    # Real provider adapters are intentionally isolated behind this boundary.
    # They can be added without exposing provider SDKs to Flutter.
    raise ProviderUnavailable(f"Unsupported AI provider: {settings.ai_provider}")
