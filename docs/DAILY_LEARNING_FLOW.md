# Daily learning flow

The starter course is represented as 12 sequential days. Backend lessons have a stable `course_id` and `day_number`; the seed data derives Day 1–Day 12 from the existing 4 modules and 3 lessons per module. The migration backfills existing lessons deterministically and enforces uniqueness per course.

The API returns `day_number`, `unlocked`, `completed`, and `score` for each lesson. A day becomes available only when the previous day is complete. Completed days remain reviewable. The mobile app applies the same rule to server responses, cached course payloads, and the 12-day local fallback, so relaunching offline preserves the sequence.

The Dashboard resumes the first open day. Completing a lesson invalidates the learning-path provider and shows the score plus the next-day unlock (or course completion after Day 12). Local progress is stored in Drift and remains eligible for later sync/account merge through the existing pending-operation flow.

Validation covers backend schema/API tests, migration compilation, Flutter analysis, local startup routing, and the daily path model. This phase does not include voice, speech-to-text, text-to-speech, or pronunciation scoring.
