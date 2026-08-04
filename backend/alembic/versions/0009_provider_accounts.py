"""Add shared provider accounts and capability assignments."""

from collections.abc import Sequence
import sqlalchemy as sa
from alembic import op

revision: str = "0009_provider_accounts"
down_revision: str | None = "0008_provider_credentials"
branch_labels: Sequence[str] | None = None
depends_on: Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "provider_accounts",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("provider", sa.String(20), nullable=False),
        sa.Column("encrypted_api_key", sa.Text(), nullable=False),
        sa.Column("key_last4", sa.String(4), nullable=False),
        sa.Column("last_test_status", sa.String(20), nullable=True),
        sa.Column("last_test_message_safe", sa.Text(), nullable=True),
        sa.Column("last_tested_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("user_id", "provider"),
    )
    op.create_index("ix_provider_accounts_user_id", "provider_accounts", ["user_id"])
    op.create_index("ix_provider_accounts_provider", "provider_accounts", ["provider"])
    op.create_table(
        "provider_capability_configs",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("capability", sa.String(10), nullable=False),
        sa.Column("provider", sa.String(20), nullable=False, server_default="none"),
        sa.Column("provider_account_id", sa.String(36), sa.ForeignKey("provider_accounts.id", ondelete="RESTRICT"), nullable=True),
        sa.Column("enabled", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("model", sa.String(160), nullable=True),
        sa.Column("voice", sa.String(80), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("user_id", "capability"),
    )
    op.create_index("ix_provider_capability_configs_user_id", "provider_capability_configs", ["user_id"])
    op.create_index("ix_provider_capability_configs_capability", "provider_capability_configs", ["capability"])
    op.create_index("ix_provider_capability_configs_provider_account_id", "provider_capability_configs", ["provider_account_id"])


def downgrade() -> None:
    bind = op.get_bind()
    if bind.dialect.name != "sqlite":
        accounts = bind.execute(sa.text("SELECT COUNT(*) FROM provider_accounts")).scalar() or 0
        configs = bind.execute(sa.text("SELECT COUNT(*) FROM provider_capability_configs")).scalar() or 0
        if accounts or configs:
            raise RuntimeError("0009 downgrade requires empty provider account tables")
    op.drop_index("ix_provider_capability_configs_provider_account_id", table_name="provider_capability_configs")
    op.drop_index("ix_provider_capability_configs_capability", table_name="provider_capability_configs")
    op.drop_index("ix_provider_capability_configs_user_id", table_name="provider_capability_configs")
    op.drop_table("provider_capability_configs")
    op.drop_index("ix_provider_accounts_provider", table_name="provider_accounts")
    op.drop_index("ix_provider_accounts_user_id", table_name="provider_accounts")
    op.drop_table("provider_accounts")
