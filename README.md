# NilaSpeak

NilaSpeak is an original Malayalam-first spoken-English learning application for private, personal use. It will not be commercially released or published on Google Play.

## Current scope

Phase 1 foundation and Phase 2 are implemented: Flutter Android/Web setup with an English-only interface, Malayalam learning-support content, Material 3, Riverpod, GoRouter, FastAPI, PostgreSQL/Alembic foundation, local email/password authentication, secure token lifecycle, learner profile, resumable onboarding, text placement assessment, and deterministic learning-plan generation.

AI, voice, pronunciation, complete courses, vocabulary, payments, subscriptions, commercial analytics, admin, and social features are intentionally out of scope.

## Repository structure

- `mobile/` — Flutter application.
- `backend/` — FastAPI application, models, API routes, and Alembic migrations.
- `docs/` — development, architecture, security, and roadmap documentation.
- `.github/workflows/` — CI foundation.

## Setup

Flutter stable is required for Android/Web development. Python 3.14 currently validates the backend. Docker Desktop is optional for the PostgreSQL Compose stack and is not installed on the current machine. Copy `.env.example` to `.env`, then follow [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md).

`ALLOW_REGISTRATION=false` disables new account creation on the backend while existing login continues to work. Use a long random `JWT_SECRET` outside local development.

## Known limitations

The current machine has no Docker, so Compose build/runtime checks remain unverified. Local HTTP is for development only; any remote deployment requires HTTPS.
