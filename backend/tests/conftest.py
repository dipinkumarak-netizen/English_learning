import asyncio
from collections.abc import AsyncGenerator, Generator
from pathlib import Path

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.core.config import get_settings
from app.db.base import Base
from app.db.session import get_db
from app.main import app

TEST_DB = Path(__file__).with_name("phase2_test.db")
test_engine = create_async_engine(
    f"sqlite+aiosqlite:///{TEST_DB}", connect_args={"check_same_thread": False}
)
test_session_factory = async_sessionmaker(test_engine, class_=AsyncSession, expire_on_commit=False)


async def reset_database() -> None:
    async with test_engine.begin() as connection:
        await connection.run_sync(Base.metadata.drop_all)
        await connection.run_sync(Base.metadata.create_all)


async def override_get_db() -> AsyncGenerator[AsyncSession, None]:
    async with test_session_factory() as session:
        yield session


@pytest.fixture(autouse=True)
def clean_database() -> Generator[None, None, None]:
    get_settings.cache_clear()
    asyncio.run(reset_database())
    app.dependency_overrides[get_db] = override_get_db
    yield
    app.dependency_overrides.clear()


@pytest.fixture
def client() -> Generator[TestClient, None, None]:
    with TestClient(app) as test_client:
        yield test_client


def pytest_sessionfinish(session: pytest.Session, exitstatus: int) -> None:
    asyncio.run(test_engine.dispose())
    if TEST_DB.exists():
        TEST_DB.unlink()
