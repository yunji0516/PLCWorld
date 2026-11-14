"""Stable public task paths; model prompts and evaluation contracts stay separate."""
from pathlib import Path
import re


def task_group(task: str) -> Path:
    if not re.fullmatch(r"(?:MAT|MOT)-[EMH][0-9]{2}", task):
        raise ValueError(f"Invalid task ID: {task}")
    return Path("material" if task.startswith("MAT") else "motion") / {"E":"easy", "M":"medium", "H":"hard"}[task[4]] / task


def model_input_dir(root: Path, task: str) -> Path:
    return root / "inputs/tasks" / task_group(task)
