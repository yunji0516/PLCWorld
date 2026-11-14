"""Validate final release integrity and pinned archived equivalence attestations.

Historical results keep their real source seals.
The artifact metadata is the release trust anchor, not an external signature.
"""
from __future__ import annotations

from functools import lru_cache
import hashlib
import json
from pathlib import Path


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def safe_file(root: Path, relative: str) -> Path:
    path = Path(relative)
    if path.is_absolute() or not path.parts or ".." in path.parts:
        raise ValueError("Unsafe release asset path")
    target = root / path
    if not target.resolve().is_relative_to(root.resolve()):
        raise ValueError("Release asset escapes artifact root")
    return target


def pinned(root: Path, name: str, expected: str) -> dict:
    path = safe_file(root, name)
    if digest(path) != expected:
        raise ValueError(f"Release evidence hash mismatch: {name}")
    return json.loads(path.read_text(encoding="utf-8"))


def release_record(root: Path) -> tuple[dict, dict, dict]:
    artifact = json.loads((root / "artifact.json").read_text(encoding="utf-8"))
    binding = artifact.get("release_verification")
    if not binding:
        raise ValueError("Missing final release verification binding")
    inventory = pinned(root, binding["integrity_file"], binding["integrity_sha256"])
    evidence = pinned(root, binding["equivalence_file"], binding["equivalence_sha256"])
    if (inventory.get("schema") != "plcworld-release-integrity/1"
            or evidence.get("schema") not in {"plcworld-release-equivalence/1", "plcworld-release-equivalence/2"}
            or not evidence.get("passed")
            or evidence["current_evaluator_seal_sha256"] != artifact["evaluator_seal_sha256"]
            or evidence["input_seal_sha256"] != artifact["input_seal_sha256"]):
        raise ValueError("Final release evidence binding mismatch")
    files = inventory["files"]
    for name, expected in inventory["historical_files"].items():
        if files.get(name) != expected:
            raise ValueError("Historical inventory is not covered by release integrity")
    if files.get(binding["equivalence_file"]) != binding["equivalence_sha256"]:
        raise ValueError("Equivalence evidence is not covered by release integrity")
    return artifact, inventory, evidence


def verify_runtime(root: Path, artifact: dict, inventory: dict) -> None:
    for directory, filename, field in (
            ("evaluator", "release-seal.json", "evaluator_seal_sha256"),
            ("inputs", "input-seal.json", "input_seal_sha256")):
        relative = f"{directory}/{filename}"
        if digest(root / relative) != artifact[field]:
            raise ValueError(f"Current {directory} seal hash mismatch")
        seal = json.loads((root / relative).read_text())
        for name, expected in seal.items():
            asset = f"{directory}/{name}"
            if inventory["files"].get(asset) != expected or digest(safe_file(root, asset)) != expected:
                raise ValueError(f"Current runtime drift: {asset}")
        actual = {p.relative_to(root).as_posix() for p in (root / directory).rglob('*')
                  if p.is_file() and '__pycache__' not in p.parts}
        pinned_assets = {name for name in inventory['files'] if name.startswith(directory + '/')}
        if actual != pinned_assets:
            raise ValueError(f"Unexpected unsealed {directory} file")
        for name in pinned_assets:
            if digest(safe_file(root, name)) != inventory['files'][name]:
                raise ValueError(f"Current runtime drift: {name}")


@lru_cache(maxsize=4)
def trusted_evaluator_seals(root: Path) -> frozenset[str]:
    root = root.resolve()
    artifact, inventory, evidence = release_record(root)
    verify_runtime(root, artifact, inventory)
    current = artifact["evaluator_seal_sha256"]
    checks = evidence["behavioral_checks"]
    if not checks:
        raise ValueError("Missing behavioral equivalence evidence")
    for check in checks:
        rows = check["results"]
        if (not check.get("passed") or check.get("api_calls") != 0
                or check["cases_checked"] != len(rows) or not rows
                or any(not row.get("passed") or not row.get("scoring_fields_match")
                       or row.get("differing_fields")
                       or not row.get("trace_sha256_before")
                       or row["trace_sha256_before"] != row.get("trace_sha256_after")
                       for row in rows)):
            raise ValueError("Behavioral equivalence validation failed")
    connected = {current}
    while True:
        predecessors = {row["previous_evaluator_seal_sha256"] for row in checks
                        if row["current_evaluator_seal_sha256"] in connected}
        if predecessors <= connected:
            break
        connected |= predecessors
    accepted = evidence["accepted_source_seals"]
    if (len(set(accepted)) != len(accepted) or set(accepted) != connected
            or any(len(value) != 64 or any(c not in "0123456789abcdef" for c in value)
                   for value in accepted)):
        raise ValueError("Unverified evaluator source seal")
    return frozenset(accepted)


def verify_historical_data(root: Path, *, include_reproduction: bool = True) -> int:
    """Check final-path archived bytes without rewriting historical source seals."""
    trusted_evaluator_seals(root)
    _, inventory, _ = release_record(root)
    count = 0
    for name, expected in inventory["historical_files"].items():
        if not include_reproduction and name.startswith("outputs/reproduction/"):
            continue
        if digest(safe_file(root, name)) != expected:
            raise ValueError(f"Historical data drift: {name}")
        count += 1
    return count


def verify_release_files(root: Path, package_profile: str = "full") -> int:
    """Check every pinned immutable file; local generated runs are excluded."""
    trusted_evaluator_seals(root)
    _, inventory, _ = release_record(root)
    if package_profile not in ("full", "evaluator"):
        raise ValueError("Unknown package verification profile")
    selected = inventory["files"]
    if package_profile == "evaluator":
        # The evaluator image deliberately excludes the separate Node viewer,
        # test sources and host-side Compose/build configuration.
        selected = {name: expected for name, expected in selected.items()
                    if name == "README.md" or name.startswith((
                        "evaluator/", "inputs/", "submissions/", "results/",
                        "verification/", "replay/", "scripts/", "outputs/reproduction/"))}
    for name, expected in selected.items():
        if digest(safe_file(root, name)) != expected:
            raise ValueError(f"Release asset drift: {name}")
    return len(selected)


def protect_historical_output(root: Path, output: Path) -> None:
    """Do not permit new reports/runs to overwrite final release assets."""
    _, inventory, _ = release_record(root)
    try:
        relative = output.resolve().relative_to(root.resolve()).as_posix()
    except ValueError:
        return
    if (relative == '.' or relative == 'artifact.json'
            or relative == 'verification' or relative.startswith('verification/')
            or any(relative == name or name.startswith(relative + '/')
                   for name in inventory['files'])):
        raise ValueError("Archived evidence is immutable; choose a new output path")
