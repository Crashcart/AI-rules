from pipeline.adapters.file_source import FileSourceAdapter
from pipeline.adapters.http_source import HttpSourceAdapter
from pipeline.adapters.file_sink import FileSinkAdapter
from pipeline.adapters.stdout_sink import StdoutSinkAdapter

REGISTRY: dict = {
    "file-source": FileSourceAdapter,
    "http-source": HttpSourceAdapter,
    "file-sink": FileSinkAdapter,
    "stdout-sink": StdoutSinkAdapter,
}


def get(adapter_id: str):
    if adapter_id not in REGISTRY:
        raise ValueError(
            f"Unknown adapter: '{adapter_id}'. Available: {list(REGISTRY)}"
        )
    return REGISTRY[adapter_id]()
