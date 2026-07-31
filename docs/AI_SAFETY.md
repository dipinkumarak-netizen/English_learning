# AI safety

The backend applies deterministic safety redirects before provider generation for dangerous instructions, self-harm encouragement, explicit sexual requests, hate/harassment, credential extraction, and system-prompt/key extraction. Redirects remain focused on safe English learning.

AI output is untrusted text. Structured responses are validated with Pydantic, rendered as text in Flutter, and never executed as HTML, code, commands, or navigation. Provider errors are reduced to safe client messages. Medical, legal, and financial requests may be corrected as English but are not treated as professional advice.
