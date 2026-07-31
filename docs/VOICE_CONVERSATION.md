# Phase 5 voice conversation

Phase 5 adds a turn-based voice conversation foundation. The user records one short Android M4A/AAC turn, stops recording, reviews or edits the recognised transcript, and explicitly sends that text through the existing secure text tutor. Tutor replies remain structured text and can optionally be synthesised into temporary tutor audio.

This is not full duplex, streaming, pronunciation scoring, phoneme analysis, accent scoring, or fluency certification. The UI remains English-only; Malayalam is retained as optional tutor explanation content.

The state machine is idle → permission → ready → recording → stopping → recorded → validating → uploading → transcribing → transcriptReady → sendingToTutor → completed, with failed and cancelled paths. Android uses `record` for AAC recording, `just_audio` for playback, and `permission_handler` for microphone permission. The initial format is mono AAC-LC in an M4A container, 16 kHz, 64 kbps, with a 60-second and 5 MB upload maximum.

Voice requires a real authenticated backend account. Local users see sign-in-required state and retain text tutor fallback. Offline mode does not queue raw audio.
