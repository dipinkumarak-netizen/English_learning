# Prompt management

Prompt task templates are maintained in `backend/app/ai/prompts.py` by task: base tutor rules, beginner conversation, correction, Malayalam explanation, translation, writing, role-play, vocabulary, and summary. The `prompt_template_versions` table provides a versioned storage boundary for future activation without putting prompts in Flutter.

Prompts request validated structured output, include learner level and explanation language, limit response length, resist prompt injection, treat learner text as untrusted, avoid system-prompt disclosure, and prohibit claims about pronunciation from text.

Provider keys, access tokens, refresh tokens, hidden prompts, and unnecessary private profile data are never sent to or stored in the mobile application.
