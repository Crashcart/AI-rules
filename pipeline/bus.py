#!/usr/bin/env python3
"""
pipeline/bus.py — Pipeline Bus core

Usage:
  python pipeline/bus.py run <pipeline-name>
  python pipeline/bus.py list
  python pipeline/bus.py check <pipeline-name>
"""

import sys
import signal
import yaml
from pathlib import Path

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


def main():
    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print(__doc__.strip())
        sys.exit(0)

    cmd = args[0]
    if cmd == "list":
        cmd_list()
    elif cmd == "check" and len(args) == 2:
        cmd_check(args[1])
    elif cmd == "run" and len(args) == 2:
        cmd_run(args[1])
    else:
        print(__doc__.strip())
        sys.exit(1)


if __name__ == "__main__":
    main()
