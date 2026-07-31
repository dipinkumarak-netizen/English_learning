# Phase 3 offline cache and sync

Drift stores cached course metadata, modules, lessons, lesson steps, exercise definitions, local lesson progress, pending operations, and cache metadata. Access and refresh tokens remain exclusively in secure storage.

The mobile queue supports `start_lesson`, `complete_step`, `submit_exercise`, and `complete_lesson`. Each operation has a client operation ID. The backend records that ID per user and treats a repeated synced ID as already processed, so retries do not create duplicate attempts or completions.

Conflict rules are intentionally small:

- server-completed steps and lessons remain completed;
- a valid higher exercise score is retained when retry policy allows it;
- attempt counts never decrease;
- later valid activity may advance the resume position;
- stale local completion cannot downgrade server state.

Online API responses are authoritative after successful sync. While offline, the local cache preserves incomplete lesson state and displays local-only/syncing/failed states through the queue model. Cached answer data is a deliberate Phase 3 trade-off for immediate offline feedback; every synced attempt is scored again by the backend.

Audio is not cached because audio lessons are outside Phase 3.
