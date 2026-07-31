# Development guide

## Flutter

```powershell
cd mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000 -d <android-device-id>
```

The Android emulator reaches a host backend through `http://10.0.2.2:8000`. Web uses `http://localhost:8000`.

The application interface is English-only. There is no UI-language switcher. Malayalam remains available as a learner native language and explanation language for educational content.

## Source-control workflow

GitHub is the authoritative backup for validated source code. Every completed phase must be fully validated, committed with a focused message, and pushed to the configured GitHub repository. Never commit secrets or runtime data; `.env` files, credentials, tokens, local databases, uploaded media, build outputs, APKs, and virtual environments remain outside Git. Persistent database and uploaded-media backups are separate operational backups and are not provided by Git source control.

## Backend

```powershell
cd backend
py -3.14 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -e '.[dev]'
ruff format --check .
ruff check .
mypy app
pytest
alembic upgrade head
uvicorn app.main:app --reload
```

## Docker

Copy `.env.example` to `.env`, then run `docker compose config` and `docker compose up --build` from the repository root. PostgreSQL is reachable only inside the Compose network. Docker was unavailable during this implementation, so these commands were not executed here.

## Private-use settings

Set `ALLOW_REGISTRATION=false` after creating the personal account. Use HTTPS and a strong `JWT_SECRET` for any remote deployment. Password recovery email, social login, and phone OTP are intentionally not implemented.
