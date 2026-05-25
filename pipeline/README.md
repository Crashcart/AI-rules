# Pipeline Bus

Universal software interoperability system — make any tool talk to any other tool.

Any program that produces output becomes a **source**. Any program that accepts input becomes a **sink**. The Pipeline Bus routes between them through a universal message format. Programs never need to know about each other.

---

## Architecture

```
[Source Tool] → adapter → [Bus / Broker] → adapter → [Sink Tool]
                                 ↑
                          any subscriber
```

**Two modes:**

- **Linear** — direct source → sink, no broker. Simple, zero infrastructure.
- **Bridge** — source → broker topic → any number of subscribers. MQTT-style pub/sub over HTTP.

---

## Quick Start

### Linear (direct, no broker)

```bash
# 1. Create input directory
mkdir -p /tmp/pipeline-input

# 2. Run the pipeline
python pipeline/bus.py run example

# 3. Drop a file to trigger it
echo '{"hello":"world"}' > /tmp/pipeline-input/test.json
```

### Broker (pub/sub over HTTP)

```bash
# Terminal 1 — start the broker
python pipeline/broker.py

# Terminal 2 — start a source bridge
python pipeline/bus.py bridge example-bridge

# Terminal 3 — subscribe from anywhere (curl, Python, anything)
curl -N http://localhost:4242/subscribe/events

# Drop a file to publish
echo '{"hello":"world"}' > /tmp/pipeline-input/test.json
```

### Docker

```bash
# Build and run the full stack
docker compose -f pipeline/docker-compose.yml up

# Drop a file to test
echo '{"hello":"world"}' > pipeline/input/test.json
```

---

## Commands

```
python pipeline/bus.py list                           # list saved pipelines
python pipeline/bus.py check <name>                  # health-check source + sink
python pipeline/bus.py run   <name>                  # run linear pipeline
python pipeline/bus.py bridge <name> [--broker URL]  # publish source to broker topic
python pipeline/bus.py topics [--broker URL]          # list active topics

python pipeline/broker.py [--host 0.0.0.0] [--port 4242]  # run the broker

python pipeline/configurator.py [--mode linear|bridge]     # interactive setup
```

---

## Broker API

The broker is a plain HTTP server — no special client required.

| Endpoint | Method | Description |
|---|---|---|
| `/health` | GET | `{"status": "ok"}` |
| `/topics` | GET | Active topics + subscriber counts |
| `/publish/<topic>` | POST | Publish an Envelope (JSON body) |
| `/subscribe/<topic>` | GET | SSE stream — yields Envelopes as `data: {...}` |

**Subscribe with curl:**
```bash
curl -N http://localhost:4242/subscribe/my-topic
```

**Publish with curl:**
```bash
curl -X POST http://localhost:4242/publish/my-topic \
  -H "Content-Type: application/json" \
  -d '{"schema":"pipeline-bus/v1","type":"text","payload_ref":"/tmp/file.txt"}'
```

**Subscribe in Python:**
```python
from pipeline.client import BrokerClient
client = BrokerClient("http://localhost:4242")
for envelope in client.subscribe("my-topic"):
    print(envelope.payload_ref)
```

---

## Universal Envelope

Every message is an `Envelope` — a small metadata wrapper. The payload itself is never copied; only its path (or reference) travels through the bus.

```python
@dataclass
class Envelope:
    schema: str = "pipeline-bus/v1"
    type: str = "binary"        # "audio", "text", "image", "json", "binary" — freeform
    pipeline_id: str = ""
    source_adapter: str = ""
    timestamp_utc: str = ""
    metadata: dict = {}         # domain data: bpm, tokens, dimensions, etc.
    payload_ref: str = ""       # path or URI — never inline bytes
```

---

## Adapters

Adapters translate between tool output formats and the universal Envelope.

| ID | Direction | What it does |
|----|-----------|---|
| `file-source` | source | Watches a directory; yields each new file as an Envelope |
| `http-source` | source | Polls an HTTP endpoint; yields each response as an Envelope |
| `file-sink` | sink | Writes the `payload_ref` file to an output directory |
| `stdout-sink` | sink | Prints Envelope metadata to stdout (debug) |

### Writing a custom adapter

```python
from pipeline.adapter import SourceAdapter
from pipeline.envelope import Envelope

class MySourceAdapter(SourceAdapter):
    id = "my-source"

    def configure(self, config: dict) -> None:
        self.url = config["url"]

    def read(self) -> Envelope:
        # Block until data is available
        data = fetch_from_my_tool(self.url)
        return Envelope(type="json", payload_ref=data["path"])
```

Register it in `pipeline/adapters/__init__.py`:
```python
from pipeline.adapters.my_source import MySourceAdapter
REGISTRY["my-source"] = MySourceAdapter
```

---

## Pipeline YAML

Linear:
```yaml
id: my-pipeline
source:
  adapter: file-source
  config:
    watch_dir: /tmp/input
    file_pattern: "*.json"
sink:
  adapter: file-sink
  config:
    output_dir: /tmp/output
```

Bridge (source → broker topic):
```yaml
id: my-bridge
topic: my-events
source:
  adapter: file-source
  config:
    watch_dir: /tmp/input
broker: http://localhost:4242
```

---

## Docker Integration

The broker runs as a standalone HTTP server — drop it into any Docker network:

```yaml
# docker-compose.yml (your project)
services:
  pipeline-broker:
    image: ghcr.io/crashcart/pipeline-broker:latest
    ports:
      - "4242:4242"
```

Then any container in the network can publish or subscribe:
```bash
# From any container
curl -X POST http://pipeline-broker:4242/publish/my-topic -d '...'
curl -N http://pipeline-broker:4242/subscribe/my-topic
```
