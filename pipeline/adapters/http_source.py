import time
import tempfile
import hashlib
from pathlib import Path
from urllib.request import urlopen
from urllib.error import URLError
from pipeline.adapter import SourceAdapter
from pipeline.envelope import Envelope


class HttpSourceAdapter(SourceAdapter):
    id = "http-source"

    def configure(self, config: dict) -> None:
        self.url = config["url"]
        self.poll_interval = float(config.get("poll_interval_seconds", 5.0))
        self.content_type = config.get("type", "json")
        self._last_hash: str = ""
        self._tmp_dir = Path(tempfile.mkdtemp(prefix="pipeline-http-"))

    def read(self) -> Envelope:
        while True:
            try:
                with urlopen(self.url, timeout=10) as resp:
                    body = resp.read()
                    digest = hashlib.sha256(body).hexdigest()
                    if digest != self._last_hash:
                        self._last_hash = digest
                        tmp = self._tmp_dir / f"{digest[:16]}.bin"
                        tmp.write_bytes(body)
                        return Envelope(
                            type=self.content_type,
                            source_adapter=self.id,
                            payload_ref=str(tmp),
                            metadata={
                                "url": self.url,
                                "bytes": len(body),
                                "sha256": digest,
                            },
                        )
            except (URLError, OSError) as exc:
                print(
                    f"[http-source] fetch error: {exc} — retrying in {self.poll_interval}s"
                )
            time.sleep(self.poll_interval)

    def health_check(self) -> bool:
        try:
            with urlopen(self.url, timeout=5):
                return True
        except Exception:
            return False
