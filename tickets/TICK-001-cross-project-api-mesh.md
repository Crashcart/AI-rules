# Ticket — Cross-Project API Mesh

**ID**: TICK-001
**Opened by**: claude
**Date**: 2026-05-19
**Priority**: high
**Scope**: other (cross-repo architecture)
**Status**: open

## Description

Design and implement a Crashcart-wide inter-project API mesh: a discovery + event-routing
layer that lets any Crashcart project publish data/events and any other project subscribe,
even when the integration path was not pre-planned. Pass-through routing must work even if
no subscriber exists yet.

## Acceptance criteria

- [ ] Evaluate existing solutions first (NATS, Redis Pub/Sub, MQTT, Apache Kafka, a service
      mesh like Consul Connect) — build nothing from scratch until an existing solution is
      ruled out with a written reason
- [ ] Discovery registry: each Crashcart project can register its available endpoints/events
- [ ] Event bus that routes cross-project messages without hard-coded point-to-point wiring
- [ ] Auto-discovery: new projects register and become reachable from all others automatically
- [ ] Pass-through / queue: if Project A emits an event and no subscriber exists yet, the
      message is queued for future subscribers (not dropped)
- [ ] Language-agnostic: must serve TypeScript (RP-Music-Radio), Python (RPG-Bot),
      Shell/Docker (Ollama-intelgpu, Kali-AI-term)
- [ ] At least one working demo route between two existing Crashcart repos
- [ ] PM (Simone) produces full seven-artifact project plan before any implementation begins

## Context

User directive: "I want everything to automatically mesh together so project A can talk to
project B even though I have not thought of a way to do so." Secondary directive: "if
something exists use it" — prefer proven open-source solutions over custom builds.

Simone must start with role map + workflow design before any code is written. Algebraic
agent mixing applies: use existing agent profiles before requesting new hires.

## Resolution

_To be filled when closed._

## Closed

_To be filled when archived._
