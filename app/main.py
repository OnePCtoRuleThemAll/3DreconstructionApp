import sys
import time
from pathlib import Path

from PySide6.QtCore import Qt, QObject, QThread, Signal, QTimer
from PySide6.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout, QLabel, QComboBox,
    QCheckBox, QPushButton, QTextEdit, QGroupBox, QFormLayout, QSpinBox,
    QTableWidget, QTableWidgetItem, QMessageBox
)

from .config import datasets_dir
from .runner import run_method


def list_datasets() -> list[str]:
    ddir = datasets_dir()
    if not ddir.exists():
        return []
    out = []
    for p in sorted(ddir.iterdir()):
        if p.is_dir() and (p / "images").exists():
            out.append(p.name)
    return out


class RunWorker(QObject):
    started = Signal(str)  # method_id
    finished_one = Signal(dict)  # result dict
    failed = Signal(str)
    all_done = Signal()

    def __init__(self, dataset_id: str, methods: list[str], gpu_index: int):
        super().__init__()
        self.dataset_id = dataset_id
        self.methods = methods
        self.gpu_index = gpu_index
        self._stop = False

    def stop(self):
        self._stop = True

    def run(self):
        try:
            for m in self.methods:
                if self._stop:
                    break
                self.started.emit(m)
                res = run_method(m, self.dataset_id, gpu_index=self.gpu_index)
                self.finished_one.emit(res)
            self.all_done.emit()
        except Exception as e:
            self.failed.emit(str(e))


class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Depth/3D Benchmark Runner")
        self.resize(1100, 700)

        self.worker_thread: QThread | None = None
        self.worker: RunWorker | None = None

        root = QVBoxLayout(self)

        top = QGroupBox("Run setup")
        top_l = QFormLayout(top)

        self.dataset_combo = QComboBox()
        self.refresh_datasets()

        self.gpu_spin = QSpinBox()
        self.gpu_spin.setMinimum(0)
        self.gpu_spin.setMaximum(16)
        self.gpu_spin.setValue(0)

        top_l.addRow("Dataset:", self.dataset_combo)
        top_l.addRow("GPU index:", self.gpu_spin)

        root.addWidget(top)

        methods_box = QGroupBox("Methods")
        hb = QHBoxLayout(methods_box)

        self.cb_colmap = QCheckBox("COLMAP (SfM + dense)")
        self.cb_patch = QCheckBox("PatchmatchNet (MVS)")
        self.cb_midas = QCheckBox("MiDaS (mono depth)")
        self.cb_meshroom = QCheckBox("Meshroom")
        self.cb_colmap.setChecked(True)
        self.cb_patch.setChecked(True)
        self.cb_midas.setChecked(True)
        self.cb_meshroom.setChecked(True)

        hb.addWidget(self.cb_colmap)
        hb.addWidget(self.cb_patch)
        hb.addWidget(self.cb_midas)
        hb.addWidget(self.cb_meshroom)
        hb.addStretch(1)
        root.addWidget(methods_box)

        btns = QHBoxLayout()
        self.btn_refresh = QPushButton("Refresh datasets")
        self.btn_run = QPushButton("Run selected")
        self.btn_stop = QPushButton("Stop")
        self.btn_stop.setEnabled(False)

        self.btn_refresh.clicked.connect(self.refresh_datasets)
        self.btn_run.clicked.connect(self.on_run)
        self.btn_stop.clicked.connect(self.on_stop)

        btns.addWidget(self.btn_refresh)
        btns.addStretch(1)
        btns.addWidget(self.btn_run)
        btns.addWidget(self.btn_stop)
        root.addLayout(btns)

        mid = QHBoxLayout()

        self.table = QTableWidget(0, 6)
        self.table.setHorizontalHeaderLabels(["Method", "Exit", "Duration (s)", "Run dir", "Log", "Timeline CSV"])
        self.table.setWordWrap(False)
        self.table.setTextElideMode(Qt.ElideMiddle)
        self.table.horizontalHeader().setStretchLastSection(True)
        mid.addWidget(self.table, 2)

        right = QVBoxLayout()
        right.addWidget(QLabel("Live log (tail):"))
        self.log_view = QTextEdit()
        self.log_view.setReadOnly(True)
        self.log_view.setLineWrapMode(QTextEdit.NoWrap)
        right.addWidget(self.log_view, 1)
        mid.addLayout(right, 1)

        root.addLayout(mid)

        self._current_log_path: Path | None = None
        self._tail_timer = QTimer(self)
        self._tail_timer.timeout.connect(self._update_tail)
        self._tail_timer.start(700)

    def refresh_datasets(self):
        ds = list_datasets()
        cur = self.dataset_combo.currentText()
        self.dataset_combo.clear()
        self.dataset_combo.addItems(ds)
        if cur in ds:
            self.dataset_combo.setCurrentText(cur)

    def selected_methods(self) -> list[str]:
        methods = []
        if self.cb_colmap.isChecked():
            methods.append("colmap")
        if self.cb_patch.isChecked():
            methods.append("patchmatchnet")
        if self.cb_midas.isChecked():
            methods.append("midas")
        if self.cb_meshroom.isChecked():
            methods.append("meshroom")
        return methods

    def on_run(self):
        dataset_id = self.dataset_combo.currentText().strip()
        if not dataset_id:
            QMessageBox.warning(self, "No dataset", "No dataset selected. Put datasets into /datasets/<name>/images.")
            return

        methods = self.selected_methods()
        if not methods:
            QMessageBox.warning(self, "No methods", "Select at least one method.")
            return

        gpu_index = int(self.gpu_spin.value())

        self.btn_run.setEnabled(False)
        self.btn_stop.setEnabled(True)
        self.log_view.clear()
        self._current_log_path = None

        self.worker_thread = QThread()
        self.worker = RunWorker(dataset_id, methods, gpu_index)
        self.worker.moveToThread(self.worker_thread)

        self.worker_thread.started.connect(self.worker.run)
        self.worker.started.connect(self.on_started_method)
        self.worker.finished_one.connect(self.on_finished_one)
        self.worker.failed.connect(self.on_failed)
        self.worker.all_done.connect(self.on_all_done)

        self.worker_thread.start()

    def on_stop(self):
        if self.worker:
            self.worker.stop()
        self.btn_stop.setEnabled(False)

    def on_started_method(self, method_id: str):
        self.log_view.append(f"\n=== Running: {method_id} ===\n")

    def on_finished_one(self, res: dict):
        self._current_log_path = Path(res["log_path"])

        row = self.table.rowCount()
        self.table.insertRow(row)

        def put(col, text):
            it = QTableWidgetItem(text)
            it.setFlags(it.flags() ^ Qt.ItemIsEditable)
            self.table.setItem(row, col, it)

        put(0, res["method"])
        put(1, str(res["exit_code"]))
        put(2, f"{res['duration_sec']:.1f}")
        put(3, res["run_dir"])
        put(4, res["log_path"])
        put(5, res["timeline_csv"])

        self.log_view.append(f"\n[Done] {res['method']} exit={res['exit_code']} duration={res['duration_sec']:.1f}s\n")
        self.log_view.append(f"Run dir: {res['run_dir']}\nOutputs: {res['out_root']}\n")

    def on_failed(self, msg: str):
        QMessageBox.critical(self, "Run failed", msg)
        self.on_all_done()

    def on_all_done(self):
        if self.worker_thread:
            self.worker_thread.quit()
            self.worker_thread.wait(2000)
        self.worker_thread = None
        self.worker = None

        self.btn_run.setEnabled(True)
        self.btn_stop.setEnabled(False)
        self.log_view.append("\n=== ALL DONE ===\n")

    def _update_tail(self):
        if not self._current_log_path:
            return
        p = self._current_log_path
        if not p.exists():
            return
        try:
            with open(p, "rb") as f:
                f.seek(0, 2)
                size = f.tell()
                f.seek(max(0, size - 40000), 0)
                data = f.read().decode("utf-8", errors="replace")
            tail = data[-200:]
            cur = self.log_view.toPlainText()
            if tail and tail not in cur[-1000:]:
                self.log_view.append(data.splitlines()[-30:][0] if data.splitlines() else "")
                self.log_view.append("\n".join(data.splitlines()[-30:]))
        except Exception:
            pass


def main():
    app = QApplication(sys.argv)
    w = MainWindow()
    w.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
