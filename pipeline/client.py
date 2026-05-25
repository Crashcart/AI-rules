"""
pipeline/client.py — Python client for the Pipeline Broker

Publish:
    client = BrokerClient("http://localhost:4242")
    client.publish("my-topic", envelope)

Subscribe (blocking generator):
    for envelope in client.subscribe("my-topic"):
        process(envelope)

Shell (curl):
    Publish: curl -X POST http://localhost:4242/publish/my-topic -d '{"type":"text",...}'
    Subscribe: curl -N http://localhost:4242/subscribe/my-topic
"""

import json
from urllib.request import urlopen, Request
from urllib.error import URLError
from pipeline.envelope import Envelope

DEFAULT_BROKER = "http://localhost:4242"


class BrokerClient:
    def __init__(self, broker_url: str = DEFAULT_BROKER):
        self.broker_url = broker_url.rstrip("/")

    def publish(self, topic: str, envelope: Envelope) -> int:
        url = f"{self.broker_url}/publish/{topic}"
        data = json.dumps(envelope.to_dict()).encode()
        req = Request(
            url, data=data,
            headers={"Content-Type": "application/json"},
            method="POST",
        )
        with urlopen(req, timeout=5) as resp:
            result = json.loads(resp.read())
        return result.get("delivered", 0)

    def subscribe(self, topic: str):
        """Blocking generator — yields Envelopes as they arrive."""
        url = f"{self.broker_url}/subscribe/{topic}"
        with urlopen(url) as resp:
            buf = b""
            while True:
                chunk = resp.read(1)
                if not chunk:
                    break
                buf += chunk
                if buf.endswith(b"\n\n"):
                    line = buf.decode().strip()
                    buf = b""
                    if line.startswith("data: "):
                        data = json.loads(line[6:])
                        yield Envelope.from_dict(data)

    def topics(self) -> dict:
        url = f"{self.broker_url}/topics"
        with urlopen(url, timeout=5) as resp:
            return json.loads(resp.read())

    def health(self) -> bool:
        try:
            with urlopen(f"{self.broker_url}/health", timeout=3) as resp:
                return json.loads(resp.read()).get("status") == "ok"
        except Exception:
            return False
