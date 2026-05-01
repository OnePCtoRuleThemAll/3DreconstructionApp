from pathlib import Path

def project_root() -> Path:
    return Path(__file__).resolve().parents[1]

def datasets_dir() -> Path:
    return project_root() / "datasets"

def outputs_dir() -> Path:
    return project_root() / "outputs"

def scripts_dir() -> Path:
    return project_root() / "scripts"
