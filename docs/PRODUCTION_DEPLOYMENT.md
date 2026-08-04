# NilaSpeak production deployment

## Phase 7 HTTPS architecture

The backend container remains plain HTTP on port 8000 and PostgreSQL is never
published. For production, terminate TLS at a trusted reverse proxy or at a
Tailscale HTTPS endpoint and forward only to the backend network. Direct
production HTTP remains useful for `/health` and `/ready`, but provider
credential mutations are rejected.

Supported modes:

1. Reverse proxy (recommended): point `api.example.invalid` at Nginx Proxy
   Manager, Caddy, or Nginx and proxy to `http://127.0.0.1:8000`.
2. Tailscale HTTPS: use a private tailnet DNS name and `tailscale serve` to
   proxy HTTPS to `http://127.0.0.1:8000`.
3. Development-only LAN HTTP: set `APP_ENV=development` and use the private
   LAN URL. Never use this mode for remote access or provider credentials.

For a reverse proxy on the same host, set these values in the untracked `.env`:

```dotenv
APP_ENV=production
TRUST_PROXY_HEADERS=true
TRUSTED_PROXY_NETWORKS=127.0.0.1/32,172.16.0.0/12
PUBLIC_BASE_URL=https://api.example.invalid
```

Use the actual proxy container or host network only; do not copy these example
networks without checking the immediate proxy source address. The application
accepts `X-Forwarded-Proto` and `X-Forwarded-Host` only when the immediate
client IP belongs to `TRUSTED_PROXY_NETWORKS`. Direct clients cannot spoof TLS.

### Nginx Proxy Manager

Create a Proxy Host for a real private DNS name, request a certificate through
your trusted certificate provider, and forward to the backend host on port
8000. Enable WebSocket support, set the scheme to `http`, and pass the standard
`X-Forwarded-Proto` and `X-Forwarded-Host` headers. Do not put API keys or
certificate private keys in this repository.

### Plain Nginx or Caddy

Example Nginx shape (replace placeholders and keep certificates outside Git):

```nginx
server {
    listen 443 ssl;
    server_name api.example.invalid;
    ssl_certificate /etc/letsencrypt/live/api.example.invalid/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.example.invalid/privkey.pem;
    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_pass http://127.0.0.1:8000;
    }
}
```

With Caddy, `reverse_proxy 127.0.0.1:8000` provides the equivalent TLS
termination and forwarded headers. Validate the proxy source IP before setting
`TRUSTED_PROXY_NETWORKS`.

### Tailscale HTTPS

On the server, authenticate it to the private tailnet, confirm its MagicDNS
name, then run `tailscale serve --https=443 http://127.0.0.1:8000`. Use the
resulting HTTPS tailnet URL in the APK build. Keep the service tailnet-private;
do not expose it with funnel unless that exposure is explicitly intended.
Certificate issuance and renewal are managed by Tailscale. If the hostname is
unavailable, verify tailnet login, MagicDNS, ACLs, and that HTTPS serving is
enabled. Do not disable Android or server certificate verification.

Certificate renewal must be tested before expiry. Firewall rules should expose
only the chosen HTTPS endpoint to the intended private network; keep port 5432
closed and do not publish PostgreSQL.

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

For production HTTPS, use the real trusted endpoint instead:

```bash
flutter build apk --release --dart-define=APP_ENV=production --dart-define=API_BASE_URL=https://api.example.invalid
```

After login, Settings displays transport status. On HTTPS, configure AI,
STT, and TTS independently, save the credential, test each capability, and
confirm only masked metadata is shown. On production LAN HTTP, provider
Save/Test/Delete controls remain disabled with: “Provider credentials require
an HTTPS backend connection.” Login, lessons, and sync may continue over an
explicit private-development HTTP build.

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

- Secure HTTPS transport is required: use an HTTPS mobile URL or configure a
  trusted proxy; do not bypass the check.
- Forwarded proto not recognized: verify the proxy sends `X-Forwarded-Proto:
  https` and the immediate proxy IP is in `TRUSTED_PROXY_NETWORKS`.
- Proxy headers not trusted: do not add arbitrary client networks; correct the
  proxy network and recreate only the backend.
- Certificate hostname mismatch: build with the exact certificate hostname.
- Android certificate trust failure: install/use a certificate trusted by
  Android; never disable TLS verification.
- Backend reachable but provider controls disabled: the endpoint is HTTP in
  production or capability discovery is unavailable.
- STT returns 503: STT is disabled, missing a credential, or the provider is
  unavailable; inspect safe capability status.
- Mock provider unexpectedly active: inspect the capability card and backend
  environment; mock output is labelled as development-only.
- Provider base URL rejected: use an HTTPS allow-listed URL; private URLs are
  development-only when explicitly enabled.
- Tailscale hostname unavailable: check MagicDNS, ACLs, device login, and
  `tailscale serve` status.

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
