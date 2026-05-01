import os
import time
import subprocess
from datetime import datetime
from pathlib import Path
from typing import Callable, Optional

from .config import project_root, scripts_dir, outputs_dir
from .monitor import ResourceMonitor


def _timestamp() -> str:
    return datetime.now().strftime("%Y%m%d_%H%M%S")


def ensure_run_dir(dataset_id: str) -> Path:
    run_dir = outputs_dir() / dataset_id / "_runs" / _timestamp()
    (run_dir / "logs").mkdir(parents=True, exist_ok=True)
    return run_dir


def run_command(cmd: list[str], log_path: Path, env: dict[str, str], cwd: Path, on_live_line: Optional[Callable[[str], None]] = None,) -> int:
    log_path.parent.mkdir(parents=True, exist_ok=True)

    p = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        universal_newlines=True,
        creationflags=subprocess.CREATE_NO_WINDOW,
        env=env,
        cwd=str(cwd),
        shell=False
    )

    with open(log_path, "w", encoding="utf-8", errors="replace") as lf:
        for line in p.stdout:
            lf.write(line)
            lf.flush()
            if on_live_line is not None:
                on_live_line(line)

    return p.wait()


def run_method(method_id: str, dataset_id: str, gpu_index: int = 0) -> dict:
    """
    Runs one method. Assumes scripts are in /scripts:
      - reconstruction.bat
      - run_patchmatchnet.bat
      - run_midas.py
    """
    root = project_root()
    ds_dir = root / "datasets" / dataset_id
    images_dir = ds_dir / "images"
    out_root = root / "outputs" / dataset_id

    run_dir = ensure_run_dir(dataset_id)
    logs_dir = run_dir / "logs"

    env = os.environ.copy()
    env.update({
        "ALICEVISION_ROOT": "C:/Users/cerve/VS/DP/prakticka/tools/meshroom/Meshroom-2025.1.0/aliceVision",
        "PROJECT_ROOT": str(root),
        "DATASET_ID": dataset_id,
        "DATASET_DIR": str(ds_dir),
        "IMAGES_DIR": str(images_dir),
        "OUT_ROOT": str(out_root),
        "GPU_INDEX": str(gpu_index),
    })

    sdir = scripts_dir()
    if method_id == "colmap":
        cmd = ["cmd.exe", "/V:OFF", "/C", str(sdir / "reconstruction.bat")]
        log_path = logs_dir / "colmap.log"
    elif method_id == "patchmatchnet":
        cmd = ["cmd.exe", "/V:OFF", "/C", str(sdir / "run_patchmatchnet.bat")]
        log_path = logs_dir / "patchmatchnet.log"
    elif method_id == "midas":
        # Run MiDaS via app's python by default.
        # If you need a dedicated env, set MIDAS_PYTHON env var to full path of python.exe.
        py = os.environ.get("MIDAS_PYTHON", "")
        if py and Path(py).exists():
            cmd = [py, str(sdir / "run_midas_ply.py")]
        else:
            cmd = [str(root / "envs" / "midas_env" / "Scripts" / "python.exe"), str(sdir / "run_midas_ply.py")]
        log_path = logs_dir / "midas.log"
    elif method_id == "meshroom":

        cmd = ["cmd.exe", "/V:OFF", "/C", str(sdir / "run_meshroom.bat"), dataset_id, str(root)]
        log_path = logs_dir / "meshroom.log"
    else:
        raise ValueError(f"Unknown method: {method_id}")

    timeline_csv = run_dir / f"timeline_{method_id}.csv"
    mon = ResourceMonitor(str(timeline_csv), interval=1.0, gpu_index=gpu_index)

    t0 = time.time()
    mon.start()
    exit_code = run_command(cmd, log_path, env, cwd=root)
    mon.stop()
    dur = time.time() - t0

    return {
        "method": method_id,
        "dataset": dataset_id,
        "exit_code": exit_code,
        "duration_sec": dur,
        "log_path": str(log_path),
        "timeline_csv": str(timeline_csv),
        "run_dir": str(run_dir),
        "out_root": str(out_root),
    }
