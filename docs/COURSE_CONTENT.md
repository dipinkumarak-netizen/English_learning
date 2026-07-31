# Phase 3 course content

The initial course is `everyday-english-foundations`, titled **Everyday English Foundations**. It is original, private-use curriculum for Malayalam-speaking Pre-A1/A1 learners. It contains four published modules and twelve published lessons covering introductions, objects, routines, and practical conversations.

The hierarchy is:

`Course → CourseModule → Lesson → LessonStep → ExerciseDefinition`

Lesson steps use explicit types: introduction, explanation, example, vocabulary card, exercise, reading passage/content, and summary. Educational support is stored separately from English primary content in explicit explanation fields. The application UI remains English-only.

Content has stable UUIDs derived from stable slugs, integer versions, publication flags, and snapshot versions on exercise attempts. The seed is repeatable and never deletes learner progress:

```powershell
cd backend
.\.venv\Scripts\python.exe -m app.seed
```

Running the command again finds the existing course and stable child records rather than creating duplicates. The seed exercises all ten supported deterministic exercise types across the twelve lessons.

Phase 3 does not include AI-generated content, audio, speech, pronunciation evaluation, certification claims, or copied passages.
