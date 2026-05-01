from pathlib import Path
import cv2
import numpy as np
import torch
import time
import os

def run(dataset_dir: Path, out_dir: Path, model_type: str = "DPT_Large"):
    img_dir = dataset_dir / "images"
    out_dir.mkdir(parents=True, exist_ok=True)

    midas = torch.hub.load("intel-isl/MiDaS", model_type)
    midas.eval().to("cuda")

    transforms = torch.hub.load("intel-isl/MiDaS", "transforms")
    if model_type in ["DPT_Large", "DPT_Hybrid"]:
        transform = transforms.dpt_transform
    else:
        transform = transforms.small_transform

    images = sorted(list(img_dir.glob("*.jpg")) + list(img_dir.glob("*.png")) + list(img_dir.glob("*.jpeg")))
    print(f"[MiDaS] Found {len(images)} images in {img_dir}")

    t0 = time.time()
    for p in images:
        img_bgr = cv2.imread(str(p))
        if img_bgr is None:
            print(f"  ! skip unreadable: {p.name}")
            continue

        img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)

        inp = transform(img_rgb).to("cuda")

        if inp.ndim == 3:
            inp = inp.unsqueeze(0)

        with torch.no_grad():
            pred = midas(inp)
            depth = pred.squeeze().float().cpu().numpy()

        # normalize for visualization (0..255)
        depth_vis = cv2.normalize(depth, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)
        depth_vis = cv2.resize(depth_vis, (img_bgr.shape[1], img_bgr.shape[0]))

        cv2.imwrite(str(out_dir / f"{p.stem}_depth.jpg"), depth_vis)

    print(f"[MiDaS] Done in {time.time() - t0:.1f}s. Output: {out_dir}")

if __name__ == "__main__":
    base = Path(os.environ.get("PROJECT_ROOT", Path(__file__).resolve().parents[1]))
    dataset_id = os.environ.get("DATASET_ID", "dataset_01")

    dataset = Path(os.environ.get("DATASET_DIR", base / "datasets" / dataset_id))
    out_root = Path(os.environ.get("OUT_ROOT", base / "outputs" / dataset_id))
    out = out_root / "midas"

    run(dataset, out, model_type=os.environ.get("MIDAS_MODEL", "DPT_Large"))

