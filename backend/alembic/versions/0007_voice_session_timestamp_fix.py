"""Add the timestamp column required by the voice session model."""

from collections.abc import Sequence

import sqlalchemy as sa

from alembic import op

revision: str = "0007_voice_session_timestamp_fix"
down_revision: str | None = "0006_phase5_voice_conversation"
branch_labels: Sequence[str] | None = None
depends_on: Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "voice_conversation_sessions",
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
    )


def downgrade() -> None:
    op.drop_column("voice_conversation_sessions", "updated_at")
