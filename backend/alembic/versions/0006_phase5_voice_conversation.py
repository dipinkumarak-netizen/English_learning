"""Add Phase 5 turn-based voice conversation storage."""

from collections.abc import Sequence

import sqlalchemy as sa

from alembic import op

revision: str = "0006_phase5_voice_conversation"
down_revision: str | None = "0005_daily_learning_sequence"
branch_labels: Sequence[str] | None = None
depends_on: Sequence[str] | None = None


def _id() -> sa.Column:
    return sa.Column("id", sa.String(36), primary_key=True)


def _created() -> sa.Column:
    return sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now())


def upgrade() -> None:
    op.create_table(
        "voice_conversation_sessions",
        _id(),
        sa.Column("user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("conversation_id", sa.String(36), sa.ForeignKey("tutor_conversations.id", ondelete="CASCADE"), nullable=False),
        sa.Column("tutor_mode", sa.String(40), nullable=False),
        sa.Column("status", sa.String(20), nullable=False, server_default="active"),
        sa.Column("language", sa.String(10), nullable=False, server_default="en"),
        sa.Column("explanation_language", sa.String(10), nullable=False, server_default="en"),
        sa.Column("recording_mode", sa.String(20), nullable=False, server_default="tap"),
        sa.Column("auto_play", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("playback_speed", sa.Float(), nullable=False, server_default="1.0"),
        sa.Column("started_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("completed_at", sa.DateTime(timezone=True)),
        sa.Column("total_learner_audio_seconds", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("total_tutor_audio_seconds", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("total_voice_turns", sa.Integer(), nullable=False, server_default="0"),
        _created(),
    )
    op.create_index("ix_voice_conversation_sessions_user_id", "voice_conversation_sessions", ["user_id"])
    op.create_index("ix_voice_conversation_sessions_status", "voice_conversation_sessions", ["status"])
    op.create_index("ix_voice_conversation_sessions_conversation_id", "voice_conversation_sessions", ["conversation_id"])
    op.create_table(
        "voice_turns",
        _id(),
        sa.Column("user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("session_id", sa.String(36), sa.ForeignKey("voice_conversation_sessions.id", ondelete="CASCADE"), nullable=False),
        sa.Column("conversation_id", sa.String(36), sa.ForeignKey("tutor_conversations.id", ondelete="CASCADE"), nullable=False),
        sa.Column("turn_number", sa.Integer(), nullable=False),
        sa.Column("client_operation_id", sa.String(80), nullable=False),
        sa.Column("learner_audio_id", sa.String(36)),
        sa.Column("recording_duration_seconds", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("transcription_status", sa.String(24), nullable=False, server_default="pending"),
        sa.Column("transcript", sa.Text()),
        sa.Column("edited_transcript", sa.Text()),
        sa.Column("detected_language", sa.String(20)),
        sa.Column("stt_provider", sa.String(40)),
        sa.Column("stt_model", sa.String(100)),
        sa.Column("stt_operation_id", sa.String(80), unique=True),
        sa.Column("tutor_message_id", sa.String(36)),
        sa.Column("tutor_audio_id", sa.String(36)),
        sa.Column("synthesis_status", sa.String(24), nullable=False, server_default="not_requested"),
        sa.Column("synthesis_operation_id", sa.String(80), unique=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("completed_at", sa.DateTime(timezone=True)),
        sa.Column("failure_category", sa.String(40)),
        sa.UniqueConstraint("session_id", "client_operation_id"),
        sa.UniqueConstraint("session_id", "turn_number"),
    )
    for name, columns in (
        ("ix_voice_turns_user_id", ["user_id"]),
        ("ix_voice_turns_session_id", ["session_id"]),
        ("ix_voice_turns_conversation_id", ["conversation_id"]),
        ("ix_voice_turns_tutor_message_id", ["tutor_message_id"]),
    ):
        op.create_index(name, "voice_turns", columns)
    op.create_table(
        "voice_audio_assets",
        _id(),
        sa.Column("user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("session_id", sa.String(36), sa.ForeignKey("voice_conversation_sessions.id", ondelete="CASCADE"), nullable=False),
        sa.Column("turn_id", sa.String(36), sa.ForeignKey("voice_turns.id", ondelete="CASCADE"), nullable=False),
        sa.Column("asset_type", sa.String(20), nullable=False),
        sa.Column("storage_key", sa.String(240), unique=True, nullable=False),
        sa.Column("mime_type", sa.String(80), nullable=False),
        sa.Column("byte_size", sa.Integer(), nullable=False),
        sa.Column("duration_seconds", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("provider", sa.String(40)),
        sa.Column("model", sa.String(100)),
        sa.Column("status", sa.String(24), nullable=False, server_default="temporary"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
    )
    for name, columns in (("ix_voice_audio_assets_user_id", ["user_id"]), ("ix_voice_audio_assets_session_id", ["session_id"]), ("ix_voice_audio_assets_turn_id", ["turn_id"]), ("ix_voice_audio_assets_expires_at", ["expires_at"])):
        op.create_index(name, "voice_audio_assets", columns)
    op.create_table(
        "voice_preferences",
        _id(),
        sa.Column("user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False),
        sa.Column("voice", sa.String(40), nullable=False, server_default="default"),
        sa.Column("auto_play", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("playback_speed", sa.Float(), nullable=False, server_default="1.0"),
        sa.Column("transcript_visible", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.Column("recording_mode", sa.String(20), nullable=False, server_default="tap"),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_table(
        "voice_usage_records",
        _id(),
        sa.Column("user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("session_id", sa.String(36), sa.ForeignKey("voice_conversation_sessions.id", ondelete="SET NULL")),
        sa.Column("turn_id", sa.String(36), sa.ForeignKey("voice_turns.id", ondelete="SET NULL")),
        sa.Column("provider", sa.String(40), nullable=False),
        sa.Column("model", sa.String(100), nullable=False),
        sa.Column("operation", sa.String(30), nullable=False),
        sa.Column("audio_duration_seconds", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("synthesis_characters", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("request_status", sa.String(30), nullable=False),
        sa.Column("latency_ms", sa.Integer()),
        sa.Column("provider_usage", sa.JSON(), nullable=False),
        sa.Column("failure_category", sa.String(40)),
        _created(),
    )
    for name, columns in (("ix_voice_usage_records_user_id", ["user_id"]), ("ix_voice_usage_records_session_id", ["session_id"]), ("ix_voice_usage_records_turn_id", ["turn_id"])):
        op.create_index(name, "voice_usage_records", columns)


def downgrade() -> None:
    op.drop_table("voice_usage_records")
    op.drop_table("voice_preferences")
    for name in ("ix_voice_audio_assets_expires_at", "ix_voice_audio_assets_turn_id", "ix_voice_audio_assets_session_id", "ix_voice_audio_assets_user_id"):
        op.drop_index(name, table_name="voice_audio_assets")
    op.drop_table("voice_audio_assets")
    for name in ("ix_voice_turns_tutor_message_id", "ix_voice_turns_conversation_id", "ix_voice_turns_session_id", "ix_voice_turns_user_id"):
        op.drop_index(name, table_name="voice_turns")
    op.drop_table("voice_turns")
    for name in ("ix_voice_conversation_sessions_conversation_id", "ix_voice_conversation_sessions_status", "ix_voice_conversation_sessions_user_id"):
        op.drop_index(name, table_name="voice_conversation_sessions")
    op.drop_table("voice_conversation_sessions")
