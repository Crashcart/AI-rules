# Agent Orchestration Rules
version: 1.4.1 | applies-to: all | parent: universal.md

Extracted from universal.md RULE 13. This file governs multi-agent coordination — how AI agents
hand work off to each other. Behavioral rules for individual AIs remain in universal.md.

---

## RULE 13 — AGENT CIRCULAR HAND-OFF WORKFLOW

When multiple AI agents collaborate on a software project, pass work in this closed loop. Do not skip stages without documenting the reason in the commit message or hand-off summary.

```
PM / Scrum Master  →  UX Designer  →  UI Designer
        ↑                                        ↓
   SRE / DevOps                       Tech Lead / Architect
        ↑                                        ↓
     QA Engineer  ←  Frontend/Mobile Dev  ←  Backend Dev
```

**Hand-off rules:**
- Each agent delivers a written summary: what changed, what the next agent needs to know, and any open blockers.
- QA reports defects back to the originating Dev — not directly to PM.
- Security Engineer reviews between QA and DevOps before any production deploy.
- The loop closes when DevOps confirms successful deploy and PM marks the feature complete.
- For mobile projects, substitute Mobile Dev (iOS/Android) for Frontend Dev.
- Agents may be skipped for hotfixes; document the skip reason in the commit message.

**Purpose:** Consistent hand-off order prevents dropped context, duplicate work, and unreviewed deploys. Any AI operating as one of these roles must follow this sequence unless the product team defines a different order in `CLAUDE.md`.

Role profiles with full hand-off behavior: see `agents/` directory and `agents/README.md`.
