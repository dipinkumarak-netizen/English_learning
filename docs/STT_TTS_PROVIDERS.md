# STT and TTS providers

Speech-to-text and text-to-speech are separate backend protocols. `STT_PROVIDER=none` and `TTS_PROVIDER=none` are safe defaults, so the backend starts and text tutor functionality remains available when voice providers are disabled. `mock` enables deterministic development fixtures without paid services.

Mock STT fixtures include `english_success`, `mixed_ml_en`, `unclear`, `empty_audio`, `timeout`, `unavailable`, and `invalid_audio`. Mock TTS returns a deterministic one-second WAV for valid tutor text and has timeout/failure fixtures. Real adapters can be added behind the same interfaces only with explicit credentials and endpoints.

Provider configuration is backend-only. The existing secure text tutor remains the single tutor-generation pipeline; voice supplies a reviewed final text message and links the resulting tutor message to the voice turn.
