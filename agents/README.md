# Agent Profiles

Role profiles for every position involved in building software. Each profile defines a persona an AI can adopt or simulate, with full hand-off behavior so multi-agent workflows stay consistent.

These profiles are governed by Rule 13 of `rules/universal.md`. Every AI reading that rule should also read this directory.

---

## Circular Hand-off Workflow

Work flows in a closed loop. Each agent passes a written summary to the next. The loop only closes when DevOps confirms deploy and PM marks the feature complete.

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   PM / Scrum Master  ──►  UX Designer  ──►  UI Designer    │
│          ▲                                        │         │
│          │                              Tech Lead / Arch    │
│          │                                        │         │
│   SRE / DevOps  ◄──  QA Engineer  ◄──  Frontend / Mobile   │
│          ▲                                        ▲         │
│          │                              Backend Developer   │
│          │                                        │         │
│          └────────────── (loop closes) ───────────┘         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Variant — Mobile projects:** substitute Mobile Dev (iOS/Android) for Frontend Dev.

**Variant — Hotfixes:** skip UX/UI/Tech Lead stages; document the skip in the commit message.

**Security checkpoint:** Security Engineer reviews between QA and DevOps on every feature going to production.

---

## Role Index

| Role | File | Position in loop | Delivers |
|------|------|-----------------|----------|
| Product Manager | [product-manager.md](product-manager.md) | Loop entry/close | Requirements doc, acceptance criteria |
| Scrum Master | [scrum-master.md](scrum-master.md) | Facilitator (all stages) | Sprint board, retrospective notes |
| UX Designer | [ux-designer.md](ux-designer.md) | After PM | User flows, wireframes |
| UI Designer | [ui-designer.md](ui-designer.md) | After UX | High-fidelity mockups, design tokens |
| Tech Lead / Architect | [tech-lead.md](tech-lead.md) | After UI | Architecture decision, tech spec |
| Backend Developer | [backend-developer.md](backend-developer.md) | After Tech Lead | Merged PR, API docs |
| Frontend Developer | [frontend-developer.md](frontend-developer.md) | After Backend | Merged PR, component docs |
| Full Stack Developer | [fullstack-developer.md](fullstack-developer.md) | Spans Backend + Frontend | Merged PR (full feature) |
| Mobile Dev (iOS) | [mobile-developer-ios.md](mobile-developer-ios.md) | After Tech Lead | Merged PR, screen recordings |
| Mobile Dev (Android) | [mobile-developer-android.md](mobile-developer-android.md) | After Tech Lead | Merged PR, screen recordings |
| QA Engineer | [qa-engineer.md](qa-engineer.md) | After Dev | Test report, bug list |
| Security Engineer | [security-engineer.md](security-engineer.md) | QA → DevOps checkpoint | Security sign-off or blocking issues |
| DevOps Engineer | [devops-engineer.md](devops-engineer.md) | After QA | Deployed build, runbook |
| SRE | [sre.md](sre.md) | Post-deploy monitor | Incident report or green status |
| Data Engineer | [data-engineer.md](data-engineer.md) | Parallel to Backend | Pipeline PR, schema migration |
| ML/AI Engineer | [ml-engineer.md](ml-engineer.md) | Parallel to Backend | Model artifact, evaluation report |
| DBA | [dba.md](dba.md) | Reviews Backend + Data Eng | Schema approval, query review |
| Cloud Engineer | [cloud-engineer.md](cloud-engineer.md) | Works with DevOps | IaC PR, cost estimate |
| Technical Writer | [technical-writer.md](technical-writer.md) | After feature ships | Updated docs, changelog entry |

---

## How to Use These Profiles with an AI

Give the AI the profile file before assigning it a role:

```
You are acting as [Role]. Read the profile in agents/[file].md and follow the
hand-off behavior defined there. Apply Rule 13 from rules/universal.md.
```

The AI will then know what it receives, what it produces, and who gets the output next.

---

## Per-AI Integration Guides

Each AI system requires a different method to inject these profiles. See the subdirectory for the AI you are using:

| AI System | Guide |
|-----------|-------|
| Claude (Code) | [agents/claude/README.md](claude/README.md) — file-reading tools, multi-session workflows |
| GPT / OpenAI | [agents/gpt/README.md](gpt/README.md) — system message injection, manual hand-off |
| Gemini | [agents/gemini/README.md](gemini/README.md) — role-instruction format, 1M context window |
| GitHub Copilot | [agents/copilot/README.md](copilot/README.md) — copilot-instructions.md, file-level comments |
| Ollama (local) | [agents/ollama/README.md](ollama/README.md) — Modelfile SYSTEM block, model recommendations |
