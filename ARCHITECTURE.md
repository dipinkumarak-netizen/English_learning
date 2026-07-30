# Architecture

## Mobile

The Flutter app uses a small feature-first structure. `app/` owns bootstrap, routing, and app-wide providers. `core/` owns configuration, errors, logging, networking, theme, and reusable widgets. Feature UI lives under `features/`. ARB files under `lib/l10n/` are the source of truth for English and Malayalam UI text.

Riverpod provides dependency injection and state foundations. GoRouter owns navigation. Widgets do not construct or depend directly on HTTP details; repositories and providers will be introduced with the first data feature.

## Backend

FastAPI exposes versioned API routes and a stable health schema. Pydantic Settings reads environment configuration. SQLAlchemy 2 async and Alembic provide the database foundation. PostgreSQL is the development database; Redis is intentionally deferred.

## Data flow and future providers

Flutter → API client → versioned FastAPI route → domain/repository layer → database or provider adapter. Future LLM, translation, STT, TTS, and pronunciation integrations will be behind backend interfaces. API keys remain server-side so mobile binaries cannot expose them.

## Offline direction

Later phases will add a local Drift store for content and pending progress mutations. Sync will be explicit, idempotent, conflict-aware, and observable. Phase 1 does not persist learner data.

## Testing

Flutter formatting, analysis, unit/widget tests, and Android build run in CI. Backend linting and API tests run with Python. Provider calls will use mocks and contract fixtures rather than live paid services.
