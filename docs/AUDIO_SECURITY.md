# Audio security

Voice endpoints require bearer authentication and scope every session, turn, and audio asset to its owner. Flutter never receives provider keys or server filesystem paths. Uploads require allowed audio MIME type and extension, M4A/MP4 `ftyp` magic bytes, non-zero content, size limit, and declared duration within the configured range. Filenames are never used as storage paths; server-generated random keys stay below the configured audio root.

Learner recordings and tutor audio are temporary assets with expiry timestamps. Cleanup removes expired records and files. Conversation deletion cascades through voice sessions, turns, and assets. Usage records contain operation metadata and provider usage but no full transcript text. No pronunciation or confidence claim is generated from STT output.
