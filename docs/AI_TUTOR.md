# Phase 4 AI tutor

Phase 4 adds a secure, text-only tutor. Flutter calls versioned backend tutor endpoints; it never calls an external AI provider. The backend chooses a provider through `AI_PROVIDER`, validates structured responses, records safe usage metadata, and returns a clear unavailable response when AI is disabled.

Supported modes include free conversation, beginner conversation, grammar correction, sentence improvement, Malayalam-to-English practice, English explanation, guided lesson support, role-play foundation, vocabulary practice, and writing correction. Voice, microphone, audio, pronunciation, and speech services are outside Phase 4.

The deterministic mock provider is enabled only with `AI_PROVIDER_ENABLED=true` and `AI_PROVIDER=mock`. A real provider adapter belongs behind `TextGenerationProvider`; keys belong only in backend environment variables. The default configuration is disabled and does not block backend startup.

Conversations are private and hard-deleted with their messages, corrections, and summaries. Message submission uses client operation IDs to prevent duplicate learner messages and duplicate provider requests.
