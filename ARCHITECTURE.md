# Architecture

## Mobile

Flutter uses a feature-first structure. `app/` owns bootstrap, routing, and app-wide providers. `core/` owns configuration, errors, logging, networking, theme, and reusable widgets. Phase 2 features live under authentication, onboarding, placement_test, learner_profile, and learning_plan. The interface locale is English-only; Malayalam is a learner native/explanation language in domain content, not a Flutter UI locale.

Riverpod provides dependency injection and state. GoRouter owns navigation and auth/onboarding redirects. Widgets do not construct HTTP details directly.

## Backend

FastAPI exposes versioned routes. Pydantic validates request/response schemas. SQLAlchemy 2 async and Alembic provide the PostgreSQL foundation. Phase 2 uses Argon2 password hashes, short-lived JWT access tokens, hashed opaque refresh sessions with rotation/revocation, and ownership-scoped private resources. Redis is deferred.

## Data flow

Flutter → API client → versioned FastAPI route → database/domain service. Future LLM, translation, STT, TTS, and pronunciation providers will be backend adapters. API keys stay on the backend and never enter mobile binaries.

## Local persistence

Secure storage holds access and refresh tokens. SharedPreferences holds only a resumable onboarding draft; no application-language preference is stored. The backend is authoritative for accounts, profiles, placement results, and plans. A future structured local database may support course content and queued mutations.

## Testing

Flutter formatting, analysis, widget tests, and Android builds run in CI. Backend Ruff, mypy, API tests, and migration offline checks run in CI. Paid providers are not used in tests.

## Product scope

NilaSpeak is private personal-use software. Subscription, billing, entitlement, trial, purchase, Play Store publishing, and commercial analytics layers are removed from active scope.
