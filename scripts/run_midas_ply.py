from pathlib import Path
import os, time, subprocess
import cv2
import numpy as np
import torch
import shutil
import open3d as o3d
import datetime
import atexit, faulthandler, traceback

COLMAP_BAT = Path(os.environ.get("PROJECT_ROOT", Path(__file__).resolve().parents[1]), "tools\colmap\COLMAP.bat")
LOG_F = None
KEEP_NEAREST_PERCENT = float(os.environ.get("KEEP_NEAREST_PERCENT", "60"))
VOXEL_SIZE = float(os.environ.get("VOXEL_SIZE", "0.005"))
OUTLIER_NB_NEIGHBORS = int(os.environ.get("OUTLIER_NB_NEIGHBORS", "10"))
OUTLIER_STD_RATIO = float(os.environ.get("OUTLIER_STD_RATIO", "2.5"))


# =========================
# Helpers
# =========================

def set_logger(log_path):
    global LOG_F
    log_path.parent.mkdir(parents=True, exist_ok=True)
    LOG_F = open(log_path, "a", encoding="utf-8", buffering=1) 

    faulthandler.enable(LOG_F)

    def _on_exit():
        try:
            LOG_F.write("[END] normal atexit reached\n")
            LOG_F.flush()
        except:
            pass

    atexit.register(_on_exit)

def log(*args):
    """Log to console and to the log file (if enabled)."""
    msg = " ".join(str(a) for a in args)
    try:
        if LOG_F:
            LOG_F.write(msg + "\n")
            LOG_F.flush()
    except Exception:
        pass
    print(msg, flush=True)


def run_cmd(cmd, cwd=None):
    # cmd je list, napr: [colmap_bat, "feature_extractor", "--database_path", "..."]
    log("[CMD]", " ".join(f'"{c}"' if " " in str(c) else str(c) for c in cmd))
    subprocess.run(cmd, cwd=cwd, check=True)

def qvec2rotmat(qvec):
    w, x, y, z = qvec
    return np.array([
        [1 - 2*y*y - 2*z*z,     2*x*y - 2*z*w,     2*x*z + 2*y*w],
        [    2*x*y + 2*z*w, 1 - 2*x*x - 2*z*z,     2*y*z - 2*x*w],
        [    2*x*z - 2*y*w,     2*y*z + 2*x*w, 1 - 2*x*x - 2*y*y],
    ], dtype=np.float64)

def load_colmap_cameras_txt(path: Path):
    cams = {}
    for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        cam_id = int(parts[0])
        model = parts[1]
        w = int(parts[2]); h = int(parts[3])
        params = list(map(float, parts[4:]))

        if model == "SIMPLE_PINHOLE":
            f, cx, cy = params
            fx = fy = f

        elif model == "PINHOLE":
            fx, fy, cx, cy = params

        elif model == "SIMPLE_RADIAL":
            f, cx, cy, _k = params
            fx = fy = f

        elif model == "RADIAL":
            f, cx, cy, _k1, _k2 = params
            fx = fy = f

        elif model == "OPENCV":
            fx, fy, cx, cy = params[:4]

        elif model == "FULL_OPENCV":
            fx, fy, cx, cy = params[:4]

        elif model == "OPENCV_FISHEYE":
            fx, fy, cx, cy = params[:4]

        else:
            raise ValueError(f"Unsupported COLMAP camera model here: {model}")

        cams[cam_id] = {
            "model": model, "w": w, "h": h,
            "fx": fx, "fy": fy, "cx": cx, "cy": cy
        }
    return cams

def load_colmap_images_txt(path: Path):
    lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    out = {}
    i = 0
    while i < len(lines):
        line = lines[i].strip(); i += 1
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        if len(parts) < 10:
            continue

        image_id = int(parts[0])
        qvec = np.array(list(map(float, parts[1:5])), dtype=np.float64)
        tvec = np.array(list(map(float, parts[5:8])), dtype=np.float64)
        cam_id = int(parts[8])
        name = parts[9]

        pts2d = []
        if i < len(lines):
            pts_line = lines[i].strip(); i += 1
            if pts_line:
                p = pts_line.split()
                for j in range(0, len(p) - 2, 3):
                    x = float(p[j]); y = float(p[j+1]); pid = int(float(p[j+2]))
                    if pid != -1:
                        pts2d.append((x, y, pid))

        out[name] = {"image_id": image_id, "camera_id": cam_id, "qvec": qvec, "tvec": tvec, "pts2d": pts2d}
    return out

def write_ply_xyzrgb(path: Path, xyz: np.ndarray, rgb: np.ndarray):
    n = xyz.shape[0]
    header = "\n".join([
        "ply",
        "format ascii 1.0",
        f"element vertex {n}",
        "property float x",
        "property float y",
        "property float z",
        "property uchar red",
        "property uchar green",
        "property uchar blue",
        "end_header",
    ]) + "\n"
    with path.open("w", encoding="utf-8") as f:
        f.write(header)
        for p, c in zip(xyz, rgb):
            f.write(f"{p[0]:.6f} {p[1]:.6f} {p[2]:.6f} {int(c[0])} {int(c[1])} {int(c[2])}\n")

def depth_to_ply_single_view(rgb_bgr: np.ndarray, depth: np.ndarray, out_ply: Path,
                             fx: float = None, fy: float = None, cx: float = None, cy: float = None,
                             depth_scale: float = 1.0, stride: int = 10):
    """
    Create a single-view colored point cloud in the camera coordinate frame.
    If fx/fy/cx/cy are None -> use a crude pinhole guess from image size (like many demo repos do).
    """
    rgb = cv2.cvtColor(rgb_bgr, cv2.COLOR_BGR2RGB)
    H, W = rgb.shape[:2]

    if fx is None or fy is None or cx is None or cy is None:
        f = 1.2 * max(W, H)
        fx = fy = f
        cx = W * 0.5
        cy = H * 0.5

    d = depth.astype(np.float32)
    d = d - np.percentile(d, 5)
    d = np.clip(d, 1e-6, np.percentile(d, 95))
    d = d / (d.max() + 1e-6)
    d = d * depth_scale

    us = np.arange(0, W, stride, dtype=np.int32)
    vs = np.arange(0, H, stride, dtype=np.int32)
    uu, vv = np.meshgrid(us, vs)
    uu = uu.reshape(-1); vv = vv.reshape(-1)

    z = d[vv, uu]
    valid = z > 1e-6
    uu = uu[valid]; vv = vv[valid]; z = z[valid]

    x = (uu.astype(np.float32) - cx) / fx * z
    y = (vv.astype(np.float32) - cy) / fy * z
    xyz = np.stack([x, y, z], axis=1)

    colors = rgb[vv, uu, :].astype(np.uint8)

    out_ply.parent.mkdir(parents=True, exist_ok=True)

    mask = np.linalg.norm(xyz, axis=1) < np.percentile(np.linalg.norm(xyz, axis=1), 98)
    xyz = xyz[mask]
    colors = colors[mask]

    write_ply_xyzrgb(out_ply, xyz.astype(np.float32), colors)

def load_colmap_points3d_txt(path: Path):
    pts = {}
    for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line=line.strip()
        if not line or line.startswith("#"):
            continue
        parts=line.split()
        pid=int(parts[0])
        X,Y,Z = map(float, parts[1:4])
        pts[pid] = np.array([X,Y,Z], dtype=np.float64)
    return pts

def _robust_affine_fit(x: np.ndarray, y: np.ndarray, iters: int = 15, huber_k: float = 1.5):
    """Fit y ~= a*x + b with simple IRLS (Huber). Returns (a,b)."""
    x = x.astype(np.float64).reshape(-1)
    y = y.astype(np.float64).reshape(-1)
    A = np.stack([x, np.ones_like(x)], axis=1) 

    try:
        sol, *_ = np.linalg.lstsq(A, y, rcond=None)
        a, b = float(sol[0]), float(sol[1])
    except Exception:
        return None

    for _ in range(iters):
        r = y - (a * x + b)
        med = np.median(r)
        mad = np.median(np.abs(r - med)) + 1e-12
        s = 1.4826 * mad  
        t = np.abs(r) / (huber_k * s + 1e-12)
        w = np.ones_like(t)
        mask = t > 1.0
        w[mask] = 1.0 / (t[mask] + 1e-12)

        Aw = A * w[:, None]
        yw = y * w
        try:
            sol, *_ = np.linalg.lstsq(Aw, yw, rcond=None)
            a_new, b_new = float(sol[0]), float(sol[1])
        except Exception:
            break

        if not np.isfinite(a_new) or not np.isfinite(b_new):
            break
        if abs(a_new - a) < 1e-6 and abs(b_new - b) < 1e-4:
            a, b = a_new, b_new
            break
        a, b = a_new, b_new

    return a, b

def estimate_affine_depth(depth, pts2d, pts3d, R, t):
    """Estimate per-image affine mapping from MiDaS depth (normalized) to metric Z in camera.
    Returns (a, b, inverted) where Z ~= a*d + b and d is normalized into [0,1].
    """
    H, W = depth.shape[:2]

    dm = []
    zc = []

    for x, y, pid in pts2d:
        u = int(round(x)); v = int(round(y))
        if u < 0 or u >= W or v < 0 or v >= H:
            continue
        d = float(depth[v, u])
        if not np.isfinite(d):
            continue
        Xw = pts3d.get(pid, None)
        if Xw is None:
            continue
        Xc = R @ Xw.reshape(3, 1) + t.reshape(3, 1)
        z = float(Xc[2, 0])
        if z <= 0 or not np.isfinite(z):
            continue
        dm.append(d); zc.append(z)

    if len(dm) < 80:
        return None

    dm = np.array(dm, dtype=np.float64)
    zc = np.array(zc, dtype=np.float64)

    lo, hi = np.percentile(dm, 5), np.percentile(dm, 95)
    m = (dm >= lo) & (dm <= hi)
    dm = dm[m]; zc = zc[m]
    if dm.size < 80:
        return None

    dm_n = (dm - dm.min()) / (dm.max() - dm.min() + 1e-12)

    corr = np.corrcoef(dm_n, zc)[0, 1]
    inverted = bool(np.isfinite(corr) and corr < 0)
    if inverted:
        dm_n = 1.0 - dm_n

    fit = _robust_affine_fit(dm_n, zc)
    if fit is None:
        return None
    a, b = fit

    if not np.isfinite(a) or not np.isfinite(b) or a <= 0:
        return None

    return float(a), float(b), inverted

# =========================
# 1) COLMAP pipeline -> TXT model
# =========================

def ensure_colmap_txt_model(dataset_dir: Path, work_dir: Path, colmap_bat: str, reset: bool = False):
    img_dir = dataset_dir / "images"
    if not img_dir.exists():
        raise FileNotFoundError(f"Missing images folder: {img_dir}")

    colmap_root = work_dir/ "midas" / "colmap"
    db_path = colmap_root / "database.db"
    sparse_dir = colmap_root / "sparse"
    txt_dir = colmap_root / "sparse_txt"

    if reset and colmap_root.exists():
        shutil.rmtree(colmap_root)

    colmap_root.mkdir(parents=True, exist_ok=True)
    sparse_dir.mkdir(parents=True, exist_ok=True)
    txt_dir.mkdir(parents=True, exist_ok=True)

    run_cmd([
        colmap_bat, "feature_extractor",
        "--database_path", str(db_path),
        "--image_path", str(img_dir),
        "--ImageReader.single_camera", "1",
        "--SiftExtraction.use_gpu", "1",
        "--ImageReader.camera_model", "PINHOLE",
    ])

    run_cmd([
        colmap_bat, "exhaustive_matcher",
        "--database_path", str(db_path),
        "--SiftMatching.use_gpu", "1",
    ])

    run_cmd([
        colmap_bat, "mapper",
        "--database_path", str(db_path),
        "--image_path", str(img_dir),
        "--output_path", str(sparse_dir),
    ])

    model_bin = None
    for cand in sorted(sparse_dir.glob("*")):
        if cand.is_dir() and (cand / "cameras.bin").exists() and (cand / "images.bin").exists():
            model_bin = cand
            break
    if model_bin is None:
        raise RuntimeError(f"COLMAP mapper finished but no model found in: {sparse_dir}")
    
    undist_dir = colmap_root / "undistorted"
    undist_img_dir = undist_dir / "images"
    undist_sparse_dir = undist_dir / "sparse"

    run_cmd([
        colmap_bat, "image_undistorter",
        "--image_path", str(img_dir),
        "--input_path", str(model_bin),
        "--output_path", str(undist_dir),
        "--output_type", "COLMAP",
    ])

    undist_model_bin = None
    cand_root = undist_sparse_dir
    if (cand_root / "cameras.bin").exists() and (cand_root / "images.bin").exists():
        undist_model_bin = cand_root
    else:
        for cand in sorted(cand_root.glob("*")):
            if cand.is_dir() and (cand / "cameras.bin").exists() and (cand / "images.bin").exists():
                undist_model_bin = cand
                break

    if undist_model_bin is None:
        raise RuntimeError(f"Undistorter finished but no model found in: {undist_sparse_dir}")

    run_cmd([
        colmap_bat, "model_converter",
        "--input_path", str(undist_model_bin),
        "--output_path", str(txt_dir),
        "--output_type", "TXT",
    ])

    if not (txt_dir / "cameras.txt").exists() or not (txt_dir / "images.txt").exists():
        raise RuntimeError(f"TXT export failed, missing cameras.txt/images.txt in {txt_dir}")

    return txt_dir, undist_img_dir

# =========================
# 2) MiDaS depth
# =========================

def run_midas(dataset_dir: Path, out_dir: Path, model_type: str = "DPT_Large"):
    img_dir = dataset_dir
    out_dir.mkdir(parents=True, exist_ok=True)

    midas = torch.hub.load("intel-isl/MiDaS", model_type)
    midas.eval().to("cuda")

    transforms = torch.hub.load("intel-isl/MiDaS", "transforms")
    transform = transforms.dpt_transform if model_type in ["DPT_Large", "DPT_Hybrid"] else transforms.small_transform

    images = sorted(list(img_dir.glob("*.jpg")) + list(img_dir.glob("*.png")) + list(img_dir.glob("*.jpeg")))
    log(f"[MiDaS] Found {len(images)} images in {img_dir}")

    t0 = time.time()
    for p in images:
        img_bgr = cv2.imread(str(p))
        if img_bgr is None:
            log(f"  ! skip unreadable: {p.name}")
            continue

        img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
        inp = transform(img_rgb).to("cuda")
        if inp.ndim == 3:
            inp = inp.unsqueeze(0)

        with torch.no_grad():
            pred = midas(inp)
            depth_raw = pred.squeeze().float().cpu().numpy()

        depth_raw = cv2.resize(depth_raw, (img_bgr.shape[1], img_bgr.shape[0]), interpolation=cv2.INTER_CUBIC)

        np.save(str(out_dir / f"{p.stem}_depth.npy"), depth_raw)
        depth_vis = cv2.normalize(depth_raw, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)
        cv2.imwrite(str(out_dir / f"{p.stem}_depth.jpg"), depth_vis)

        ply_dir = out_dir / "ply_single"
        ply_dir.mkdir(parents=True, exist_ok=True)

        log(f"  - processing {p.name} (depth min={depth_raw.min():.4f} max={depth_raw.max():.4f})...")
        try:
            depth_to_ply_single_view(
                rgb_bgr=img_bgr,
                depth=depth_raw,
                out_ply=ply_dir / f"{p.stem}.ply",
                depth_scale=float(os.environ.get("SINGLE_DEPTH_SCALE", "1.0")),
                stride=int(os.environ.get("SINGLE_PLY_STRIDE", "10")),
            )
        except Exception as e:
            log(f"  ! single-view ply failed for {p.name}: {e}")
        
    log(f"[MiDaS] Done in {time.time() - t0:.1f}s. Output: {out_dir}")

# =========================
# 3) Depth + COLMAP poses -> Dense PLY
# =========================

def depth_to_dense_ply(
    img_dir: Path,
    depth_dir: Path,
    colmap_txt_dir: Path,
    out_ply: Path,
    stride: int = 4,
    max_depth_percentile: float = 99.0,
):
    cams_path = colmap_txt_dir / "cameras.txt"
    imgs_path = colmap_txt_dir / "images.txt"
    if not cams_path.exists() or not imgs_path.exists():
        raise FileNotFoundError(f"Missing COLMAP text model in {colmap_txt_dir}")

    cams = load_colmap_cameras_txt(cams_path)
    imgs = load_colmap_images_txt(imgs_path)

    pts3d = load_colmap_points3d_txt(colmap_txt_dir / "points3D.txt")

    all_xyz, all_rgb = [], []
    used = 0
    img_files = sorted(list(img_dir.glob("*.jpg")) + list(img_dir.glob("*.png")) + list(img_dir.glob("*.jpeg")))

    # ---------- PASS 1: estimate global scale (and global inversion vote) ----------
    a_samples = []
    b_samples = []
    inv_votes = []

    for p in img_files:
        if p.name not in imgs:
            continue
        depth_npy = depth_dir / f"{p.stem}_depth.npy"
        if not depth_npy.exists():
            continue

        bgr = cv2.imread(str(p), cv2.IMREAD_COLOR)
        if bgr is None:
            continue
        rgb_img = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
        H, W = rgb_img.shape[:2]

        depth = np.load(str(depth_npy)).astype(np.float32)
        if depth.shape[0] != H or depth.shape[1] != W:
            depth = cv2.resize(depth, (W, H), interpolation=cv2.INTER_CUBIC)

        meta = imgs[p.name]
        if len(meta["pts2d"]) < 80:
            continue

        R = qvec2rotmat(meta["qvec"])
        t = meta["tvec"].reshape(3, 1)

        fit = estimate_affine_depth(depth, meta["pts2d"], pts3d, R, t)
        if fit is None:
            continue

        a, b, inverted = fit
        if np.isfinite(a) and a > 0 and np.isfinite(b):
            a_samples.append(a)
            b_samples.append(b)
            inv_votes.append(1 if inverted else 0)

    if len(a_samples) < 3:
        log("[WARN] Too few scale samples for global scale, falling back to per-image scale.")
        global_a = None
        global_b = None
        global_inverted = False
    else:
        global_a = float(np.median(a_samples))
        global_b = float(np.median(b_samples))
        global_inverted = (sum(inv_votes) > (len(inv_votes) / 2))
        log(f"[GLOBAL] a={global_a:.6f}, b={global_b:.6f}, inverted={global_inverted}, n={len(a_samples)}")
    # -------------------------------------------------------------------

    for p in img_files:
        if p.name not in imgs:
            continue

        depth_npy = depth_dir / f"{p.stem}_depth.npy"
        if not depth_npy.exists():
            continue

        bgr = cv2.imread(str(p), cv2.IMREAD_COLOR)
        if bgr is None:
            continue
        rgb_img = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
        H, W = rgb_img.shape[:2]

        depth = np.load(str(depth_npy)).astype(np.float32) 
        if depth.shape[0] != H or depth.shape[1] != W:
            depth = cv2.resize(depth, (W, H), interpolation=cv2.INTER_CUBIC)


        meta = imgs[p.name]
        cam = cams[meta["camera_id"]]
        fx, fy, cx, cy = cam["fx"], cam["fy"], cam["cx"], cam["cy"]
        R = qvec2rotmat(meta["qvec"])
        t = meta["tvec"].reshape(3, 1)

        fit = estimate_affine_depth(depth, meta["pts2d"], pts3d, R, t)

        d = depth.astype(np.float64)
        lo = np.percentile(d, 5)
        hi = np.percentile(d, 95)
        d = np.clip(d, lo, hi)
        d = (d - lo) / (hi - lo + 1e-8)

        if global_a is not None and global_b is not None:
            if global_inverted:
                d = 1.0 - d
            depth_metric = global_a * np.clip(d, 1e-6, None) + global_b
        else:
            fit = estimate_affine_depth(depth, meta["pts2d"], pts3d, R, t)
            if fit is not None:
                a, b, inverted = fit
                if inverted:
                    d = 1.0 - d
                depth_metric = a * np.clip(d, 1e-6, None) + b
            else:
                depth_metric = np.clip(d, 1e-4, None)

        if global_a is not None and global_b is not None:
            log(f"[fit] {p.name}: GLOBAL a={global_a:.3f}, b={global_b:.3f}, inverted={global_inverted}, n2d3d={len(meta['pts2d'])}")
        else:
            if fit is not None:
                log(f"[fit] {p.name}: a={a:.3f}, b={b:.3f}, inverted={inverted}, n2d3d={len(meta['pts2d'])}")
            else:
                log(f"[fit] {p.name}: FAILED (fallback), n2d3d={len(meta['pts2d'])}")

        cap = np.percentile(depth_metric, max_depth_percentile)
        depth_metric = np.clip(depth_metric, 1e-6, cap)

        us = np.arange(0, W, stride, dtype=np.int32)
        vs = np.arange(0, H, stride, dtype=np.int32)
        uu, vv = np.meshgrid(us, vs)
        uu = uu.reshape(-1); vv = vv.reshape(-1)

        z = depth_metric[vv, uu]
        if KEEP_NEAREST_PERCENT is not None and KEEP_NEAREST_PERCENT < 100.0:
            z_thr = np.percentile(z, KEEP_NEAREST_PERCENT)
            valid = (z > 1e-6) & (z <= z_thr)
        else:
            valid = (z > 1e-6)
        uu = uu[valid]; vv = vv[valid]; z = z[valid]

        x = (uu.astype(np.float32) - cx) / fx * z
        y = (vv.astype(np.float32) - cy) / fy * z
        Xc = np.stack([x, y, z], axis=0).astype(np.float64)  

        Xw = (R.T @ (Xc - t)).T  
        colors = rgb_img[vv, uu, :].astype(np.uint8)

        all_xyz.append(Xw.astype(np.float32))
        all_rgb.append(colors)
        used += 1

    if used == 0:
        raise RuntimeError("No images matched COLMAP images.txt names OR no depth npy files found.")

    xyz = np.concatenate(all_xyz, axis=0)
    rgb = np.concatenate(all_rgb, axis=0)

    out_ply.parent.mkdir(parents=True, exist_ok=True)
    if VOXEL_SIZE and VOXEL_SIZE > 0:
        try:
            pcd = o3d.geometry.PointCloud()
            pcd.points = o3d.utility.Vector3dVector(xyz.astype(np.float64))
            pcd.colors = o3d.utility.Vector3dVector((rgb.astype(np.float64) / 255.0))
            pcd = pcd.voxel_down_sample(VOXEL_SIZE)
            xyz = np.asarray(pcd.points).astype(np.float32)
            rgb = (np.asarray(pcd.colors) * 255.0).clip(0, 255).astype(np.uint8)
            log(f"[CLEAN] voxel_down_sample={VOXEL_SIZE} -> {xyz.shape[0]} pts")
        except Exception as e:
            log("[WARN] voxel_down_sample failed:", e)

    if OUTLIER_NB_NEIGHBORS and OUTLIER_NB_NEIGHBORS > 0:
        try:
            pcd = o3d.geometry.PointCloud()
            pcd.points = o3d.utility.Vector3dVector(xyz.astype(np.float64))
            pcd.colors = o3d.utility.Vector3dVector((rgb.astype(np.float64) / 255.0))
            pcd, ind = pcd.remove_statistical_outlier(
                nb_neighbors=OUTLIER_NB_NEIGHBORS,
                std_ratio=OUTLIER_STD_RATIO,
            )
            xyz = np.asarray(pcd.points).astype(np.float32)
            rgb = (np.asarray(pcd.colors) * 255.0).clip(0, 255).astype(np.uint8)
            log(f"[CLEAN] statistical_outlier nb={OUTLIER_NB_NEIGHBORS}, std={OUTLIER_STD_RATIO} -> {xyz.shape[0]} pts")
        except Exception as e:
            log("[WARN] statistical_outlier failed:", e)

    write_ply_xyzrgb(out_ply, xyz, rgb)
    return xyz.shape[0], used

# =========================
# MAIN
# =========================

if __name__ == "__main__":
    base = Path(os.environ.get("PROJECT_ROOT", Path(__file__).resolve().parents[1]))
    dataset_id = os.environ.get("DATASET_ID", "dataset_01")

    dataset = Path(os.environ.get("DATASET_DIR", base / "datasets" / dataset_id))
    out_root = Path(os.environ.get("OUT_ROOT", base / "outputs" / dataset_id))
    out_midas = out_root / "midas"

    log_path = out_midas / "midas.log"
    set_logger(log_path)
    log("[MAIN] started")

    colmap_bat = os.environ.get("COLMAP_BAT", COLMAP_BAT)
    if not colmap_bat or not Path(colmap_bat).exists():
        raise FileNotFoundError(
            "COLMAP_BAT is not set or file does not exist.\n"
            "Set COLMAP_BAT env var or edit COLMAP_BAT at the top of the script."
        )

    log("[1/3] COLMAP -> sparse_txt")
    colmap_txt = ensure_colmap_txt_model(dataset, out_root, colmap_bat=colmap_bat, reset=True)
    log("  COLMAP TXT model:", colmap_txt)

    log("[2/3] MiDaS depth")
    run_midas(colmap_txt[1], out_midas, model_type=os.environ.get("MIDAS_MODEL", "DPT_Large"))

    log("[3/3] Dense PLY from MiDaS + COLMAP poses")
    ply_path = out_root / "midas" / "dense_from_midas_colmap.ply"
    n_points, n_views = depth_to_dense_ply(
        img_dir=colmap_txt[1],
        depth_dir=out_midas,
        colmap_txt_dir=colmap_txt[0],
        out_ply=ply_path,
        stride=int(os.environ.get("PC_STRIDE", "3")),
    )
    log(f"[DONE] {n_points} points from {n_views} views -> {ply_path}")