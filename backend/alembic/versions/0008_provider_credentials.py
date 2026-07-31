"""Add encrypted per-user provider credentials and audit events."""

from collections.abc import Sequence

import sqlalchemy as sa

from alembic import op

revision: str = "0008_provider_credentials"
down_revision: str | None = "0007_voice_session_timestamp_fix"
branch_labels: Sequence[str] | None = None
depends_on: Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "provider_credentials",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column("capability", sa.String(10), nullable=False),
        sa.Column("provider", sa.String(40), nullable=False, server_default="none"),
        sa.Column("encrypted_api_key", sa.Text(), nullable=True),
        sa.Column("key_last4", sa.String(4), nullable=True),
        sa.Column("model", sa.String(160), nullable=True),
        sa.Column("base_url", sa.String(240), nullable=True),
        sa.Column("voice", sa.String(40), nullable=True),
        sa.Column("enabled", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("last_test_status", sa.String(20), nullable=True),
        sa.Column("last_tested_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("user_id", "capability"),
    )
    op.create_index("ix_provider_credentials_user_id", "provider_credentials", ["user_id"])
    op.create_table(
        "provider_credential_audits",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column("capability", sa.String(10), nullable=False),
        sa.Column("action", sa.String(30), nullable=False),
        sa.Column("outcome", sa.String(20), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index(
        "ix_provider_credential_audits_user_id", "provider_credential_audits", ["user_id"]
    )


def downgrade() -> None:
    op.drop_index("ix_provider_credential_audits_user_id", table_name="provider_credential_audits")
    op.drop_table("provider_credential_audits")
    op.drop_index("ix_provider_credentials_user_id", table_name="provider_credentials")
    op.drop_table("provider_credentials")
