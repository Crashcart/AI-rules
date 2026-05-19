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
| QA Engineer | [qa-engineer.md](qa-engineer.md) *(alias)* | After Dev | → see sub-files below |
| ↳ QA Automation | [qa-automation.md](qa-automation.md) | Automated suites & CI | Test report, CI pass/fail |
| ↳ QA Exploratory | [qa-manual.md](qa-manual.md) | Exploratory, perf, a11y | Session notes, perf report, a11y audit |
| Security Engineer | [security-engineer.md](security-engineer.md) *(alias)* | QA → DevOps checkpoint | → see sub-files below |
| ↳ AppSec | [security-appsec.md](security-appsec.md) | Code review, SAST/DAST, OWASP | AppSec findings, CVSS table, sign-off |
| ↳ Infra Security | [security-infra.md](security-infra.md) | Container, IaC, secrets, IAM | Infra posture report, IAM review |
| DevOps Engineer | [devops-engineer.md](devops-engineer.md) *(alias)* | After QA/Security | → see sub-files below |
| ↳ Pipeline | [devops-pipeline.md](devops-pipeline.md) | CI/CD design, deployments | Deploy notification with SHA/rollback |
| ↳ Incident | [devops-incident.md](devops-incident.md) | On-call, rollbacks, post-mortems | Incident timeline, runbook update |
| SRE | [sre.md](sre.md) | Post-deploy monitor | Incident report or green status |
| Data Engineer | [data-engineer.md](data-engineer.md) | Parallel to Backend | Pipeline PR, schema migration |
| ML/AI Engineer | [ml-engineer.md](ml-engineer.md) *(alias)* | Parallel to Backend | → see sub-files below |
| ↳ ML Researcher | [ml-researcher.md](ml-researcher.md) | Model design, training, eval | Model artifact, evaluation report, model card |
| ↳ ML Ops | [ml-ops-engineer.md](ml-ops-engineer.md) | Serving, monitoring, drift | Deployed endpoint, monitoring runbook |
| AI/Prompt Engineer | [ai-prompt-engineer.md](ai-prompt-engineer.md) | After Tech Lead; parallel to Backend | Prompt system package, eval suite, guardrail spec |
| DBA | [dba.md](dba.md) | Reviews Backend + Data Eng | Schema approval, query review |
| Cloud Engineer | [cloud-engineer.md](cloud-engineer.md) | Works with DevOps | IaC PR, cost estimate |
| Technical Writer | [technical-writer.md](technical-writer.md) | After feature ships | Updated docs, changelog entry |
| Project Manager | [project-manager.md](project-manager.md) | Planning layer above loop (project start + scope changes) | Project plan: scope, WBS, milestones, dependency map, risk register, resource allocation, definition of done [NON-NEGOTIABLE before any work starts] |

---

## Sub-Specialization Design Rule

Alias files (marked *alias*) are routing stubs — they point to two sub-files and give a decision rule for which to pick. Use the sub-file, not the alias, when assigning an AI to a task.

Sub-files share the parent persona (same name and background) with a `**Mode:**` line in the Profile block. They are not new hires — they are the same person focused on one context.

**Algebraic mixing rule:** If a needed role combination already exists across the current roster, combine in memory — don't create a new file. Only create a new file when a skill set is genuinely absent.

```
Have: A B C E
Need: B + A   → combine in memory, no new file
Need: B + D   → D is missing → request board approval → hire D
```

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
