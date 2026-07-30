from collections import defaultdict
from typing import Any

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models import (
    LearnerProfile,
    LearningPlan,
    PlacementAssessment,
    PlacementAttempt,
    PlacementQuestion,
    PlacementResult,
)

ASSESSMENT_ID = "placement-foundation-v1"
QUESTIONS: list[dict[str, Any]] = [
    {
        "id": "vocab-001",
        "type": "single_choice",
        "prompt": "Choose the closest meaning of 'begin'.",
        "options": ["start", "finish", "forget"],
        "answer": "start",
        "en": "'Begin' means 'start'.",
        "ml": "Begin means start.",
        "difficulty": "beginner",
        "skill": "vocabulary",
        "cefr": "A1",
    },
    {
        "id": "vocab-002",
        "type": "single_choice",
        "prompt": "I drink water when I am ___.",
        "options": ["hungry", "thirsty", "sleepy"],
        "answer": "thirsty",
        "en": "We feel thirsty when we need a drink.",
        "ml": "Use thirsty when you need a drink.",
        "difficulty": "beginner",
        "skill": "vocabulary",
        "cefr": "A1",
    },
    {
        "id": "grammar-001",
        "type": "single_choice",
        "prompt": "She ___ to work every day.",
        "options": ["go", "goes", "going"],
        "answer": "goes",
        "en": "Use goes with she in the simple present.",
        "ml": "Use goes with she in the simple present.",
        "difficulty": "beginner",
        "skill": "grammar",
        "cefr": "A1",
    },
    {
        "id": "grammar-002",
        "type": "correct_mistake",
        "prompt": "Choose the natural sentence.",
        "options": ["He don't like tea.", "He doesn't like tea.", "He not likes tea."],
        "answer": "He doesn't like tea.",
        "en": "Use doesn't with he, she, or it.",
        "ml": "Use doesn't with he, she, or it.",
        "difficulty": "elementary",
        "skill": "grammar",
        "cefr": "A2",
    },
    {
        "id": "sentence-001",
        "type": "reorder_words",
        "prompt": "Put the words in the correct order: morning / every / walk / I",
        "options": None,
        "answer": "I walk every morning",
        "en": "A natural order is subject, verb, time.",
        "ml": "A natural order is subject, verb, time.",
        "difficulty": "beginner",
        "skill": "sentence_formation",
        "cefr": "A1",
    },
    {
        "id": "sentence-002",
        "type": "fill_blank",
        "prompt": "I am interested ___ learning English.",
        "options": ["in", "on", "at"],
        "answer": "in",
        "en": "The phrase is interested in.",
        "ml": "The phrase is interested in.",
        "difficulty": "elementary",
        "skill": "sentence_formation",
        "cefr": "A2",
    },
    {
        "id": "reading-001",
        "type": "reading_question",
        "prompt": "Anu takes the bus at eight. What does Anu take?",
        "options": ["a train", "a bus", "a taxi"],
        "answer": "a bus",
        "en": "The passage says Anu takes the bus.",
        "ml": "The passage says Anu takes the bus.",
        "difficulty": "beginner",
        "skill": "reading",
        "cefr": "A1",
    },
    {
        "id": "reading-002",
        "type": "reading_question",
        "prompt": "Ravi works in a clinic and helps patients. Where does Ravi work?",
        "options": ["a clinic", "a bank", "a school"],
        "answer": "a clinic",
        "en": "Ravi works in a clinic.",
        "ml": "Ravi works in a clinic.",
        "difficulty": "elementary",
        "skill": "reading",
        "cefr": "A2",
    },
]


async def get_or_seed_assessment(db: AsyncSession) -> PlacementAssessment:
    assessment = await db.scalar(
        select(PlacementAssessment)
        .options(selectinload(PlacementAssessment.questions))
        .where(PlacementAssessment.id == ASSESSMENT_ID)
    )
    if assessment is None:
        assessment = PlacementAssessment(
            id=ASSESSMENT_ID, version="1", title="NilaSpeak placement check", active=True
        )
        db.add(assessment)
        await db.flush()
        for item in QUESTIONS:
            db.add(
                PlacementQuestion(
                    id=item["id"],
                    assessment_id=ASSESSMENT_ID,
                    question_type=item["type"],
                    prompt=item["prompt"],
                    options=item["options"],
                    correct_answer=item["answer"],
                    explanation_en=item["en"],
                    explanation_ml=item["ml"],
                    difficulty=item["difficulty"],
                    skill_category=item["skill"],
                    cefr_hint=item["cefr"],
                    content_version="1",
                )
            )
        await db.flush()
        await db.refresh(assessment, ["questions"])
    return assessment


def normalise_answer(answer: Any) -> str:
    if isinstance(answer, list):
        return " ".join(str(value).strip().lower() for value in answer)
    return " ".join(str(answer).strip().lower().split())


def score_attempt(attempt: PlacementAttempt, questions: list[PlacementQuestion]) -> dict[str, Any]:
    answers = {answer.question_id: answer for answer in attempt.answers}
    raw = 0
    maximum = 0
    skill_scores: dict[str, list[int]] = defaultdict(lambda: [0, 0])
    for question in questions:
        maximum += question.score_weight
        answer = answers.get(question.id)
        correct = answer is not None and normalise_answer(answer.answer) == normalise_answer(
            question.correct_answer
        )
        if answer is not None:
            answer.is_correct = correct
        score = question.score_weight if correct else 0
        raw += score
        skill_scores[question.skill_category][0] += score
        skill_scores[question.skill_category][1] += question.score_weight
    percentage = round((raw / maximum) * 100, 2) if maximum else 0
    level = (
        "B2"
        if percentage >= 85
        else "B1"
        if percentage >= 70
        else "A2"
        if percentage >= 50
        else "A1"
        if percentage >= 25
        else "Pre-A1"
    )
    breakdown = {
        skill: {
            "score": values[0],
            "maximum": values[1],
            "percentage": round(values[0] / values[1] * 100, 2),
        }
        for skill, values in skill_scores.items()
    }
    strengths = [skill for skill, value in breakdown.items() if value["percentage"] >= 75]
    improvements = [skill for skill, value in breakdown.items() if value["percentage"] < 60]
    return {
        "raw_score": raw,
        "percentage": percentage,
        "estimated_level": level,
        "skill_breakdown": breakdown,
        "strengths": strengths,
        "improvement_areas": improvements,
        "recommended_track": f"{level} spoken English foundations",
    }


async def create_learning_plan(
    db: AsyncSession, user_id: str, result: PlacementResult | None = None
) -> LearningPlan:
    profile = await db.scalar(
        select(LearnerProfile)
        .options(selectinload(LearnerProfile.goals), selectinload(LearnerProfile.difficult_areas))
        .where(LearnerProfile.user_id == user_id)
    )
    if profile is None:
        raise ValueError("Learner profile is required.")
    level = result.estimated_level if result else "A1"
    track = result.recommended_track if result else "A1 spoken English foundations"
    priority = [area.area for area in profile.difficult_areas] or ["speaking", "grammar"]
    daily = profile.daily_study_minutes or 10
    days = 5
    plans = (
        await db.scalars(
            select(LearningPlan).where(
                LearningPlan.user_id == user_id, LearningPlan.active.is_(True)
            )
        )
    ).all()
    for old_plan in plans:
        old_plan.active = False
    plan = LearningPlan(
        user_id=user_id,
        placement_result_id=result.id if result else None,
        estimated_level=level,
        recommended_track=track,
        daily_study_minutes=daily,
        priority_skills=priority,
        weekly_target_minutes=daily * days,
        study_days_per_week=days,
        first_activity_types=["warm_up", "guided_speaking", "grammar_practice"],
        explanation_language=profile.explanation_language,
        plan_version="1",
    )
    db.add(plan)
    await db.flush()
    return plan
