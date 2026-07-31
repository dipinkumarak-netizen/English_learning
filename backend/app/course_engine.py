"""Deterministic Phase 3 exercise scoring."""

import re
import unicodedata
from collections.abc import Iterable
from typing import Any


def normalize_text(value: Any) -> str:
    text = unicodedata.normalize("NFKC", str(value)).strip().casefold()
    text = re.sub(r"[\p{P}\p{S}]", " ", text) if False else re.sub(r"[^\w\s]", " ", text)
    return " ".join(text.split())


def _as_list(value: Any) -> list[Any]:
    if isinstance(value, list):
        return value
    return [value]


def score_answer(exercise_type: str, answer: Any, correct_answer: Any) -> bool:
    if exercise_type in {"multiple_choice", "match_pairs"}:
        if exercise_type == "match_pairs":
            return answer == correct_answer
        return sorted(normalize_text(item) for item in _as_list(answer)) == sorted(
            normalize_text(item) for item in _as_list(correct_answer)
        )
    if exercise_type in {"fill_blank", "natural_sentence", "correct_mistake", "translation"}:
        acceptable = _as_list(correct_answer)
        return normalize_text(answer) in {normalize_text(item) for item in acceptable}
    if exercise_type == "reorder_words":
        return [normalize_text(item) for item in _as_list(answer)] == [
            normalize_text(item) for item in _as_list(correct_answer)
        ]
    if exercise_type in {"single_choice", "reading_comprehension", "true_false"}:
        return normalize_text(answer) == normalize_text(correct_answer)
    return False


def acceptable_answers(correct_answer: Any) -> Iterable[Any]:
    return _as_list(correct_answer)
