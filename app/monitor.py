import csv, time, threading
import psutil

try:
    import pynvml
    NVML_OK = True
except Exception:
    NVML_OK = False

class ResourceMonitor:
    def __init__(self, csv_path: str, interval: float = 1.0, gpu_index: int = 0):
        self.csv_path = csv_path
        self.interval = interval
        self.gpu_index = gpu_index
        self._stop = threading.Event()
        self._t = threading.Thread(target=self._run, daemon=True)

    def start(self):
        if NVML_OK:
            pynvml.nvmlInit()
        psutil.cpu_percent(interval=None)
        self._t.start()

    def stop(self):
        self._stop.set()
        self._t.join(timeout=5)
        if NVML_OK:
            try: pynvml.nvmlShutdown()
            except Exception: pass

    def _gpu(self):
        if not NVML_OK:
            return (None, None)
        h = pynvml.nvmlDeviceGetHandleByIndex(self.gpu_index)
        util = pynvml.nvmlDeviceGetUtilizationRates(h).gpu
        mem = pynvml.nvmlDeviceGetMemoryInfo(h)
        return (util, int(mem.used/1024/1024))

    def _run(self):
        with open(self.csv_path, "w", newline="", encoding="utf-8") as f:
            w = csv.writer(f)
            w.writerow(["t","cpu_pct","ram_used_mb","gpu_util_pct","vram_used_mb"])
            while not self._stop.is_set():
                t = time.time()
                cpu = psutil.cpu_percent(interval=None)
                ram = int(psutil.virtual_memory().used/1024/1024)
                gpu, vram = self._gpu()
                w.writerow([f"{t:.3f}", cpu, ram, gpu, vram])
                f.flush()
                time.sleep(self.interval)
