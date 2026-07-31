from __future__ import annotations

import base64
import binascii
import secrets

from cryptography.exceptions import InvalidTag
from cryptography.hazmat.primitives.ciphers.aead import AESGCM


class CredentialConfigurationError(ValueError):
    pass


def _master_key(encoded: str) -> bytes:
    if not encoded:
        raise CredentialConfigurationError("Credential encryption is not configured.")
    try:
        key = base64.urlsafe_b64decode(encoded.encode("ascii"))
    except (binascii.Error, ValueError) as error:
        raise CredentialConfigurationError("Credential encryption is not configured.") from error
    if len(key) != 32:
        raise CredentialConfigurationError("Credential encryption is not configured.")
    return key


def encrypt_credential(value: str, encoded_master_key: str) -> str:
    if not value:
        raise ValueError("Credential cannot be empty.")
    nonce = secrets.token_bytes(12)
    ciphertext = AESGCM(_master_key(encoded_master_key)).encrypt(nonce, value.encode(), None)
    return "v1:" + ":".join(
        base64.urlsafe_b64encode(part).decode("ascii") for part in (nonce, ciphertext)
    )


def decrypt_credential(value: str, encoded_master_key: str) -> str:
    try:
        version, encoded_nonce, encoded_ciphertext = value.split(":", 2)
        if version != "v1":
            raise ValueError("unsupported version")
        plaintext = AESGCM(_master_key(encoded_master_key)).decrypt(
            base64.urlsafe_b64decode(encoded_nonce),
            base64.urlsafe_b64decode(encoded_ciphertext),
            None,
        )
        return plaintext.decode("utf-8")
    except (ValueError, UnicodeDecodeError, binascii.Error, InvalidTag) as error:
        raise CredentialConfigurationError("Stored credential could not be decrypted.") from error
