"""Add personal authentication, learner profile, placement, and plan tables.

Revision ID: 0001_phase2_foundation
Revises:
"""

from collections.abc import Sequence

import sqlalchemy as sa

from alembic import op

revision: str = "0001_phase2_foundation"
down_revision: str | None = None
branch_labels: Sequence[str] | None = None
depends_on: Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "users",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("email", sa.String(320), nullable=False),
        sa.Column("display_name", sa.String(120), nullable=True),
        sa.Column("password_hash", sa.Text(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("email"),
    )
    op.create_index("ix_users_email", "users", ["email"], unique=True)
    op.create_table(
        "refresh_sessions",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column("token_hash", sa.String(64), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("revoked_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("token_hash"),
    )
    op.create_index("ix_refresh_sessions_user_id", "refresh_sessions", ["user_id"])
    op.create_index(
        "ix_refresh_sessions_token_hash", "refresh_sessions", ["token_hash"], unique=True
    )
    op.create_table(
        "learner_profiles",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column("application_language", sa.String(10), nullable=False, server_default="ml"),
        sa.Column("native_language", sa.String(10), nullable=False, server_default="ml"),
        sa.Column("explanation_language", sa.String(10), nullable=False, server_default="ml"),
        sa.Column("confidence_level", sa.String(40), nullable=True),
        sa.Column("daily_study_minutes", sa.Integer(), nullable=True),
        sa.Column("onboarding_complete", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("user_id"),
    )
    op.create_index("ix_learner_profiles_user_id", "learner_profiles", ["user_id"], unique=True)
    op.create_table(
        "learning_goal_selections",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "profile_id",
            sa.String(36),
            sa.ForeignKey("learner_profiles.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("goal", sa.String(50), nullable=False),
        sa.UniqueConstraint("profile_id", "goal"),
    )
    op.create_index(
        "ix_learning_goal_selections_profile_id", "learning_goal_selections", ["profile_id"]
    )
    op.create_table(
        "difficult_area_selections",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "profile_id",
            sa.String(36),
            sa.ForeignKey("learner_profiles.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("area", sa.String(50), nullable=False),
        sa.UniqueConstraint("profile_id", "area"),
    )
    op.create_index(
        "ix_difficult_area_selections_profile_id", "difficult_area_selections", ["profile_id"]
    )
    op.create_table(
        "onboarding_progress",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column("current_step", sa.String(50), nullable=False, server_default="welcome"),
        sa.Column("completed_steps", sa.JSON(), nullable=False),
        sa.Column("draft", sa.JSON(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("user_id"),
    )
    op.create_index(
        "ix_onboarding_progress_user_id", "onboarding_progress", ["user_id"], unique=True
    )
    op.create_table(
        "placement_assessments",
        sa.Column("id", sa.String(80), primary_key=True),
        sa.Column("version", sa.String(20), nullable=False),
        sa.Column("title", sa.String(160), nullable=False),
        sa.Column("active", sa.Boolean(), nullable=False, server_default=sa.true()),
    )
    op.create_table(
        "placement_questions",
        sa.Column("id", sa.String(80), primary_key=True),
        sa.Column(
            "assessment_id",
            sa.String(80),
            sa.ForeignKey("placement_assessments.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("question_type", sa.String(40), nullable=False),
        sa.Column("prompt", sa.Text(), nullable=False),
        sa.Column("options", sa.JSON(), nullable=True),
        sa.Column("correct_answer", sa.JSON(), nullable=False),
        sa.Column("explanation_en", sa.Text(), nullable=False),
        sa.Column("explanation_ml", sa.Text(), nullable=False),
        sa.Column("score_weight", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("difficulty", sa.String(20), nullable=False),
        sa.Column("skill_category", sa.String(40), nullable=False),
        sa.Column("cefr_hint", sa.String(10), nullable=True),
        sa.Column("content_version", sa.String(20), nullable=False, server_default="1"),
    )
    op.create_index(
        "ix_placement_questions_assessment_id", "placement_questions", ["assessment_id"]
    )
    op.create_table(
        "placement_attempts",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "assessment_id",
            sa.String(80),
            sa.ForeignKey("placement_assessments.id"),
            nullable=False,
        ),
        sa.Column("status", sa.String(20), nullable=False, server_default="in_progress"),
        sa.Column("started_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("submitted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index("ix_placement_attempts_user_id", "placement_attempts", ["user_id"])
    op.create_table(
        "placement_answers",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "attempt_id",
            sa.String(36),
            sa.ForeignKey("placement_attempts.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "question_id", sa.String(80), sa.ForeignKey("placement_questions.id"), nullable=False
        ),
        sa.Column("answer", sa.JSON(), nullable=False),
        sa.Column("is_correct", sa.Boolean(), nullable=True),
        sa.UniqueConstraint("attempt_id", "question_id"),
    )
    op.create_index("ix_placement_answers_attempt_id", "placement_answers", ["attempt_id"])
    op.create_table(
        "placement_results",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "attempt_id",
            sa.String(36),
            sa.ForeignKey("placement_attempts.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("raw_score", sa.Integer(), nullable=False),
        sa.Column("percentage", sa.Float(), nullable=False),
        sa.Column("estimated_level", sa.String(10), nullable=False),
        sa.Column("skill_breakdown", sa.JSON(), nullable=False),
        sa.Column("strengths", sa.JSON(), nullable=False),
        sa.Column("improvement_areas", sa.JSON(), nullable=False),
        sa.Column("recommended_track", sa.String(80), nullable=False),
        sa.Column("is_estimate", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.UniqueConstraint("attempt_id"),
    )
    op.create_table(
        "learning_plans",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id", sa.String(36), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "placement_result_id",
            sa.String(36),
            sa.ForeignKey("placement_results.id"),
            nullable=True,
        ),
        sa.Column("estimated_level", sa.String(10), nullable=False),
        sa.Column("recommended_track", sa.String(80), nullable=False),
        sa.Column("daily_study_minutes", sa.Integer(), nullable=False),
        sa.Column("priority_skills", sa.JSON(), nullable=False),
        sa.Column("weekly_target_minutes", sa.Integer(), nullable=False),
        sa.Column("study_days_per_week", sa.Integer(), nullable=False),
        sa.Column("first_activity_types", sa.JSON(), nullable=False),
        sa.Column("explanation_language", sa.String(10), nullable=False),
        sa.Column("plan_version", sa.String(20), nullable=False),
        sa.Column("active", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index("ix_learning_plans_user_id", "learning_plans", ["user_id"])


def downgrade() -> None:
    op.drop_index("ix_learning_plans_user_id", table_name="learning_plans")
    op.drop_table("learning_plans")
    op.drop_table("placement_results")
    op.drop_index("ix_placement_answers_attempt_id", table_name="placement_answers")
    op.drop_table("placement_answers")
    op.drop_index("ix_placement_attempts_user_id", table_name="placement_attempts")
    op.drop_table("placement_attempts")
    op.drop_index("ix_placement_questions_assessment_id", table_name="placement_questions")
    op.drop_table("placement_questions")
    op.drop_table("placement_assessments")
    op.drop_index("ix_onboarding_progress_user_id", table_name="onboarding_progress")
    op.drop_table("onboarding_progress")
    op.drop_index("ix_difficult_area_selections_profile_id", table_name="difficult_area_selections")
    op.drop_table("difficult_area_selections")
    op.drop_index("ix_learning_goal_selections_profile_id", table_name="learning_goal_selections")
    op.drop_table("learning_goal_selections")
    op.drop_index("ix_learner_profiles_user_id", table_name="learner_profiles")
    op.drop_table("learner_profiles")
    op.drop_index("ix_refresh_sessions_token_hash", table_name="refresh_sessions")
    op.drop_index("ix_refresh_sessions_user_id", table_name="refresh_sessions")
    op.drop_table("refresh_sessions")
    op.drop_index("ix_users_email", table_name="users")
    op.drop_table("users")
