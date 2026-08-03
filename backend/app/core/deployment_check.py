from __future__ import annotations

import os

from app.core.validation import validate_database_credentials


def main() -> int:
    errors = validate_database_credentials(
        os.getenv("DATABASE_URL", ""),
        os.getenv("POSTGRES_PASSWORD"),
        os.getenv("DATABASE_EXPECTED_HOST") or None,
        os.getenv("POSTGRES_USER"),
        os.getenv("POSTGRES_DB"),
    )
    if errors:
        print("deployment configuration invalid: " + ", ".join(errors))
        return 1
    print("deployment database configuration is consistent")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
