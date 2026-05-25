import shutil
from pathlib import Path
from pipeline.adapter import SinkAdapter
from pipeline.envelope import Envelope


class FileSinkAdapter(SinkAdapter):
    id = "file-sink"

    def configure(self, config: dict) -> None:
        self.output_dir = Path(config.get("output_dir", "/tmp/pipeline/output"))
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def write(self, envelope: Envelope) -> None:
        src = Path(envelope.payload_ref)
        if not src.exists():
            raise FileNotFoundError(f"[file-sink] payload_ref not found: {src}")
        dest = self.output_dir / src.name
        shutil.copy2(src, dest)
        print(f"[file-sink] wrote {dest}")

    def health_check(self) -> bool:
        return self.output_dir.exists()
