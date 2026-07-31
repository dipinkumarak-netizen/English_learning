# Security foundation

Voice uses explicit first-recording consent, authenticated ownership checks, MIME/extension/magic-byte/size/duration validation, random storage keys, short retention, cleanup, and cascade deletion. Raw learner audio is temporary and is not retained by default.

- Never commit `.env`, passwords, tokens, provider keys, or signing keys.
- Passwords are Argon2-hashed and never returned or logged.
- Access tokens are short-lived JWTs. Refresh tokens are opaque, stored only as SHA-256 hashes, rotated on refresh, expired, and revoked on logout.
- Mobile tokens use `flutter_secure_storage`; they are not stored in SharedPreferences, Drift, logs, or debug UI.
- `ALLOW_REGISTRATION` is enforced by the backend, not just Flutter.
- Login errors are generic. Email is validated and password strength requires letters and numbers with a minimum length.
- All private profile, onboarding, placement, and plan resources are filtered by authenticated user ownership.
- Local HTTP is acceptable only for development. HTTPS is required for remote use.
- Future AI endpoints require quotas for technical cost safety, request limits, input validation, prompt-injection resistance, provider timeouts, and safe logging. These are not paid-plan restrictions.
- Course answer keys are not included in online lesson responses. The backend scores online attempts deterministically. Offline cached content may contain validated scoring data for immediate feedback; synced attempts are revalidated by the backend.
- Progress APIs enforce user ownership, published-content visibility, stable client operation IDs, duplicate protection, and server-side completion rules. Server-completed progress cannot be downgraded by stale local data.
- Tutor conversations, messages, corrections, mistakes, summaries, and usage records are ownership-scoped. Conversation deletion is hard deletion with cascading related records. Provider keys remain backend-only environment values.
- AI output is untrusted text: structured schemas validate it, safety redirects run before generation, prompt-injection requests are refused, and Flutter never executes model output.
- Audio will later require consent, MIME/size/duration limits, short retention, and deletion. Raw voice will not be retained by default.
- Subscription, payment, billing, entitlement, trial, and promotional-access systems are permanently removed from the private-use scope.
- Application UI language is English-only. Malayalam learning explanations are domain content and are not loaded through the application-locale system.
Local learner IDs are random persisted UUIDs, not backend identities or authentication tokens. Local mode has no authentication bypass and no fake JWT. The local-import endpoint requires a real authenticated user, validates curriculum references, and recalculates exercise scores server-side. Account deletion and local-data reset are separate actions; logout clears secure tokens while preserving local learning data.
