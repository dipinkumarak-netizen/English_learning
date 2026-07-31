"""Add stable course day sequence to lessons."""

import sqlalchemy as sa

from alembic import op

revision = "0005_daily_learning_sequence"
down_revision = "0004_phase4_ai_tutor"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("lessons", sa.Column("course_id", sa.String(length=36), nullable=True))
    op.add_column("lessons", sa.Column("day_number", sa.Integer(), nullable=True))
    connection = op.get_bind()
    connection.execute(
        sa.text("""
        WITH ordered AS (
            SELECT l.id, cm.course_id,
                   ROW_NUMBER() OVER (
                       PARTITION BY cm.course_id
                       ORDER BY cm.sort_order, l.sort_order, l.id
                   ) AS day_number
            FROM lessons l JOIN course_modules cm ON cm.id = l.module_id
        )
        UPDATE lessons
        SET course_id = ordered.course_id, day_number = ordered.day_number
        FROM ordered WHERE lessons.id = ordered.id
    """)
    )
    op.alter_column("lessons", "course_id", nullable=False)
    op.alter_column("lessons", "day_number", nullable=False)
    op.create_foreign_key(
        "fk_lessons_course_id_courses",
        "lessons",
        "courses",
        ["course_id"],
        ["id"],
        ondelete="CASCADE",
    )
    op.create_unique_constraint(
        "uq_lessons_course_day_number", "lessons", ["course_id", "day_number"]
    )
    op.create_index("ix_lessons_course_day_number", "lessons", ["course_id", "day_number"])


def downgrade() -> None:
    op.drop_index("ix_lessons_course_day_number", table_name="lessons")
    op.drop_constraint("uq_lessons_course_day_number", "lessons", type_="unique")
    op.drop_constraint("fk_lessons_course_id_courses", "lessons", type_="foreignkey")
    op.drop_column("lessons", "day_number")
    op.drop_column("lessons", "course_id")
