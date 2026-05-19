# TICK-001 — Crashcart API Mesh: Project Plan

**PM**: Simone Adler
**Date**: 2026-05-19
**Ticket**: TICK-001
**Status**: Draft — awaiting user approval before any implementation begins

---

## Artifact 1 — Scope Statement

**Goal**: Build a language-agnostic, Crashcart-wide event bus and service discovery layer that lets any project publish data or events and any other project subscribe, including projects whose integration was never pre-planned.

**In scope**:
- Discovery registry (projects register their available endpoints/event topics)
- Event bus with pub/sub routing (no hard-coded point-to-point wiring)
- Pass-through queuing (messages are not dropped if no subscriber exists yet)
- Client libraries or documented integration patterns for TypeScript, Python, and Shell/Docker
- One working demo route between two existing Crashcart repos

**Out of scope** (Phase 1):
- Authentication/authorization between services (deferred to Phase 2)
- GUI dashboard for mesh topology (deferred to Phase 2)
- SLA guarantees / HA clustering (deferred to Phase 2)

---

## Artifact 2 — Work Breakdown Structure

```
API Mesh
├── 1. Technology Selection
│   ├── 1.1 Evaluate NATS JetStream
│   ├── 1.2 Evaluate Redis Pub/Sub + Streams
│   ├── 1.3 Evaluate MQTT (Mosquitto)
│   ├── 1.4 Evaluate Apache Kafka
│   ├── 1.5 Write ADR with selection + rejection reasons
│   └── 1.6 Board approval of selection
├── 2. Core Infrastructure
│   ├── 2.1 Docker Compose stack (broker + registry)
│   ├── 2.2 Service discovery schema (JSON, per-project)
│   ├── 2.3 Auto-registration on container start
│   └── 2.4 Pass-through queue configuration
├── 3. Client Integration
│   ├── 3.1 TypeScript client (RP-Music-Radio)
│   ├── 3.2 Python client (RPG-Bot)
│   └── 3.3 Shell/Docker client pattern (Ollama-intelgpu, Kali-AI-term)
├── 4. Demo Route
│   ├── 4.1 Define demo event: RPG-Bot → RP-Music-Radio
│   ├── 4.2 Implement publisher in RPG-Bot
│   └── 4.3 Implement subscriber in RP-Music-Radio
└── 5. Documentation
    ├── 5.1 Integration guide per language
    ├── 5.2 How to add a new project to the mesh
    └── 5.3 Runbook: restart, recover, inspect queued messages
```

---

## Artifact 3 — Milestones

| # | Milestone | Deliverable | Depends on |
|---|-----------|-------------|------------|
| M1 | Technology selected | ADR + board approval | — |
| M2 | Core stack running | Docker Compose stack, registry endpoint | M1 |
| M3 | TS client integrated | RP-Music-Radio publishes/subscribes | M2 |
| M4 | Python client integrated | RPG-Bot publishes/subscribes | M2 |
| M5 | Shell/Docker pattern documented | Ollama + Kali can integrate | M2 |
| M6 | Demo route live | RPG-Bot event received by RP-Music-Radio | M3, M4 |
| M7 | Documentation complete | Integration guide, runbook | M6 |

---

## Artifact 4 — Dependency Map

```
Board approval (M1)
    └─→ Docker stack (M2)
            ├─→ TS client (M3) ──┐
            ├─→ Python client (M4) ─┼─→ Demo route (M6) → Docs (M7)
            └─→ Shell pattern (M5) ─┘
```

External dependencies:
- Docker and Docker Compose available on all Crashcart host machines
- Selected broker image available on Docker Hub (no private registry in Phase 1)
- GitHub MCP access to RP-Music-Radio and RPG-Bot repos for integration commits

---

## Artifact 5 — Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Selected broker too complex for Shell integration | Medium | High | Prefer brokers with HTTP API fallback (NATS, Redis) |
| Existing repos have no integration points defined | High | Medium | Start with a synthetic event (e.g., "song played") — no app logic change needed |
| Docker not available on Kali-AI-term | Low | Low | Shell client uses broker HTTP API over curl |
| PAT / network access blocks cloning mesh repo | Low | High | All mesh config lives in this repo; no extra clone needed |
| User changes scope mid-implementation | High | Medium | Deliver M1–M2 first for explicit approval before coding client libs |

---

## Artifact 6 — Resource Allocation

| Role | Agent | Task |
|------|-------|------|
| PM | Simone Adler | Plan, milestones, scope control |
| Tech Lead | Dana Kowalski | ADR, architecture review, broker selection |
| Backend Dev | Omar Hassan | TypeScript + Python client libs, Docker stack |
| DevOps (Pipeline) | devops-pipeline | Docker Compose stack, CI integration |
| Technical Writer | Nadia Okafor | Integration guide, runbook |
| QA (Automation) | qa-automation | Integration test between RPG-Bot and RP-Music-Radio |

No new hires. All roles covered by existing agent roster.

---

## Artifact 7 — Definition of Done

The API mesh is done when:

- [ ] Technology ADR is written and board-approved
- [ ] Docker Compose stack starts with one command on any Crashcart machine
- [ ] A TypeScript project can publish an event in ≤ 10 lines of code
- [ ] A Python project can subscribe to an event in ≤ 10 lines of code
- [ ] Shell/Docker projects have a documented curl-based integration pattern
- [ ] A live demo event flows from RPG-Bot to RP-Music-Radio and is logged on receipt
- [ ] Pass-through queue holds at least one undelivered message across a broker restart
- [ ] Integration guide covers: setup, publish, subscribe, add a new project
- [ ] Runbook covers: restart broker, inspect queued messages, drain a queue

---

*Simone hands off to Dana (Tech Lead) for broker selection and ADR drafting (WBS 1.1–1.5).*
*No code is written until the user approves this plan and the ADR is complete.*
