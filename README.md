# NilaSpeak

NilaSpeak is an original Malayalam-first spoken-English learning application for private, personal use. It will not be commercially released or published on Google Play.

## Current scope

Phase 1 through Phase 4.5 are implemented within the validated scope: an English-only Flutter interface with Malayalam learning support, optional account connection, local-first onboarding and learning, original data-driven beginner courses, deterministic exercises, lesson progress, Drift offline caching, and a secure text-only AI tutor with structured corrections and a mistake notebook.

Live provider content is optional and disabled by default. Voice, speech-to-text, text-to-speech, pronunciation scoring, adaptive recommendations, payments, subscriptions, commercial analytics, admin, and social features are intentionally out of scope.

## Repository structure

- `mobile/` — Flutter application.
- `backend/` — FastAPI application, models, API routes, and Alembic migrations.
- `docs/` — development, architecture, security, and roadmap documentation.
- `.github/workflows/` — CI foundation.

## Setup

Flutter stable is required for Android/Web development. Python 3.14 currently validates the backend. Docker Desktop is optional for the PostgreSQL Compose stack. Copy `.env.example` to `.env`, then follow [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md).

`ALLOW_REGISTRATION=false` disables new account creation on the backend while existing login continues to work. Use a long random `JWT_SECRET` outside local development.

## Known limitations

Local HTTP is for development only; any remote deployment requires HTTPS. Real external AI provider integration remains a future adapter; the secure mock/disabled boundary is the validated Phase 4 behavior.
