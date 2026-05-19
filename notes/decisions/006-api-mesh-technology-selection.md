# ADR-006 — Crashcart API Mesh: Technology Selection

**Author**: Dana Kowalski (Tech Lead)
**Date**: 2026-05-19
**Ticket**: TICK-001
**Status**: Accepted — board approved 2026-05-19

---

## Context

Crashcart needs a language-agnostic event bus and service discovery layer. Any project must be
able to publish events and any other project subscribe, including integrations that were never
pre-planned. Messages must not be dropped if no subscriber exists yet (pass-through queue).

Projects that must integrate: TypeScript (RP-Music-Radio), Python (RPG-Bot),
Shell/Docker (Ollama-intelgpu, Kali-AI-term).

Constraint from TICK-001: evaluate existing solutions before building anything custom.

---

## Candidates Evaluated

### 1. NATS JetStream

**What it is**: Lightweight message broker with a built-in persistence layer (JetStream).
Single static binary. No external dependencies.

| Criterion | Assessment |
|-----------|------------|
| TypeScript client | `nats.ws` / `nats` npm package — mature, well-maintained |
| Python client | `nats-py` — async-native, actively developed |
| Shell/Docker client | `nats` CLI binary + HTTP micro server; `curl` works via NATS REST bridge |
| Persistent queue | JetStream streams — messages survive broker restart |
| Auto-discovery | Subject namespace (`crashcart.>`) — new publishers are immediately routable |
| Docker footprint | ~15 MB image, no Zookeeper, no separate storage engine |
| Operational complexity | Low — single process, flat config file |

**Assessment**: Meets all requirements. Lightest operational footprint of all candidates.

---

### 2. Redis Pub/Sub + Streams

**What it is**: Redis Pub/Sub for fire-and-forget; Redis Streams for persistent queued delivery.

| Criterion | Assessment |
|-----------|------------|
| TypeScript client | `ioredis` / `redis` npm — excellent |
| Python client | `redis-py` — excellent |
| Shell client | `redis-cli` — available everywhere |
| Persistent queue | Redis Streams only — Pub/Sub drops messages if no subscriber is connected |
| Auto-discovery | No native discovery; must implement a registry key convention manually |
| Docker footprint | ~30 MB; well-known image |
| Operational complexity | Medium — Pub/Sub and Streams are separate paradigms; must maintain both or choose one |

**Assessment**: Strong clients but architecturally awkward. Pass-through queuing requires
Streams (not Pub/Sub), and auto-discovery requires a separate convention. Two mental models
for one system. Ruled out in favor of a broker designed for this use case.

---

### 3. MQTT (Mosquitto)

**What it is**: Lightweight pub/sub broker designed for IoT telemetry over constrained networks.

| Criterion | Assessment |
|-----------|------------|
| TypeScript client | `mqtt` npm — functional |
| Python client | `paho-mqtt` — functional |
| Shell client | `mosquitto_pub` / `mosquitto_sub` CLI |
| Persistent queue | QoS 1/2 for in-flight; no durable consumer groups |
| Auto-discovery | No service registry; topic wildcards only |
| Docker footprint | ~10 MB |
| Operational complexity | Low, but limited |

**Assessment**: Designed for device telemetry, not service mesh. No consumer groups means
multiple subscribers can't share load. No built-in service registry. Topic wildcards don't
substitute for discovery. **Ruled out** — wrong problem domain.

---

### 4. Apache Kafka

**What it is**: Distributed event streaming platform. Industry standard for high-throughput logs.

| Criterion | Assessment |
|-----------|------------|
| TypeScript client | `kafkajs` — excellent |
| Python client | `confluent-kafka` / `aiokafka` — excellent |
| Shell client | `kafka-console-producer/consumer` scripts |
| Persistent queue | Yes — partitioned, replicated, configurable retention |
| Auto-discovery | Schema Registry + topic naming convention |
| Docker footprint | ~600 MB (Kafka + KRaft or Zookeeper); multi-container setup |
| Operational complexity | **High** — partitions, consumer groups, offsets, ISR management |

**Assessment**: Correct architecture but wildly over-engineered for Crashcart's scale.
Kafka is designed for millions of events/second across dozens of producers. Crashcart has
≤10 projects and event rates in the tens/minute range. Operational burden is unjustifiable.
**Ruled out** — correct tool, wrong scale.

---

### 5. Consul Connect (service mesh)

**What it is**: Full L7 service mesh — mTLS between services, service discovery, health checks,
traffic policies.

| Criterion | Assessment |
|-----------|------------|
| Event bus | No — Consul is for service discovery and mTLS proxy, not message passing |
| Shell client | Consul CLI — works, but not for events |
| Persistent queue | None |
| Docker footprint | ~80 MB; requires sidecar proxies per service |
| Operational complexity | **Very high** — sidecar injection, certificate rotation, ACL tokens |

**Assessment**: Different problem. Consul solves service-to-service auth and traffic routing,
not async event delivery. **Ruled out** — wrong tool entirely.

---

## Decision

**Selected: NATS JetStream**

Rationale:
1. Only candidate that meets all three core requirements out of the box: pub/sub routing,
   durable queues (JetStream), and language-agnostic clients.
2. Smallest operational footprint — single Docker image, flat config, no sidecars.
3. Shell integration via `nats` CLI binary or the HTTP REST bridge (`nats-server --http`);
   no shell script needs to speak a binary protocol.
4. Subject-based routing (`crashcart.{project}.{event}`) gives free auto-discovery —
   any new project that publishes to a `crashcart.>` subject is immediately reachable
   by any subscriber without registry updates.
5. JetStream streams retain undelivered messages across restarts, satisfying the
   pass-through queuing requirement.

---

## Proposed Subject Namespace

```
crashcart.{project}.{event-type}

Examples:
  crashcart.rpg-bot.character.leveled-up
  crashcart.rp-music-radio.track.started
  crashcart.ollama-intelgpu.model.loaded
  crashcart.kali-ai-term.session.started
```

Wildcard subscriptions:
- `crashcart.>` — all Crashcart events (full mesh view)
- `crashcart.rpg-bot.>` — all events from RPG-Bot
- `crashcart.*.track.>` — track events from any project

---

## Proposed Stack (Docker Compose)

```yaml
services:
  nats:
    image: nats:2-alpine
    command: ["-js", "-m", "8222"]   # JetStream enabled, monitoring on 8222
    ports:
      - "4222:4222"   # client connections
      - "8222:8222"   # HTTP monitoring + REST bridge
    volumes:
      - nats-data:/data
    restart: unless-stopped

volumes:
  nats-data:
```

Shell integration (no binary needed):
```bash
# Publish via HTTP REST bridge
curl -s -d '{"event":"model.loaded","model":"llama3"}' \
  http://localhost:8222/publish/crashcart.ollama-intelgpu.model.loaded
```

---

## Next Steps (WBS 2.x — pending board approval of this ADR)

1. Commit Docker Compose stack to a new `crashcart-mesh` config location (TBD with user)
2. Write TypeScript client wrapper for RP-Music-Radio (Omar hands off to Mia for TS layer)
3. Write Python client wrapper for RPG-Bot (Omar)
4. Document Shell/curl pattern for Ollama-intelgpu and Kali-AI-term (Nadia)
5. Implement demo route: RPG-Bot character event → RP-Music-Radio subscriber

---

*Dana hands back to Simone for board approval of technology selection before any implementation.*
