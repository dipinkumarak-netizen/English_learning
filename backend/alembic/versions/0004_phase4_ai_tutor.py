"""Add Phase 4 text tutor, correction, notebook, summary, and usage tables."""

from collections.abc import Sequence

import sqlalchemy as sa

from alembic import op

revision: str = "0004_phase4_ai_tutor"
down_revision: str | None = "0003_phase3_course_engine"
branch_labels: Sequence[str] | None = None
depends_on: Sequence[str] | None = None


def _id() -> sa.Column:
    return sa.Column("id", sa.String(36), primary_key=True)


def _created() -> sa.Column:
    return sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now())


def upgrade() -> None:
    op.create_table(
        "tutor_conversations",
        _id(),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column("mode", sa.String(40), nullable=False),
        sa.Column("title", sa.String(160), nullable=False),
        sa.Column("learner_level_snapshot", sa.String(10), nullable=False),
        sa.Column("explanation_language_snapshot", sa.String(10), nullable=False),
        sa.Column("correction_mode", sa.String(40), nullable=False),
        sa.Column("status", sa.String(20), nullable=False),
        sa.Column("archived_at", sa.DateTime(timezone=True)),
        _created(),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index("ix_tutor_conversations_user_id", "tutor_conversations", ["user_id"])
    op.create_index("ix_tutor_conversations_status", "tutor_conversations", ["status"])
    op.create_table(
        "tutor_messages",
        _id(),
        sa.Column(
            "conversation_id",
            sa.String(36),
            sa.ForeignKey("tutor_conversations.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("client_operation_id", sa.String(80), unique=True),
        sa.Column("role", sa.String(20), nullable=False),
        sa.Column("original_learner_text", sa.Text()),
        sa.Column("tutor_reply", sa.Text()),
        sa.Column("structured_response", sa.JSON()),
        sa.Column("provider", sa.String(40)),
        sa.Column("model", sa.String(100)),
        sa.Column("input_tokens", sa.Integer()),
        sa.Column("output_tokens", sa.Integer()),
        sa.Column("sequence_number", sa.Integer(), nullable=False),
        sa.Column("error_state", sa.String(40)),
        _created(),
        sa.UniqueConstraint("conversation_id", "sequence_number"),
    )
    op.create_index("ix_tutor_messages_conversation_id", "tutor_messages", ["conversation_id"])
    op.create_table(
        "tutor_session_preferences",
        _id(),
        sa.Column(
            "conversation_id",
            sa.String(36),
            sa.ForeignKey("tutor_conversations.id", ondelete="CASCADE"),
            unique=True,
        ),
        sa.Column("correction_mode", sa.String(40), nullable=False),
        _created(),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_table(
        "tutor_corrections",
        _id(),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "conversation_id",
            sa.String(36),
            sa.ForeignKey("tutor_conversations.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "message_id",
            sa.String(36),
            sa.ForeignKey("tutor_messages.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("original_sentence", sa.Text(), nullable=False),
        sa.Column("corrected_sentence", sa.Text(), nullable=False),
        sa.Column("natural_alternative", sa.Text()),
        sa.Column("mistake_category", sa.String(40), nullable=False),
        sa.Column("explanation_en", sa.Text(), nullable=False),
        sa.Column("explanation_ml", sa.Text()),
        sa.Column("examples", sa.JSON(), nullable=False),
        _created(),
    )
    op.create_index("ix_tutor_corrections_user_id", "tutor_corrections", ["user_id"])
    op.create_index(
        "ix_tutor_corrections_mistake_category", "tutor_corrections", ["mistake_category"]
    )
    op.create_table(
        "mistake_notebook_entries",
        _id(),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "correction_id",
            sa.String(36),
            sa.ForeignKey("tutor_corrections.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("original_sentence", sa.Text(), nullable=False),
        sa.Column("corrected_sentence", sa.Text(), nullable=False),
        sa.Column("natural_alternative", sa.Text()),
        sa.Column("mistake_category", sa.String(40), nullable=False),
        sa.Column("explanation_en", sa.Text(), nullable=False),
        sa.Column("explanation_ml", sa.Text()),
        sa.Column("examples", sa.JSON(), nullable=False),
        sa.Column("first_seen_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("last_seen_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("repeat_count", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("review_status", sa.String(20), nullable=False, server_default="unreviewed"),
        sa.Column("mastered", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("mastered_at", sa.DateTime(timezone=True)),
    )
    op.create_index("ix_mistake_notebook_entries_user_id", "mistake_notebook_entries", ["user_id"])
    op.create_index(
        "ix_mistake_notebook_entries_mistake_category",
        "mistake_notebook_entries",
        ["mistake_category"],
    )
    op.create_table(
        "tutor_session_summaries",
        _id(),
        sa.Column(
            "conversation_id",
            sa.String(36),
            sa.ForeignKey("tutor_conversations.id", ondelete="CASCADE"),
            unique=True,
        ),
        sa.Column("message_count", sa.Integer(), nullable=False),
        sa.Column("learner_message_count", sa.Integer(), nullable=False),
        sa.Column("corrected_sentences", sa.JSON(), nullable=False),
        sa.Column("frequent_mistake_categories", sa.JSON(), nullable=False),
        sa.Column("new_vocabulary", sa.JSON(), nullable=False),
        sa.Column("strengths", sa.JSON(), nullable=False),
        sa.Column("improvement_areas", sa.JSON(), nullable=False),
        sa.Column("suggested_next_practice", sa.Text(), nullable=False),
        sa.Column("session_duration_seconds", sa.Integer(), nullable=False),
        _created(),
    )
    op.create_table(
        "ai_usage_records",
        _id(),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "conversation_id",
            sa.String(36),
            sa.ForeignKey("tutor_conversations.id", ondelete="SET NULL"),
        ),
        sa.Column("provider", sa.String(40), nullable=False),
        sa.Column("model", sa.String(100), nullable=False),
        _created(),
        sa.Column("request_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("input_tokens", sa.Integer(), nullable=False),
        sa.Column("output_tokens", sa.Integer(), nullable=False),
        sa.Column("total_tokens", sa.Integer(), nullable=False),
        sa.Column("request_status", sa.String(30), nullable=False),
        sa.Column("latency_ms", sa.Integer()),
        sa.Column("estimated_cost", sa.Float()),
        sa.Column("failure_category", sa.String(40)),
    )
    op.create_index("ix_ai_usage_records_user_id", "ai_usage_records", ["user_id"])
    op.create_table(
        "prompt_template_versions",
        _id(),
        sa.Column("task", sa.String(50), nullable=False),
        sa.Column("version", sa.Integer(), nullable=False),
        sa.Column("template_text", sa.Text(), nullable=False),
        sa.Column("active", sa.Boolean(), nullable=False, server_default=sa.true()),
        _created(),
        sa.UniqueConstraint("task", "version"),
    )
    op.create_index("ix_prompt_template_versions_task", "prompt_template_versions", ["task"])


def downgrade() -> None:
    op.drop_table("prompt_template_versions")
    op.drop_table("ai_usage_records")
    op.drop_table("tutor_session_summaries")
    op.drop_table("mistake_notebook_entries")
    op.drop_table("tutor_corrections")
    op.drop_table("tutor_session_preferences")
    op.drop_table("tutor_messages")
    op.drop_table("tutor_conversations")
