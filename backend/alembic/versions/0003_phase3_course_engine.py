"""Add Phase 3 course, exercise, progress, and sync tables.

Revision ID: 0003_phase3_course_engine
Revises: 0002_remove_application_language
"""

from collections.abc import Sequence

import sqlalchemy as sa

from alembic import op

revision: str = "0003_phase3_course_engine"
down_revision: str | None = "0002_remove_application_language"
branch_labels: Sequence[str] | None = None
depends_on: Sequence[str] | None = None


def _timestamps(table: sa.Table) -> None:
    table.append_column(
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now())
    )
    table.append_column(
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now())
    )


def upgrade() -> None:
    op.create_table(
        "courses",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("slug", sa.String(120), nullable=False),
        sa.Column("title", sa.String(200), nullable=False),
        sa.Column("short_description", sa.String(500), nullable=False),
        sa.Column("full_description", sa.Text(), nullable=False),
        sa.Column("learner_level", sa.String(10), nullable=False, server_default="A1"),
        sa.Column("native_language_support", sa.JSON(), nullable=False),
        sa.Column("explanation_languages", sa.JSON(), nullable=False),
        sa.Column("estimated_total_minutes", sa.Integer(), nullable=False),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("is_published", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("sort_order", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("thumbnail_ref", sa.String(200)),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("slug"),
    )
    op.create_index("ix_courses_slug", "courses", ["slug"])
    op.create_index("ix_courses_is_published", "courses", ["is_published"])
    op.create_table(
        "course_modules",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "course_id",
            sa.String(36),
            sa.ForeignKey("courses.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("title", sa.String(200), nullable=False),
        sa.Column("description", sa.Text(), nullable=False),
        sa.Column("sort_order", sa.Integer(), nullable=False),
        sa.Column("estimated_minutes", sa.Integer(), nullable=False),
        sa.Column("unlock_rule", sa.String(40), nullable=False, server_default="previous_module"),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("is_published", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("course_id", "sort_order"),
    )
    op.create_index("ix_course_modules_course_id", "course_modules", ["course_id"])
    op.create_index("ix_course_modules_is_published", "course_modules", ["is_published"])
    op.create_table(
        "lessons",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "module_id",
            sa.String(36),
            sa.ForeignKey("course_modules.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("slug", sa.String(140), nullable=False),
        sa.Column("title", sa.String(200), nullable=False),
        sa.Column("summary", sa.Text(), nullable=False),
        sa.Column("learning_objectives", sa.JSON(), nullable=False),
        sa.Column("grammar_focus", sa.String(160), nullable=False),
        sa.Column("vocabulary_focus", sa.JSON(), nullable=False),
        sa.Column("estimated_minutes", sa.Integer(), nullable=False),
        sa.Column("difficulty", sa.String(20), nullable=False, server_default="beginner"),
        sa.Column("sort_order", sa.Integer(), nullable=False),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("is_published", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column(
            "prerequisite_lesson_id",
            sa.String(36),
            sa.ForeignKey("lessons.id", ondelete="SET NULL"),
        ),
        sa.Column("offline_eligible", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("module_id", "sort_order"),
        sa.UniqueConstraint("slug"),
    )
    op.create_index("ix_lessons_module_id", "lessons", ["module_id"])
    op.create_index("ix_lessons_slug", "lessons", ["slug"])
    op.create_index("ix_lessons_is_published", "lessons", ["is_published"])
    op.create_table(
        "lesson_steps",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "lesson_id",
            sa.String(36),
            sa.ForeignKey("lessons.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("step_type", sa.String(30), nullable=False),
        sa.Column("sort_order", sa.Integer(), nullable=False),
        sa.Column("title", sa.String(200), nullable=False),
        sa.Column("content_en", sa.Text(), nullable=False),
        sa.Column("explanation_ml", sa.Text()),
        sa.Column("audio_ref", sa.String(200)),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("is_required", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.Column("completion_rule", sa.String(40), nullable=False, server_default="view"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("lesson_id", "sort_order"),
    )
    op.create_index("ix_lesson_steps_lesson_id", "lesson_steps", ["lesson_id"])
    op.create_table(
        "exercise_definitions",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "step_id",
            sa.String(36),
            sa.ForeignKey("lesson_steps.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("exercise_type", sa.String(40), nullable=False),
        sa.Column("learner_level", sa.String(10), nullable=False, server_default="A1"),
        sa.Column("skill_category", sa.String(40), nullable=False),
        sa.Column("prompt_en", sa.Text(), nullable=False),
        sa.Column("support_ml", sa.Text()),
        sa.Column("options", sa.JSON()),
        sa.Column("correct_answer", sa.JSON(), nullable=False),
        sa.Column("explanation_en", sa.Text(), nullable=False),
        sa.Column("explanation_ml", sa.Text()),
        sa.Column("scoring_weight", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("max_attempts", sa.Integer(), nullable=False, server_default="3"),
        sa.Column("retry_policy", sa.String(30), nullable=False, server_default="until_correct"),
        sa.Column("content_version", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("scoring_config", sa.JSON(), nullable=False),
        sa.UniqueConstraint("step_id"),
    )
    op.create_index("ix_exercise_definitions_step_id", "exercise_definitions", ["step_id"])
    op.create_table(
        "course_enrollments",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "course_id",
            sa.String(36),
            sa.ForeignKey("courses.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("started_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("current_lesson_id", sa.String(36)),
        sa.Column("last_activity_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("user_id", "course_id"),
    )
    op.create_index("ix_course_enrollments_user_id", "course_enrollments", ["user_id"])
    op.create_index("ix_course_enrollments_course_id", "course_enrollments", ["course_id"])
    op.create_table(
        "lesson_progress",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "lesson_id",
            sa.String(36),
            sa.ForeignKey("lessons.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("current_step_id", sa.String(36)),
        sa.Column("started_at", sa.DateTime(timezone=True)),
        sa.Column("last_activity_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("score", sa.Float(), nullable=False, server_default="0"),
        sa.Column("total_attempts", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("completed_at", sa.DateTime(timezone=True)),
        sa.Column("sync_state", sa.String(20), nullable=False, server_default="synced"),
        sa.UniqueConstraint("user_id", "lesson_id"),
    )
    op.create_index("ix_lesson_progress_user_id", "lesson_progress", ["user_id"])
    op.create_index("ix_lesson_progress_lesson_id", "lesson_progress", ["lesson_id"])
    op.create_table(
        "lesson_step_progress",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "step_id",
            sa.String(36),
            sa.ForeignKey("lesson_steps.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("completed_at", sa.DateTime(timezone=True)),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("user_id", "step_id"),
    )
    op.create_index("ix_lesson_step_progress_user_id", "lesson_step_progress", ["user_id"])
    op.create_index("ix_lesson_step_progress_step_id", "lesson_step_progress", ["step_id"])
    op.create_table(
        "exercise_attempts",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "exercise_id", sa.String(36), sa.ForeignKey("exercise_definitions.id"), nullable=False
        ),
        sa.Column("content_version", sa.Integer(), nullable=False),
        sa.Column("answer_snapshot", sa.JSON(), nullable=False),
        sa.Column("is_correct", sa.Boolean(), nullable=False),
        sa.Column("score", sa.Float(), nullable=False),
        sa.Column("attempt_number", sa.Integer(), nullable=False),
        sa.Column("client_operation_id", sa.String(80), nullable=False),
        sa.Column("submitted_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("client_operation_id"),
    )
    op.create_index("ix_exercise_attempts_user_id", "exercise_attempts", ["user_id"])
    op.create_index("ix_exercise_attempts_exercise_id", "exercise_attempts", ["exercise_id"])
    op.create_index(
        "ix_exercise_attempts_client_operation_id", "exercise_attempts", ["client_operation_id"]
    )
    op.create_table(
        "offline_sync_operations",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column("client_operation_id", sa.String(80), nullable=False),
        sa.Column("operation_type", sa.String(40), nullable=False),
        sa.Column("entity_id", sa.String(36), nullable=False),
        sa.Column("payload", sa.JSON(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("retry_count", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("last_error", sa.Text()),
        sa.Column("sync_status", sa.String(20), nullable=False, server_default="pending"),
        sa.UniqueConstraint("user_id", "client_operation_id"),
    )
    op.create_index("ix_offline_sync_operations_user_id", "offline_sync_operations", ["user_id"])


def downgrade() -> None:
    op.drop_table("offline_sync_operations")
    op.drop_table("exercise_attempts")
    op.drop_table("lesson_step_progress")
    op.drop_table("lesson_progress")
    op.drop_table("course_enrollments")
    op.drop_table("exercise_definitions")
    op.drop_table("lesson_steps")
    op.drop_table("lessons")
    op.drop_table("course_modules")
    op.drop_table("courses")
