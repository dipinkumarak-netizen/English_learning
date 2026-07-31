import asyncio

from conftest import test_session_factory as session_factory
from sqlalchemy import func, select

from app.models import Course, CourseModule, ExerciseDefinition, Lesson
from app.seed import seed_curriculum


def seed() -> str:
    async def run() -> str:
        async with session_factory() as db:
            return await seed_curriculum(db)

    return asyncio.run(run())


def register(client):
    response = client.post(
        "/api/v1/auth/register",
        json={"email": "phase3@example.com", "password": "Password123", "display_name": "Learner"},
    )
    return response.json()


def auth_headers(response: dict) -> dict[str, str]:
    return {"Authorization": f"Bearer {response['access_token']}"}


def test_curriculum_seed_is_idempotent(client):
    first = seed()
    second = seed()
    assert first == second

    async def counts() -> tuple[int, int, int, int]:
        async with session_factory() as db:
            return (
                int(await db.scalar(select(func.count(Course.id))) or 0),
                int(await db.scalar(select(func.count(CourseModule.id))) or 0),
                int(await db.scalar(select(func.count(Lesson.id))) or 0),
                int(await db.scalar(select(func.count(ExerciseDefinition.id))) or 0),
            )

    assert asyncio.run(counts()) == (1, 4, 12, 12)


def test_course_delivery_progress_and_deterministic_attempt(client):
    seed()
    auth = register(client)
    headers = auth_headers(auth)
    courses = client.get("/api/v1/courses", headers=headers)
    assert courses.status_code == 200
    course = courses.json()["courses"][0]
    lesson = course["modules"][0]["lessons"][0]
    assert client.post(f"/api/v1/lessons/{lesson['id']}/start", headers=headers).status_code == 200
    detail = client.get(f"/api/v1/lessons/{lesson['id']}", headers=headers).json()
    exercise_step = next(step for step in detail["steps"] if step["step_type"] == "exercise")
    exercise = exercise_step["exercise"]
    assert "correct_answer" not in exercise
    attempt = client.post(
        f"/api/v1/exercises/{exercise['id']}/attempts",
        headers=headers,
        json={"answer": "Hello", "client_operation_id": "phase3-attempt-001"},
    )
    assert attempt.status_code == 200
    assert attempt.json()["is_correct"] is True
    duplicate = client.post(
        f"/api/v1/exercises/{exercise['id']}/attempts",
        headers=headers,
        json={"answer": "wrong", "client_operation_id": "phase3-attempt-001"},
    )
    assert duplicate.status_code == 200
    assert duplicate.json()["is_correct"] is True


def test_course_lessons_expose_stable_daily_sequence(client):
    seed()
    auth = register(client)
    headers = auth_headers(auth)
    course = client.get("/api/v1/courses", headers=headers).json()["courses"][0]
    lessons = [
        lesson
        for module in course["modules"]
        for lesson in module["lessons"]
    ]

    assert [lesson["day_number"] for lesson in lessons] == list(range(1, 13))
    assert lessons[0]["unlocked"] is True
    assert lessons[1]["unlocked"] is False


def test_locked_lesson_rejects_access(client):
    seed()
    auth = register(client)
    headers = auth_headers(auth)
    courses = client.get("/api/v1/courses", headers=headers).json()["courses"][0]
    second = courses["modules"][0]["lessons"][1]
    assert client.post(f"/api/v1/lessons/{second['id']}/start", headers=headers).status_code == 423


def test_progress_is_scoped_and_sync_operations_are_idempotent(client):
    seed()
    first = register(client)
    first_headers = auth_headers(first)
    course = client.get("/api/v1/courses", headers=first_headers).json()["courses"][0]
    lesson = course["modules"][0]["lessons"][0]
    assert (
        client.post(f"/api/v1/lessons/{lesson['id']}/start", headers=first_headers).status_code
        == 200
    )

    second = client.post(
        "/api/v1/auth/register",
        json={"email": "other@example.com", "password": "Password123", "display_name": "Other"},
    ).json()
    second_headers = auth_headers(second)
    other_progress = client.get(f"/api/v1/lessons/{lesson['id']}/progress", headers=second_headers)
    assert other_progress.status_code == 200
    assert other_progress.json()["completed_steps"] == []

    operation = {
        "operations": [
            {
                "client_operation_id": "sync-start-001",
                "operation_type": "start_lesson",
                "entity_id": lesson["id"],
                "payload": {},
            }
        ]
    }
    first_sync = client.post("/api/v1/progress/sync", headers=first_headers, json=operation)
    second_sync = client.post("/api/v1/progress/sync", headers=first_headers, json=operation)
    assert first_sync.json()["processed"] == ["sync-start-001"]
    assert second_sync.json()["processed"] == ["sync-start-001"]
