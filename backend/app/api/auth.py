from datetime import UTC, datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.db.session import get_db
from app.dependencies import current_user
from app.models import LearnerProfile, OnboardingProgress, RefreshSession, User
from app.schemas import AuthResponse, LoginRequest, RefreshRequest, RegisterRequest, UserPublic
from app.security import (
    create_access_token,
    create_refresh_token,
    hash_password,
    hash_refresh_token,
    verify_password,
)

router = APIRouter(prefix="/auth", tags=["authentication"])


async def issue_tokens(user: User, db: AsyncSession) -> AuthResponse:
    raw_refresh, token_hash = create_refresh_token()
    db.add(
        RefreshSession(
            user_id=user.id,
            token_hash=token_hash,
            expires_at=datetime.now(UTC) + timedelta(days=get_settings().refresh_token_days),
        )
    )
    await db.flush()
    return AuthResponse(
        user=UserPublic.model_validate(user),
        access_token=create_access_token(user.id),
        refresh_token=raw_refresh,
    )


@router.post("/register", response_model=AuthResponse, status_code=201)
async def register(payload: RegisterRequest, db: AsyncSession = Depends(get_db)) -> AuthResponse:
    if not get_settings().allow_registration:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Registration is currently disabled."
        )
    email = str(payload.email).lower()
    if await db.scalar(select(User).where(User.email == email)) is not None:
        raise HTTPException(status_code=409, detail="Unable to create account with these details.")
    user = User(
        email=email,
        display_name=payload.display_name,
        password_hash=hash_password(payload.password),
    )
    db.add(user)
    await db.flush()
    db.add(LearnerProfile(user_id=user.id))
    db.add(OnboardingProgress(user_id=user.id))
    response = await issue_tokens(user, db)
    await db.commit()
    return response


@router.post("/login", response_model=AuthResponse)
async def login(payload: LoginRequest, db: AsyncSession = Depends(get_db)) -> AuthResponse:
    user = await db.scalar(select(User).where(User.email == str(payload.email).lower()))
    if user is None or not verify_password(payload.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid email or password.")
    response = await issue_tokens(user, db)
    await db.commit()
    return response


@router.post("/refresh", response_model=AuthResponse)
async def refresh(payload: RefreshRequest, db: AsyncSession = Depends(get_db)) -> AuthResponse:
    session = await db.scalar(
        select(RefreshSession).where(
            RefreshSession.token_hash == hash_refresh_token(payload.refresh_token)
        )
    )
    now = datetime.now(UTC)
    if session is None:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token.")
    expires_at = (
        session.expires_at.replace(tzinfo=UTC)
        if session.expires_at.tzinfo is None
        else session.expires_at
    )
    if session.revoked_at is not None or expires_at <= now:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token.")
    user = await db.scalar(select(User).where(User.id == session.user_id))
    if user is None:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token.")
    session.revoked_at = now
    response = await issue_tokens(user, db)
    await db.commit()
    return response


@router.post("/logout", status_code=204)
async def logout(
    payload: RefreshRequest, user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> None:
    session = await db.scalar(
        select(RefreshSession).where(
            RefreshSession.user_id == user.id,
            RefreshSession.token_hash == hash_refresh_token(payload.refresh_token),
        )
    )
    if session is not None:
        session.revoked_at = datetime.now(UTC)
        await db.commit()


@router.post("/logout-all", status_code=204)
async def logout_all(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> None:
    sessions = (
        await db.scalars(
            select(RefreshSession).where(
                RefreshSession.user_id == user.id, RefreshSession.revoked_at.is_(None)
            )
        )
    ).all()
    now = datetime.now(UTC)
    for session in sessions:
        session.revoked_at = now
    await db.commit()


@router.delete("/account", status_code=204)
async def delete_account(
    user: User = Depends(current_user), db: AsyncSession = Depends(get_db)
) -> Response:
    await db.delete(user)
    await db.commit()
    return Response(status_code=204)


@router.get("/me", response_model=UserPublic)
async def me(user: User = Depends(current_user)) -> UserPublic:
    return UserPublic.model_validate(user)
