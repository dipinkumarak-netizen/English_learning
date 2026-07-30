# NilaSpeak

NilaSpeak is an original Malayalam-first spoken-English learning product. This repository currently contains only the Phase 1 technical foundation.

## Phase 1 scope

The foundation includes a Flutter Android/Web app, English and Malayalam localisation, Material 3 themes, Riverpod and GoRouter setup, a FastAPI health API, PostgreSQL Compose configuration, structured logging, environment examples, CI, documentation, and baseline tests.

Authentication, lessons, AI, voice, pronunciation, payments, and user data features are intentionally not implemented yet.

## Repository structure

- `mobile/` — Flutter application.
- `backend/` — FastAPI application and Alembic foundation.
- `docs/` — development, architecture, security, and roadmap documentation.
- `.github/workflows/` — CI foundation.

## Prerequisites

Flutter stable is required for the mobile app. Python 3.12+ is required for the backend. Docker Desktop is required for the PostgreSQL development stack. Windows desktop is not a required target; Android is the primary target and Web is useful for quick UI checks.

## Setup

Copy `.env.example` to `.env` for Compose, then follow [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md). Run Flutter checks from `mobile/`. Run backend checks from `backend/`.

## Known limitations

The current development machine has Flutter but does not have Python, Docker, or Visual Studio. Backend tests and Docker validation must be run in an environment with those tools installed.
