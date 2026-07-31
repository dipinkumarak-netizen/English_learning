"""Remove the application-interface language from learner profiles.

Revision ID: 0002_remove_application_language
Revises: 0001_phase2_foundation
"""

from collections.abc import Sequence

import sqlalchemy as sa

from alembic import op

revision: str = "0002_remove_application_language"
down_revision: str | None = "0001_phase2_foundation"
branch_labels: Sequence[str] | None = None
depends_on: Sequence[str] | None = None


def upgrade() -> None:
    op.drop_column("learner_profiles", "application_language")


def downgrade() -> None:
    op.add_column(
        "learner_profiles",
        sa.Column("application_language", sa.String(10), nullable=False, server_default="ml"),
    )
