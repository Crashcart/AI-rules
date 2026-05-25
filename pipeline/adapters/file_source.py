import os
import time
from pathlib import Path
from pipeline.adapter import SourceAdapter
from pipeline.envelope import Envelope


class FileSourceAdapter(SourceAdapter):
    id = "file-source"

    def configure(self, config: dict) -> None:
        self.watch_dir = Path(config.get("watch_dir", "/tmp/pipeline/input"))
        self.file_pattern = config.get("file_pattern", "*")
        self.poll_interval = float(config.get("poll_interval_seconds", 1.0))
        self.delete_after_read = config.get("delete_after_read", False)
        self._seen: set = set()

    def read(self) -> Envelope:
        while True:
            self.watch_dir.mkdir(parents=True, exist_ok=True)
            files = sorted(
                f
                for f in self.watch_dir.glob(self.file_pattern)
                if f.is_file() and str(f) not in self._seen
            )
            if files:
                path = files[0]
                self._seen.add(str(path))
                env = Envelope(
                    type=self._guess_type(path),
                    source_adapter=self.id,
                    payload_ref=str(path),
                    metadata={"filename": path.name, "size_bytes": path.stat().st_size},
                )
                if self.delete_after_read:
                    os.remove(path)
                return env
            time.sleep(self.poll_interval)

    def health_check(self) -> bool:
        return self.watch_dir.parent.exists()

    @staticmethod
    def _guess_type(path: Path) -> str:
        suffix = path.suffix.lower()
        audio = {".mp3", ".wav", ".ogg", ".flac", ".aac", ".m4a"}
        image = {".png", ".jpg", ".jpeg", ".gif", ".webp"}
        text = {".txt", ".md", ".csv", ".log"}
        if suffix in audio:
            return "audio"
        if suffix in image:
            return "image"
        if suffix in text:
            return "text"
        if suffix == ".json":
            return "json"
        return "binary"
