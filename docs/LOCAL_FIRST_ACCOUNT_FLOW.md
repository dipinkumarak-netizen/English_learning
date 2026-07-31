# Local-first account flow

NilaSpeak opens into a local learner profile. Startup creates one random UUID once and stores the structured profile in Drift. It is not a device identifier, email address, token, or backend user ID. The profile survives restarts and is removed only by the explicit local-data reset action.

## Startup and capabilities

The flow is: `App launch → local profile bootstrap → local onboarding if incomplete → Home → Settings`.

Courses, the starter lesson, placement, the learning plan, local lesson progress, offline cache, profile preferences, and local mistake review are available without login. A local session is never represented as an authenticated backend session and no fake JWT is generated.

Settings exposes Sign in and Create account. Connected accounts show display name, email, sync status, Sync now, Log out, and Delete account. The interface stays English-only; Malayalam is learner explanation content.

## Server capabilities

Authentication is required for AI tutor requests, server tutor history, server mistake notebook, cross-device progress sync, backup, import, export, and account deletion. AI provider keys remain backend-only. Local users see a clear sign-in prompt when opening AI Tutor.

## Local import and merge

After sign-in, local data can be merged, account progress can be used, or migration can be cancelled. `POST /api/v1/sync/local-import` requires authentication, validates ownership and curriculum references, recalculates exercise scores, and accepts a stable import operation ID.

Merge rules preserve completed lessons and steps, retain the highest valid score, never decrease attempt counts, and avoid downgrading server state. The server account identity remains authoritative. Empty server learner preferences may be filled from local profile data; server-side plan recalculation remains authoritative.

## Logout, deletion, and reset

Logout revokes the refresh session, clears secure tokens, disconnects the account, and preserves local courses and progress. Server-only tutor history may not be available afterward. Account deletion is a separate backend action and retains local data. Reset local learning data is explicit and separately confirmed; it clears local profile, local progress, pending sync, and tutor cache without deleting the backend account.

## Known limitations

The first local curriculum is a bundled starter fallback; full published curriculum delivery remains server-backed. Real external AI provider integration and voice work are future phases.
