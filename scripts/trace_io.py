"""Streaming archived JSON scan arrays and hashing assets without rewriting them."""
import gzip
import hashlib
import json


def frames(path):
    decoder = json.JSONDecoder()
    with gzip.open(path, "rt", encoding="utf-8") as stream:
        buffer = ""
        while True:
            buffer = buffer.lstrip(" \r\n\t,[")
            if buffer.startswith("]"):
                return
            try:
                value, end = decoder.raw_decode(buffer)
            except json.JSONDecodeError:
                chunk = stream.read(262144)
                if not chunk:
                    if buffer.strip():
                        raise ValueError(f"Truncated trace: {path}")
                    return
                buffer += chunk
                continue
            yield value
            buffer = buffer[end:]


def sha(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1048576), b""):
            digest.update(block)
    return digest.hexdigest()
