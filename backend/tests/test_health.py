from fastapi.testclient import TestClient

from app.main import app


def test_health_endpoints_return_stable_schema() -> None:
    with TestClient(app) as client:
        for path in ("/health", "/api/v1/health"):
            response = client.get(path)
            assert response.status_code == 200
            assert set(response.json()) == {"status", "service", "version", "environment"}
