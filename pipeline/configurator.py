#!/usr/bin/env python3
"""
pipeline/configurator.py — Interactive pipeline setup

Usage:
  python pipeline/configurator.py
  python pipeline/configurator.py --mode bridge   # source → broker topic
  python pipeline/configurator.py --mode linear   # source → sink (direct)
"""

import sys
import argparse
from pathlib import Path
import yaml

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from pipeline.adapters import REGISTRY

PIPELINES_DIR = Path(__file__).parent / "pipelines"


def _select(prompt: str, choices: list) -> str:
    print(f"\n{prompt}")
    for i, c in enumerate(choices, 1):
        print(f"  {i}) {c}")
    while True:
        raw = input("  > ").strip()
        if raw.isdigit() and 1 <= int(raw) <= len(choices):
            return choices[int(raw) - 1]
        print(f"  Enter a number 1–{len(choices)}")


def _collect_config(adapter_id: str) -> dict:
    """Ask for key=value pairs until blank line."""
    from pipeline.adapters import get

    adapter = get(adapter_id)
    hints = getattr(adapter, "config_hints", {})
    if not hints:
        return {}

    print(f"\n  Config for '{adapter_id}':")
    cfg = {}
    for key, hint in hints.items():
        val = input(f"    {key} ({hint}): ").strip()
        if val:
            cfg[key] = val
    return cfg


def main():
    parser = argparse.ArgumentParser(description="Interactive pipeline configurator")
    parser.add_argument(
        "--mode",
        choices=["linear", "bridge"],
        default=None,
        help="linear: source→sink direct  bridge: source→broker topic",
    )
    args = parser.parse_args()

    sources = [k for k, v in REGISTRY.items() if hasattr(v, "read")]
    sinks = [k for k, v in REGISTRY.items() if hasattr(v, "write")]

    print("\n=== Pipeline Configurator ===\n")

    mode = args.mode
    if mode is None:
        mode = _select(
            "Mode:",
            ["linear (source → sink, no broker)", "bridge (source → broker topic)"],
        )
        mode = "linear" if mode.startswith("linear") else "bridge"

    src_id = _select("Source adapter:", sources)
    src_cfg = _collect_config(src_id)

    if mode == "linear":
        snk_id = _select("Sink adapter:", sinks)
        snk_cfg = _collect_config(snk_id)
    else:
        topic = input("\n  Broker topic name: ").strip() or "pipeline"
        broker = (
            input("  Broker URL [http://localhost:4242]: ").strip()
            or "http://localhost:4242"
        )

    default_name = f"{src_id}-pipeline"
    name = input(f"\n  Pipeline name [{default_name}]: ").strip() or default_name
    name = name.replace(" ", "-").lower()

    PIPELINES_DIR.mkdir(exist_ok=True)
    out_path = PIPELINES_DIR / f"{name}.yaml"

    if mode == "linear":
        cfg = {
            "id": name,
            "source": {"adapter": src_id, "config": src_cfg},
            "sink": {"adapter": snk_id, "config": snk_cfg},
        }
        run_cmd = f"python pipeline/bus.py run {name}"
    else:
        cfg = {
            "id": name,
            "topic": topic,
            "source": {"adapter": src_id, "config": src_cfg},
            "broker": broker,
        }
        run_cmd = f"python pipeline/bus.py bridge {name} --broker {broker}"

    with open(out_path, "w") as f:
        yaml.dump(cfg, f, default_flow_style=False)

    print(f"\n✓ Saved to {out_path}")
    print(f"\nRun it:  {run_cmd}")
    if mode == "bridge":
        print(f"Broker:  python pipeline/broker.py  (start this first)")
        print(f"Subscribe (curl):  curl -N {broker}/subscribe/{topic}")


if __name__ == "__main__":
    main()
