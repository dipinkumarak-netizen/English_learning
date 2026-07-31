"""Idempotent Phase 3 curriculum seed command.

Run with: ``python -m app.seed`` from the backend directory.
"""

import asyncio
from uuid import NAMESPACE_URL, uuid5

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.session import session_factory
from app.models import Course, CourseModule, ExerciseDefinition, Lesson, LessonStep

EXERCISE_TYPES = [
    "single_choice",
    "multiple_choice",
    "fill_blank",
    "reorder_words",
    "match_pairs",
    "natural_sentence",
    "correct_mistake",
    "translation",
    "reading_comprehension",
    "true_false",
]

MODULES = [
    (
        "first-english-sentences",
        "First English Sentences",
        "Build small, useful sentences for meeting people.",
        [
            (
                "greetings-and-introductions",
                "Greetings and introductions",
                "Say hello and introduce yourself.",
                "Greetings and the verb be",
                ["hello", "name", "meet"],
            ),
            (
                "i-am-you-are",
                "I am, you are, he is, she is",
                "Use be with simple people descriptions.",
                "Present be",
                ["I", "you", "he", "she"],
            ),
            (
                "personal-information",
                "Simple personal information",
                "Share a name, place, and simple fact.",
                "Short questions with be",
                ["from", "city", "student"],
            ),
        ],
    ),
    (
        "everyday-objects-actions",
        "Everyday Objects and Actions",
        "Name common things and describe simple actions.",
        [
            (
                "common-objects",
                "Common objects",
                "Recognise useful objects around you.",
                "This is and these are",
                ["book", "phone", "bag"],
            ),
            (
                "this-that-these-those",
                "This, that, these, those",
                "Point to one or more nearby objects.",
                "Demonstratives",
                ["this", "that", "these", "those"],
            ),
            (
                "daily-actions",
                "Common daily verbs",
                "Use simple verbs for everyday actions.",
                "Present simple verbs",
                ["open", "eat", "go"],
            ),
        ],
    ),
    (
        "daily-routines",
        "Daily Routines",
        "Talk about a simple day and ask basic questions.",
        [
            (
                "present-simple",
                "Present simple",
                "Describe regular actions.",
                "Present simple statements",
                ["work", "live", "study"],
            ),
            (
                "time-and-routine",
                "Time and routine",
                "Say when routine actions happen.",
                "At and in for time",
                ["morning", "evening", "today"],
            ),
            (
                "simple-questions",
                "Asking simple questions",
                "Ask and answer everyday questions.",
                "Do and be questions",
                ["what", "where", "when"],
            ),
        ],
    ),
    (
        "practical-conversations",
        "Practical Conversations",
        "Handle short, polite conversations in familiar places.",
        [
            (
                "at-a-shop",
                "At a shop",
                "Ask for an item and its price.",
                "Can I have and How much",
                ["please", "price", "water"],
            ),
            (
                "asking-for-help",
                "Asking for help",
                "Ask for directions or simple assistance.",
                "Could you and where",
                ["help", "left", "right"],
            ),
            (
                "short-conversations",
                "Short everyday conversations",
                "Join a short conversation with confidence.",
                "Review of beginner questions",
                ["sorry", "thank you", "welcome"],
            ),
        ],
    ),
]


def stable_id(value: str) -> str:
    return str(uuid5(NAMESPACE_URL, f"https://nilaspeak.local/phase3/{value}"))


def exercise_payload(exercise_type: str, topic: str) -> tuple[str, list[str], object, str, str]:
    prompts = {
        "single_choice": (f"Which greeting fits {topic}?", ["Hello", "Goodbye", "Night"], "Hello"),
        "multiple_choice": (
            "Choose the two words that are people words.",
            ["I", "you", "book", "water"],
            ["I", "you"],
        ),
        "fill_blank": ("Complete: I ___ happy.", ["am", "is", "are"], ["am"]),
        "reorder_words": (
            "Put the words in a natural order.",
            ["am", "I", "ready"],
            ["I", "am", "ready"],
        ),
        "match_pairs": (
            "Match each word with its meaning.",
            ["hello=നമസ്കാരം", "thanks=നന്ദി"],
            {"hello": "നമസ്കാരം", "thanks": "നന്ദി"},
        ),
        "natural_sentence": (
            "Choose the natural sentence.",
            ["I am at home.", "Home at am I."],
            "I am at home.",
        ),
        "correct_mistake": (
            "Correct: She are my friend.",
            [],
            ["She is my friend.", "She is my friend"],
        ),
        "translation": ("Translate: എനിക്ക് വെള്ളം വേണം.", [], ["I want water.", "I need water."]),
        "reading_comprehension": (
            "Read: Mina is from Kochi. Where is Mina from?",
            ["Kochi", "Delhi"],
            "Kochi",
        ),
        "true_false": (
            "True or false: A sentence starts with a capital letter.",
            ["true", "false"],
            "true",
        ),
    }
    prompt, options, answer = prompts[exercise_type]
    return (
        prompt,
        options,
        answer,
        f"This answer practises {topic}.",
        "ഇത് ഈ പാഠത്തിലെ ലളിതമായ പ്രയോഗം പരിശീലിപ്പിക്കുന്നു.",
    )


async def seed_curriculum(db: AsyncSession) -> str:
    course = await db.scalar(select(Course).where(Course.slug == "everyday-english-foundations"))
    if course is None:
        course = Course(
            id=stable_id("course:everyday-english-foundations"),
            slug="everyday-english-foundations",
            title="Everyday English Foundations",
            short_description="A practical first course for everyday English.",
            full_description="Build useful English sentences through short lessons about people, objects, routines, and polite conversations.",
            learner_level="A1",
            native_language_support=["ml"],
            explanation_languages=["en", "ml"],
            estimated_total_minutes=240,
            version=1,
            is_published=True,
            sort_order=1,
        )
        db.add(course)
        await db.flush()
    previous_lesson_id: str | None = None
    for module_number, (module_slug, module_title, module_description, lesson_data) in enumerate(
        MODULES, 1
    ):
        module = await db.scalar(
            select(CourseModule).where(
                CourseModule.course_id == course.id, CourseModule.sort_order == module_number
            )
        )
        if module is None:
            module = CourseModule(
                id=stable_id(f"module:{module_slug}"),
                course_id=course.id,
                title=module_title,
                description=module_description,
                sort_order=module_number,
                estimated_minutes=60,
                unlock_rule="first_module" if module_number == 1 else "previous_module",
                version=1,
                is_published=True,
            )
            db.add(module)
            await db.flush()
        for lesson_number, (lesson_slug, title, summary, grammar, vocabulary) in enumerate(
            lesson_data, 1
        ):
            lesson = await db.scalar(select(Lesson).where(Lesson.slug == lesson_slug))
            if lesson is None:
                lesson = Lesson(
                    id=stable_id(f"lesson:{lesson_slug}"),
                    module_id=module.id,
                    slug=lesson_slug,
                    title=title,
                    summary=summary,
                    learning_objectives=[f"Use {grammar.lower()} in a short conversation."],
                    grammar_focus=grammar,
                    vocabulary_focus=vocabulary,
                    estimated_minutes=20,
                    difficulty="beginner",
                    sort_order=lesson_number,
                    version=1,
                    is_published=True,
                    prerequisite_lesson_id=previous_lesson_id,
                    offline_eligible=True,
                )
                db.add(lesson)
                await db.flush()
            previous_lesson_id = lesson.id
            existing_steps = int(
                await db.scalar(
                    select(func.count(LessonStep.id)).where(LessonStep.lesson_id == lesson.id)
                )
                or 0
            )
            if existing_steps == 0:
                exercise_type = EXERCISE_TYPES[
                    ((module_number - 1) * 3 + (lesson_number - 1)) % len(EXERCISE_TYPES)
                ]
                steps = [
                    ("introduction", "Start here", summary, "ഈ പാഠം ചെറിയ ഘട്ടങ്ങളായി പഠിക്കാം.", "view"),
                    (
                        "explanation",
                        "Key idea",
                        f"Remember: {grammar}.",
                        "പ്രധാന ആശയം ശ്രദ്ധിക്കുക.",
                        "view",
                    ),
                    (
                        "grammar_note",
                        "Grammar note",
                        f"Use {grammar.lower()} in a short sentence.",
                        "A short grammar reminder for this lesson.",
                        "view",
                    ),
                    (
                        "vocabulary_card",
                        "Useful words",
                        ", ".join(vocabulary),
                        "ഈ വാക്കുകൾ ദിവസേന ഉപയോഗിക്കാം.",
                        "view",
                    ),
                    (
                        "example",
                        "Example",
                        f"Here is a simple example about {title.lower()}.",
                        "ലളിതമായ ഒരു ഉദാഹരണം.",
                        "view",
                    ),
                    (
                        "reading_passage",
                        "Read and notice",
                        f"Read this short example about {title.lower()} and notice the useful words.",
                        "Read the short passage and notice the useful words.",
                        "view",
                    ),
                    (
                        "exercise",
                        "Try it",
                        "Answer the exercise and check the explanation.",
                        "ഉത്തരം നൽകി വിശദീകരണം പരിശോധിക്കുക.",
                        "exercise",
                    ),
                    (
                        "summary",
                        "Review",
                        f"You practised {grammar.lower()} and useful words.",
                        "ഇന്നത്തെ പാഠം വീണ്ടും ഓർക്കുക.",
                        "view",
                    ),
                ]
                for step_number, (step_type, step_title, content, ml, rule) in enumerate(steps, 1):
                    step = LessonStep(
                        id=stable_id(f"step:{lesson_slug}:{step_number}"),
                        lesson_id=lesson.id,
                        step_type=step_type,
                        sort_order=step_number,
                        title=step_title,
                        content_en=content,
                        explanation_ml=ml,
                        version=1,
                        is_required=True,
                        completion_rule=rule,
                    )
                    db.add(step)
                    await db.flush()
                    if step_type == "exercise":
                        prompt, options, answer, explanation_en, explanation_ml = exercise_payload(
                            exercise_type, title
                        )
                        db.add(
                            ExerciseDefinition(
                                id=stable_id(f"exercise:{lesson_slug}"),
                                step_id=step.id,
                                exercise_type=exercise_type,
                                learner_level="A1",
                                skill_category="spoken_english",
                                prompt_en=prompt,
                                support_ml="മലയാളം സഹായം ലഭ്യമാണ്.",
                                options=options,
                                correct_answer=answer,
                                explanation_en=explanation_en,
                                explanation_ml=explanation_ml,
                                scoring_weight=1,
                                max_attempts=3,
                                retry_policy="until_correct",
                                content_version=1,
                                scoring_config={"normalise": True},
                            )
                        )
    await db.commit()
    return course.id


async def main() -> None:
    async with session_factory() as db:
        course_id = await seed_curriculum(db)
        print(f"Seeded course {course_id} (idempotent)")


if __name__ == "__main__":
    asyncio.run(main())
