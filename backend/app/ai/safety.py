import re

from app.schemas import TutorResponsePayload

BLOCKED_PATTERNS = re.compile(
    r"(how to make a bomb|make a weapon|self[- ]harm|kill yourself|explicit sexual|hate speech|steal a password)",
    re.IGNORECASE,
)
PROMPT_INJECTION_PATTERNS = re.compile(
    r"(reveal|show|ignore).{0,30}(system prompt|developer message|api key|secret)", re.IGNORECASE
)


def safety_redirect(text: str) -> TutorResponsePayload | None:
    if BLOCKED_PATTERNS.search(text):
        return TutorResponsePayload(
            reply_text="I can help you practise English, but I cannot help with that request. Let us practise a safe everyday sentence instead.",
            safety_status="redirected",
            encouragement="We can keep the practice safe and useful.",
            follow_up_question="Would you like to practise a simple introduction?",
        )
    if PROMPT_INJECTION_PATTERNS.search(text):
        return TutorResponsePayload(
            reply_text="I cannot reveal private instructions or secrets. I can help correct or practise your English.",
            safety_status="redirected",
            encouragement="Please send an English-learning sentence.",
        )
    return None
