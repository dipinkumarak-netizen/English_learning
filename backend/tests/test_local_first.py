import asyncio

from conftest import test_session_factory as session_factory
from sqlalchemy import select

from app.models import LearnerProfile


def register(client, email="local-first@example.com"):
    return client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": "Password123", "display_name": "Learner"},
    ).json()


def headers(auth):
    return {"Authorization": f"Bearer {auth['access_token']}"}


def test_local_import_requires_authentication(client):
    response = client.post(
        "/api/v1/sync/local-import",
        json={"client_import_operation_id": "unauth-import-001", "profile": {}, "progress": []},
    )
    assert response.status_code == 401


def test_local_import_merges_profile_and_is_idempotent(client):
    auth = register(client)
    payload = {
        "client_import_operation_id": "local-import-001",
        "mode": "merge",
        "profile": {
            "native_language": "ml",
            "explanation_language": "ml",
            "confidence_level": "basics",
            "daily_study_minutes": 15,
            "learning_goals": ["beginner_english"],
            "difficult_areas": ["grammar"],
            "onboarding_complete": True,
        },
        "progress": [],
    }
    first = client.post("/api/v1/sync/local-import", headers=headers(auth), json=payload)
    assert first.status_code == 200
    assert "onboarding_complete" in first.json()["merged_entities"]
    second = client.post("/api/v1/sync/local-import", headers=headers(auth), json=payload)
    assert second.status_code == 200
    assert "already processed" in second.json()["warnings"][0]

    async def read_profile():
        async with session_factory() as db:
            return await db.scalar(
                select(LearnerProfile).where(LearnerProfile.user_id == auth["user"]["id"])
            )

    assert asyncio.run(read_profile()).onboarding_complete is True


def test_local_import_rejects_invalid_curriculum(client):
    auth = register(client, "invalid-import@example.com")
    response = client.post(
        "/api/v1/sync/local-import",
        headers=headers(auth),
        json={
            "client_import_operation_id": "invalid-import-001",
            "progress": [
                {
                    "client_operation_id": "invalid-op-001",
                    "operation_type": "complete_lesson",
                    "entity_id": "missing-lesson",
                    "payload": {},
                }
            ],
        },
    )
    assert response.status_code == 422


def test_account_deletion_is_separate_from_local_import(client):
    auth = register(client, "delete-account@example.com")
    response = client.delete("/api/v1/auth/account", headers=headers(auth))
    assert response.status_code == 204
    assert client.get("/api/v1/auth/me", headers=headers(auth)).status_code == 401
