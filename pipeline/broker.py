#!/usr/bin/env python3
"""
pipeline/broker.py — HTTP pub/sub message broker

Endpoints:
  POST /publish/<topic>   — publish an Envelope (JSON body)
  GET  /subscribe/<topic> — SSE stream of Envelopes on this topic
  GET  /topics            — active topics + subscriber counts
  GET  /health            — {"status": "ok"}

Run:  python pipeline/broker.py [--host 0.0.0.0] [--port 4242]
Docker: docker run -p 4242:4242 pipeline-broker
"""

import sys
import json
import queue
import threading
import argparse
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


_topics: dict = {}
_topics_lock = threading.Lock()


class _Topic:
    def __init__(self, name: str):
        self.name = name
        self._lock = threading.Lock()
        self._subscribers: list = []

    def subscribe(self) -> queue.Queue:
        q: queue.Queue = queue.Queue(maxsize=1000)
        with self._lock:
            self._subscribers.append(q)
        return q

    def unsubscribe(self, q: queue.Queue) -> None:
        with self._lock:
            try:
                self._subscribers.remove(q)
            except ValueError:
                pass

    def publish(self, data: dict) -> int:
        with self._lock:
            subs = list(self._subscribers)
        for q in subs:
            try:
                q.put_nowait(data)
            except queue.Full:
                pass  # slow subscriber — drop, never block publisher
        return len(subs)

    @property
    def count(self) -> int:
        with self._lock:
            return len(self._subscribers)


def _get_or_create(name: str) -> _Topic:
    with _topics_lock:
        if name not in _topics:
            _topics[name] = _Topic(name)
        return _topics[name]


class _Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        print(f"[broker] {self.address_string()} — {fmt % args}")

    def do_GET(self):
        if self.path == "/health":
            self._json(200, {"status": "ok"})
        elif self.path == "/topics":
            with _topics_lock:
                payload = {
                    name: {"subscribers": t.count}
                    for name, t in _topics.items()
                }
            self._json(200, payload)
        elif self.path.startswith("/subscribe/"):
            topic_name = self.path[len("/subscribe/"):]
            self._sse(topic_name)
        else:
            self._json(404, {"error": "not found"})

    def do_POST(self):
        if self.path.startswith("/publish/"):
            topic_name = self.path[len("/publish/"):]
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length)
            try:
                data = json.loads(body)
            except json.JSONDecodeError as e:
                self._json(400, {"error": f"invalid JSON: {e}"})
                return
            topic = _get_or_create(topic_name)
            delivered = topic.publish(data)
            self._json(200, {"topic": topic_name, "delivered": delivered})
        else:
            self._json(404, {"error": "not found"})

    def _json(self, status: int, payload: dict) -> None:
        body = json.dumps(payload).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def _sse(self, topic_name: str) -> None:
        topic = _get_or_create(topic_name)
        q = topic.subscribe()
        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-cache")
        self.send_header("Connection", "keep-alive")
        self.end_headers()
        try:
            while True:
                try:
                    data = q.get(timeout=15)
                    msg = f"data: {json.dumps(data)}\n\n"
                    self.wfile.write(msg.encode())
                    self.wfile.flush()
                except queue.Empty:
                    self.wfile.write(b": keepalive\n\n")
                    self.wfile.flush()
        except (BrokenPipeError, ConnectionResetError):
            pass
        finally:
            topic.unsubscribe(q)


def main():
    parser = argparse.ArgumentParser(description="Pipeline pub/sub broker")
    parser.add_argument("--host", default="0.0.0.0")
    parser.add_argument("--port", type=int, default=4242)
    args = parser.parse_args()

    server = ThreadingHTTPServer((args.host, args.port), _Handler)
    print(f"[broker] listening on {args.host}:{args.port}")
    print("[broker] Press Ctrl+C to stop.\n")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n[broker] stopped.")


if __name__ == "__main__":
    main()
