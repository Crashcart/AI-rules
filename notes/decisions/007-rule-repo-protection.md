# ADR 007 — Rule Repo Protection and One-Way Rule Flow

**Date:** 2026-05-25
**Status:** Accepted
**Rule:** RULE 22 (universal.md)

---

## Context

AI-rules is embedded into project fork repos as a git subtree at `.ai-rules/`. This gives fork repos local access to all rule files, which is necessary for session-start hooks to work. However, it raises a governance question: can a fork repo modify `.ai-rules/` and push changes back? And can a GitHub fork of AI-rules itself open a PR that merges rule changes without user review?

The user's directive: **rules are always protected — no fork can pull changes into the canonical repo**.

---

## Decision

Rules flow **one direction only**: canonical AI-rules repo → fork/project repos. Never the reverse.

Three enforcement layers:

1. **Git subtree semantics**: `.ai-rules/` in a fork is a squashed subtree prefix. Any local edits inside it are overwritten on the next `git subtree pull`. There is no mechanism for a fork to push changes back without an explicit `git subtree push` — which no automated workflow performs.

2. **RULE 22 (universal.md)**: Makes the one-way flow explicit as a `[NON-NEGOTIABLE]` rule. Any AI reading these rules in a fork is prohibited from editing `.ai-rules/` and must route rule changes to the canonical repo.

3. **GitHub branch protection on `main`**: Prevents any fork-originated PR from merging without explicit user review. This is manual setup (GitHub Settings → Branches → Add rule for `main`). Required — not optional.

---

## Override principle

When any rule or config defined locally in a fork conflicts with content in `.ai-rules/rules/`, the `.ai-rules/` version wins. Local overrides are temporary and will be lost on the next subtree pull.

---

## Consequences

- Fork repos must treat `.ai-rules/` as read-only at all times.
- Rule changes require: edit in canonical AI-rules → push to `main` → `git subtree pull` in each fork.
- GitHub branch protection on `main` of the canonical repo is a prerequisite for this policy to hold at the platform level.
- The `.github/` integration and side-mesh insert (planned, not yet started) must respect this one-way flow — they pull from `.ai-rules/`, they do not write back to it.

---

## What is NOT decided here

- `.github/` integration design (planned — separate ADR when started)
- Side-mesh insert design (planned — separate ADR when started)
