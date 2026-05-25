from abc import ABC, abstractmethod
from pipeline.envelope import Envelope


class Adapter(ABC):
    id: str = ""
    direction: str = ""  # "source" | "sink"

    @abstractmethod
    def configure(self, config: dict) -> None:
        """Apply configuration dict from pipeline YAML."""

    def health_check(self) -> bool:
        return True


class SourceAdapter(Adapter):
    direction = "source"

    @abstractmethod
    def read(self) -> Envelope:
        """Block until data is available; return one Envelope."""


class SinkAdapter(Adapter):
    direction = "sink"

    @abstractmethod
    def write(self, envelope: Envelope) -> None:
        """Consume one Envelope."""
