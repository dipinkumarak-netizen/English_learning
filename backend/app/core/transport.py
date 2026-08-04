from __future__ import annotations

from ipaddress import ip_address, ip_network
from urllib.parse import urlparse

from fastapi import Request

from app.core.config import Settings


def _trusted_client(request: Request, settings: Settings) -> bool:
    if not settings.trust_proxy_headers or request.client is None:
        return False
    try:
        client = ip_address(request.client.host)
    except ValueError:
        return False
    try:
        networks = [
            ip_network(value.strip(), strict=False)
            for value in settings.trusted_proxy_networks.split(",")
            if value.strip()
        ]
    except ValueError:
        return False
    return any(client in network for network in networks)


def effective_scheme(request: Request, settings: Settings) -> str:
    if _trusted_client(request, settings):
        forwarded = request.headers.get("x-forwarded-proto", "").split(",")[0].strip().lower()
        if forwarded in {"http", "https"}:
            return forwarded
    return request.url.scheme.lower()


def effective_host(request: Request, settings: Settings) -> str:
    if _trusted_client(request, settings):
        forwarded = request.headers.get("x-forwarded-host", "").split(",")[0].strip()
        if forwarded and "://" not in forwarded and "@" not in forwarded:
            return forwarded
    return request.url.netloc


def transport_state(request: Request, settings: Settings) -> str:
    scheme = effective_scheme(request, settings)
    if scheme == "https":
        return "secure_https"
    if scheme == "http":
        return "private_http"
    return "insecure_or_invalid"


def public_base_url_is_safe(value: str) -> bool:
    parsed = urlparse(value)
    return (
        parsed.scheme == "https"
        and bool(parsed.hostname)
        and not parsed.username
        and not parsed.password
    )
