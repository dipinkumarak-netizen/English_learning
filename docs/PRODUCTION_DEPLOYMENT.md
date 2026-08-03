# NilaSpeak production deployment

This guide targets Ubuntu Server 24.04 at `/storage/appdata/nilaspeak/source`.
Keep `.env` outside Git and preserve the named PostgreSQL and audio volumes.

## First installation

```bash
cd /storage/appdata/nilaspeak/source
git clone https://github.com/dipinkumarak-netizen/English_learning.git .
cp .env.example .env
chmod 600 .env
openssl rand -base64 32   # POSTGRES_PASSWORD
openssl rand -base64 48   # JWT_SECRET
python3 -c 'import base64,secrets; print(base64.urlsafe_b64encode(secrets.token_bytes(32)).decode())'  # CREDENTIAL_ENCRYPTION_KEY
```

Set `APP_ENV=production`, explicit `ALLOW_REGISTRATION=true|false`, and the
generated values in `.env`. `DATABASE_URL` must contain the same URL-encoded
password as `POSTGRES_PASSWORD` and target `db`:
`postgresql+asyncpg://nilaspeak:<url-encoded-password>@db:5432/nilaspeak`.
The encryption key is URL-safe base64 of exactly 32 random bytes.
`CREDENTIAL_ENCRYPTION_PREVIOUS_KEY` is optional for key rotation.

Do not use `change-me-local`, placeholder JWT values, or blank production
values. Production startup fails with safe categories when mandatory values
are missing or invalid.

```bash
docker compose config --quiet
docker compose up -d --build
docker compose exec -T backend alembic upgrade head
docker compose exec -T backend python -m app.seed
curl http://192.168.1.50:8000/health
curl -i http://192.168.1.50:8000/ready
```

Create the first account while registration is enabled. Then set
`ALLOW_REGISTRATION=false` and recreate only the backend:

```bash
docker compose up -d --no-deps --force-recreate backend
```

## Password and volume safety

PostgreSQL applies `POSTGRES_PASSWORD` only during first initialization.
Changing `.env` later does not change the existing `nilaspeak` role password.
Never delete `postgres_data` during a normal update.

For rotation, back up first, run `ALTER ROLE nilaspeak WITH PASSWORD 'new-value'`
as an administrative role, update both `POSTGRES_PASSWORD` and the URL-encoded
`DATABASE_URL`, recreate only the backend, and verify health/readiness. For a
clean install only, after a verified backup and explicit approval, stop the
stack and remove the named database volume. This is destructive and is never a
normal update procedure.

The non-destructive consistency check reports categories only:

```bash
docker compose run --rm backend python -m app.core.deployment_check
```

## Android builds and testing

```bash
cd mobile
flutter build apk --debug --dart-define=APP_ENV=production --dart-define=API_BASE_URL=http://192.168.1.50:8000
flutter build apk --release --dart-define=APP_ENV=production --dart-define=API_BASE_URL=http://192.168.1.50:8000
adb -s 7DJZRWS4SKBY5DEA install -r build/app/outputs/flutter-apk/app-release.apk
```

On device, open Settings, verify the displayed backend host, test connection,
log in, verify profile, confirm local progress remains after logout, test one
access-token refresh, and verify mock/real/disabled voice status. Backend logs
must contain only sanitized request diagnostics and no credentials or tokens.
For Tailscale use an HTTPS URL in `API_BASE_URL`; no address is hardcoded.

## Updates and rollback

1. Back up PostgreSQL.
2. Run `git fetch origin`, inspect incoming commits, then `git pull --ff-only`.
3. Run `docker compose config --quiet` and `docker compose build`.
4. Apply `docker compose exec -T backend alembic upgrade head`.
5. Recreate services and verify `/health` and `/ready`.

If verification fails, revert the application commit and recreate the backend
according to a tested rollback plan. Do not downgrade migrations or delete
volumes during a normal update.

## Troubleshooting

- Password authentication failed: the existing role password differs from
  `DATABASE_URL`; rotate the role safely and update both values.
- Password mismatch: run `app.core.deployment_check` and URL-encode special
  characters in the URL password.
- Missing registration setting: set `ALLOW_REGISTRATION` explicitly and
  recreate the backend.
- Mobile login does not reach backend: check compiled `API_BASE_URL`, LAN
  routing, `/health`, and Android cleartext policy.
- Stale URL: release rejects localhost, `10.0.2.2`, and old `192.168.1.4`.
- Cleartext blocked: use HTTPS or private LAN address `192.168.1.50`.
- 401 refresh loop: the client retries once, clears invalid tokens, and keeps
  local mode; inspect sanitized diagnostics only.
- Registration disabled: existing users can log in; enable it only to create
  the first account, then disable it again.
- Migration not applied: run `alembic upgrade head` inside the backend.
- Provider encryption key missing: set the exact URL-safe base64 32-byte key;
  never replace it casually because stored credentials depend on it.
- Mock unexpectedly active: inspect provider settings and environment values;
  mock is intentional and visibly labelled in the app.
