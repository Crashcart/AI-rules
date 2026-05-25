import json
from pipeline.adapter import SinkAdapter
from pipeline.envelope import Envelope


class StdoutSinkAdapter(SinkAdapter):
    id = "stdout-sink"

    def configure(self, config: dict) -> None:
        self.verbose = config.get("verbose", False)

    def write(self, envelope: Envelope) -> None:
        if self.verbose:
            print(envelope.to_json())
        else:
            d = envelope.to_dict()
            summary = {
                k: d[k]
                for k in ("type", "source_adapter", "timestamp_utc", "payload_ref")
            }
            if d.get("metadata"):
                summary["metadata"] = d["metadata"]
            print(json.dumps(summary))

    def health_check(self) -> bool:
        return True
