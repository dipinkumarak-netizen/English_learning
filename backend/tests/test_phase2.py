from fastapi.testclient import TestClient


def register(client: TestClient, email: str = "learner@example.com") -> dict:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": "SafePass123", "display_name": "Learner"},
    )
    assert response.status_code == 201
    return response.json()


def test_authentication_hashes_password_and_rotates_refresh_token(client: TestClient) -> None:
    auth = register(client)
    assert "password" not in auth["user"]
    headers = {"Authorization": f"Bearer {auth['access_token']}"}
    assert client.get("/api/v1/auth/me", headers=headers).status_code == 200
    assert (
        client.post(
            "/api/v1/auth/login",
            json={"email": "learner@example.com", "password": "wrong-password"},
        ).status_code
        == 401
    )
    rotated = client.post("/api/v1/auth/refresh", json={"refresh_token": auth["refresh_token"]})
    assert rotated.status_code == 200
    assert rotated.json()["refresh_token"] != auth["refresh_token"]
    assert (
        client.post(
            "/api/v1/auth/refresh", json={"refresh_token": auth["refresh_token"]}
        ).status_code
        == 401
    )
    rotated_headers = {"Authorization": f"Bearer {rotated.json()['access_token']}"}
    assert (
        client.post(
            "/api/v1/auth/logout",
            headers=rotated_headers,
            json={"refresh_token": rotated.json()["refresh_token"]},
        ).status_code
        == 204
    )
    assert (
        client.post(
            "/api/v1/auth/refresh", json={"refresh_token": rotated.json()["refresh_token"]}
        ).status_code
        == 401
    )


def test_duplicate_and_disabled_registration(client: TestClient, monkeypatch) -> None:
    register(client)
    assert (
        client.post(
            "/api/v1/auth/register",
            json={"email": "learner@example.com", "password": "SafePass123"},
        ).status_code
        == 409
    )
    monkeypatch.setenv("ALLOW_REGISTRATION", "false")
    from app.core.config import get_settings

    get_settings.cache_clear()
    assert (
        client.post(
            "/api/v1/auth/register", json={"email": "new@example.com", "password": "SafePass123"}
        ).status_code
        == 403
    )
    assert (
        client.post(
            "/api/v1/auth/login", json={"email": "learner@example.com", "password": "SafePass123"}
        ).status_code
        == 200
    )


def test_onboarding_progress_profile_and_completion(client: TestClient) -> None:
    auth = register(client)
    headers = {"Authorization": f"Bearer {auth['access_token']}"}
    response = client.put(
        "/api/v1/onboarding/progress",
        headers=headers,
        json={
            "current_step": "goals",
            "completed_steps": ["welcome"],
            "draft": {"native_language": "ml"},
        },
    )
    assert response.status_code == 200
    assert (
        client.get("/api/v1/onboarding/progress", headers=headers).json()["current_step"] == "goals"
    )
    payload = {
        "profile": {
            "native_language": "ml",
            "explanation_language": "ml",
            "confidence_level": "basics",
            "daily_study_minutes": 10,
            "learning_goals": ["beginner_english", "grammar"],
            "difficult_areas": ["speaking", "grammar"],
        }
    }
    completed = client.post("/api/v1/onboarding/complete", headers=headers, json=payload)
    assert completed.status_code == 200
    assert completed.json()["onboarding_complete"] is True


def test_placement_scoring_plan_and_double_submit(client: TestClient) -> None:
    auth = register(client)
    headers = {"Authorization": f"Bearer {auth['access_token']}"}
    assessment = client.get("/api/v1/placement/assessment", headers=headers).json()
    assert len(assessment["questions"]) == 8
    attempt = client.post("/api/v1/placement/attempts", headers=headers).json()
    answers = {
        "vocab-001": "start",
        "vocab-002": "thirsty",
        "grammar-001": "goes",
        "grammar-002": "He doesn't like tea.",
        "sentence-001": "I walk every morning",
        "sentence-002": "in",
        "reading-001": "a bus",
        "reading-002": "a clinic",
    }
    for question_id, answer in answers.items():
        response = client.put(
            f"/api/v1/placement/attempts/{attempt['id']}/answers/{question_id}",
            headers=headers,
            json={"answer": answer},
        )
        assert response.status_code == 200
    result = client.post(f"/api/v1/placement/attempts/{attempt['id']}/submit", headers=headers)
    assert result.status_code == 200
    assert result.json()["percentage"] == 100.0
    duplicate = client.post(f"/api/v1/placement/attempts/{attempt['id']}/submit", headers=headers)
    assert duplicate.status_code == 200
    assert client.get("/api/v1/learning-plan", headers=headers).json()["estimated_level"] == "B2"


def test_private_resources_are_owner_scoped(client: TestClient) -> None:
    first = register(client, "first@example.com")
    second = register(client, "second@example.com")
    first_headers = {"Authorization": f"Bearer {first['access_token']}"}
    second_headers = {"Authorization": f"Bearer {second['access_token']}"}
    attempt = client.post("/api/v1/placement/attempts", headers=first_headers).json()
    assert (
        client.get(
            f"/api/v1/placement/attempts/{attempt['id']}", headers=second_headers
        ).status_code
        == 404
    )


def test_malformed_token_logout_all_and_profile_validation(client: TestClient) -> None:
    auth = register(client)
    headers = {"Authorization": f"Bearer {auth['access_token']}"}
    assert (
        client.get("/api/v1/auth/me", headers={"Authorization": "Bearer malformed"}).status_code
        == 401
    )
    obsolete = client.put("/api/v1/profile", headers=headers, json={"application_language": "fr"})
    assert obsolete.status_code == 200
    assert "application_language" not in obsolete.json()
    assert client.post("/api/v1/auth/logout-all", headers=headers).status_code == 204


def test_native_language_defaults_explanation_language(client: TestClient) -> None:
    auth = register(client)
    headers = {"Authorization": f"Bearer {auth['access_token']}"}
    response = client.put("/api/v1/profile", headers=headers, json={"native_language": "en"})
    assert response.status_code == 200
    assert response.json()["native_language"] == "en"
    assert response.json()["explanation_language"] == "en"
