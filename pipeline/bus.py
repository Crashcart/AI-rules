#!/usr/bin/env python3
"""
pipeline/bus.py — Pipeline Bus core

Adapter bridge commands (direct source → sink, no broker):
  python pipeline/bus.py run <pipeline-name>
  python pipeline/bus.py list
  python pipeline/bus.py check <pipeline-name>

Broker bridge commands (source → broker topic → any subscriber):
  python pipeline/bus.py bridge <pipeline-name> [--broker http://localhost:4242]
  python pipeline/bus.py topics [--broker http://localhost:4242]
"""

import sys
import signal
import yaml
from pathlib import Path

# Allow running as script (python pipeline/bus.py) or module (python -m pipeline.bus)
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from pipeline.client import BrokerClient, DEFAULT_BROKER

PIPELINES_DIR = Path(__file__).parent / "pipelines"


def load_pipeline(name: str) -> dict:
    path = PIPELINES_DIR / f"{name}.yaml"
    if not path.exists():
        sys.exit(
            f"Pipeline not found: {path}\nRun `python pipeline/bus.py list` to see available pipelines."
        )
    with open(path) as f:
        return yaml.safe_load(f)


def cmd_list():
    files = sorted(PIPELINES_DIR.glob("*.yaml"))
    if not files:
        print("No pipelines found in", PIPELINES_DIR)
        return
    for f in files:
        cfg = yaml.safe_load(f.read_text())
        print(
            f"  {f.stem:20s}  {cfg.get('source', {}).get('adapter', '?')} → {cfg.get('sink', {}).get('adapter', '?')}"
        )


def cmd_check(name: str):
    from pipeline import adapters as reg

    cfg = load_pipeline(name)

    src_id = cfg["source"]["adapter"]
    snk_id = cfg["sink"]["adapter"]
    src = reg.get(src_id)
    snk = reg.get(snk_id)
    src.configure(cfg["source"].get("config", {}))
    snk.configure(cfg["sink"].get("config", {}))

    src_ok = src.health_check()
    snk_ok = snk.health_check()
    print(f"[{name}] source({src_id}): {'OK' if src_ok else 'FAIL'}")
    print(f"[{name}] sink({snk_id}):   {'OK' if snk_ok else 'FAIL'}")
    if not (src_ok and snk_ok):
        sys.exit(1)


def cmd_run(name: str):
    from pipeline import adapters as reg

    cfg = load_pipeline(name)

    src_id = cfg["source"]["adapter"]
    snk_id = cfg["sink"]["adapter"]
    src = reg.get(src_id)
    snk = reg.get(snk_id)
    src.configure(cfg["source"].get("config", {}))
    snk.configure(cfg["sink"].get("config", {}))

    print(f"[bus] pipeline '{name}' started  ({src_id} → {snk_id})")
    print("[bus] Press Ctrl+C to stop.\n")

    def _shutdown(sig, frame):
        print("\n[bus] Stopped.")
        sys.exit(0)

    signal.signal(signal.SIGINT, _shutdown)
    signal.signal(signal.SIGTERM, _shutdown)

    count = 0
    while True:
        envelope = src.read()
        envelope.pipeline_id = name
        snk.write(envelope)
        count += 1


def cmd_bridge(name: str, broker_url: str):
    from pipeline import adapters as reg

    cfg = load_pipeline(name)
    src_id = cfg["source"]["adapter"]
    topic = cfg.get("topic") or cfg.get("sink", {}).get("topic")
    if not topic:
        sys.exit(
            f"Pipeline '{name}' has no topic configured.\n"
            "Add a 'topic:' key to the pipeline YAML."
        )

    src = reg.get(src_id)
    src.configure(cfg["source"].get("config", {}))

    client = BrokerClient(broker_url)
    if not client.health():
        sys.exit(f"Broker unreachable at {broker_url}")

    print(f"[bus] bridge '{name}' started  ({src_id} → broker:{topic})")
    print(f"[bus] Broker: {broker_url}")
    print("[bus] Press Ctrl+C to stop.\n")

    def _shutdown(sig, frame):
        print("\n[bus] Bridge stopped.")
        sys.exit(0)

    signal.signal(signal.SIGINT, _shutdown)
    signal.signal(signal.SIGTERM, _shutdown)

    while True:
        envelope = src.read()
        envelope.pipeline_id = name
        delivered = client.publish(topic, envelope)
        print(f"[bus] published to '{topic}' → {delivered} subscriber(s)")


def cmd_topics(broker_url: str):
    client = BrokerClient(broker_url)
    if not client.health():
        sys.exit(f"Broker unreachable at {broker_url}")
    data = client.topics()
    topics = data.get("topics", {})
    if not topics:
        print(f"No active topics on {broker_url}")
        return
    print(f"Topics on {broker_url}:")
    for name, info in topics.items():
        subs = info.get("subscribers", 0)
        msgs = info.get("messages_published", 0)
        print(f"  {name:30s}  {subs} subscriber(s)  {msgs} published")


def main():
    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print(__doc__.strip())
        sys.exit(0)

    cmd = args[0]

    # Parse --broker option from remaining args
    broker_url = DEFAULT_BROKER
    filtered = []
    i = 1
    while i < len(args):
        if args[i] == "--broker" and i + 1 < len(args):
            broker_url = args[i + 1]
            i += 2
        else:
            filtered.append(args[i])
            i += 1

    if cmd == "list":
        cmd_list()
    elif cmd == "check" and len(filtered) == 1:
        cmd_check(filtered[0])
    elif cmd == "run" and len(filtered) == 1:
        cmd_run(filtered[0])
    elif cmd == "bridge" and len(filtered) == 1:
        cmd_bridge(filtered[0], broker_url)
    elif cmd == "topics" and len(filtered) == 0:
        cmd_topics(broker_url)
    else:
        print(__doc__.strip())
        sys.exit(1)


if __name__ == "__main__":
    main()
