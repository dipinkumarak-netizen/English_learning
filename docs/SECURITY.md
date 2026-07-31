# Security foundation

- Never commit `.env`, passwords, tokens, provider keys, or signing keys.
- Passwords are Argon2-hashed and never returned or logged.
- Access tokens are short-lived JWTs. Refresh tokens are opaque, stored only as SHA-256 hashes, rotated on refresh, expired, and revoked on logout.
- Mobile tokens use `flutter_secure_storage`; they are not stored in SharedPreferences, Drift, logs, or debug UI.
- `ALLOW_REGISTRATION` is enforced by the backend, not just Flutter.
- Login errors are generic. Email is validated and password strength requires letters and numbers with a minimum length.
- All private profile, onboarding, placement, and plan resources are filtered by authenticated user ownership.
- Local HTTP is acceptable only for development. HTTPS is required for remote use.
- Future AI endpoints require quotas for technical cost safety, request limits, input validation, prompt-injection resistance, provider timeouts, and safe logging. These are not paid-plan restrictions.
- Audio will later require consent, MIME/size/duration limits, short retention, and deletion. Raw voice will not be retained by default.
- Subscription, payment, billing, entitlement, trial, and promotional-access systems are permanently removed from the private-use scope.
- Application UI language is English-only. Malayalam learning explanations are domain content and are not loaded through the application-locale system.
