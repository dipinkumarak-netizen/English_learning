# Phase 5 voice provider configuration

Provider keys stay in the backend runtime environment and are never sent to Flutter.

Disabled:

```env
STT_PROVIDER=none
STT_ENABLED=false
TTS_PROVIDER=none
TTS_ENABLED=false
```

Deterministic local/CI mocks:

```env
STT_PROVIDER=mock
STT_ENABLED=true
TTS_PROVIDER=mock
TTS_ENABLED=true
```

OpenAI-compatible providers:

```env
STT_PROVIDER=openai
STT_ENABLED=true
STT_MODEL=<transcription-model>
STT_API_KEY=<server-only-key>
STT_BASE_URL=https://api.openai.com/v1
TTS_PROVIDER=openai
TTS_ENABLED=true
TTS_MODEL=<speech-model>
TTS_VOICE=alloy
TTS_API_KEY=<server-only-key>
TTS_BASE_URL=https://api.openai.com/v1
```

`STT_API_KEY` and `TTS_API_KEY` fall back to `AI_API_KEY` when provider-specific keys are empty. Never commit any real key or `.env` file.
