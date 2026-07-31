# Audio retention and deletion

Learner recordings are written outside the source tree under `VOICE_AUDIO_STORAGE_PATH` using random server keys. They are temporary and expire after `VOICE_TEMP_AUDIO_RETENTION_MINUTES` (30 minutes by default). Tutor WAV output uses the same policy. Production deployments should schedule the cleanup operation.

Deleting a tutor conversation cascades voice sessions, turns, and audio assets. Usage records are content-free accounting. Flutter stores only session/turn metadata in Drift and keeps downloaded tutor audio in app-private temporary storage, never in Drift blobs.
