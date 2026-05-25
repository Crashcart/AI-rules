from dataclasses import dataclass, field, asdict
from datetime import datetime, timezone
import json


@dataclass
class Envelope:
    schema: str = "pipeline-bus/v1"
    type: str = "binary"
    pipeline_id: str = ""
    source_adapter: str = ""
    timestamp_utc: str = ""
    metadata: dict = field(default_factory=dict)
    payload_ref: str = ""

    def __post_init__(self):
        if not self.timestamp_utc:
            self.timestamp_utc = datetime.now(timezone.utc).isoformat()

    def to_dict(self) -> dict:
        return asdict(self)

    def to_json(self) -> str:
        return json.dumps(self.to_dict(), indent=2)

    @classmethod
    def from_dict(cls, d: dict) -> "Envelope":
        return cls(**{k: v for k, v in d.items() if k in cls.__dataclass_fields__})

    @classmethod
    def from_json(cls, s: str) -> "Envelope":
        return cls.from_dict(json.loads(s))
