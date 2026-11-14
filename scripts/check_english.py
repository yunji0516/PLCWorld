"""Inventory non-English source text; fail with --strict for release gating."""

from __future__ import annotations

import argparse
import re
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SKIP_DIRS = {"node_modules", ".next", "__pycache__", ".git"}


def contains_hangul(text: str) -> bool:
    # Inspect escaped code points as well as literal source characters.
    def decoded(match: re.Match) -> str:
        value = int(next(group for group in match.groups() if group), 16)
        return chr(value) if value <= 0x10FFFF else match.group(0)

    text = re.sub(r"\\(?:u\{([0-9a-fA-F]{1,6})\}|u([0-9a-fA-F]{4})|U([0-9a-fA-F]{8}))", decoded, text)
    return any(0x1100 <= ord(char) <= 0x11FF
               or 0x3130 <= ord(char) <= 0x318F
               or 0xA960 <= ord(char) <= 0xA97F
               or 0xAC00 <= ord(char) <= 0xD7FF for char in text)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--strict", action="store_true", help="Exit nonzero if any Hangul remains")
    parser.add_argument("--paths", action="store_true", help="Print every matching relative path")
    args = parser.parse_args()
    found = []
    for path in ROOT.rglob("*"):
        relative = path.relative_to(ROOT)
        if not path.is_file() or any(part in SKIP_DIRS for part in relative.parts):
            continue
        if contains_hangul(str(relative)):
            found.append(relative)
            continue
        try:
            content = path.read_text(encoding="utf-8")
        except (UnicodeError, OSError):
            continue
        if contains_hangul(content):
            found.append(relative)
    counts = Counter(path.parts[0] for path in found)
    for area, count in sorted(counts.items()):
        print(f"{area}: {count} files")
    print(f"Total: {len(found)} files")
    if args.paths:
        for path in sorted(found):
            print(path)
    if args.strict and found:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
