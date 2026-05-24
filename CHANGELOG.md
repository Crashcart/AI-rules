# Changelog

Newest entries first. Format: `[VERSION] DATE — description`

---

## [1.22.1] 2026-05-24

**Rationale**: No dedicated rulemaker role existed — the function of drafting, versioning, and conflict-checking rules was distributed informally. RULE ARCHITECT centralizes that function with a clear scope: proposes but never self-approves (RULE 17), and is the designated owner of rule quality before user review.

### Added

- `agents/rule-architect.md` — Vera Okonkwo, RULE ARCHITECT; specialties: rule drafting, rule system design, version governance, conflict detection, cross-model validation, rule deprecation; scope: proposes rules via ticket protocol, does not modify `rules/*.md` directly
- `demo/complex-showcase.html` — NEXUS UI component library showcase built on the gold design system; all required components: nav, hero, stats, feature grid, SVG charts, tabs, accordion, pricing toggle, testimonials carousel, search/filter catalog, contact form, toast system, modal dialog, footer; WCAG 2.1 AA, prefers-reduced-motion, SVG-first, IntersectionObserver scroll reveals

### Notes

- SHA256 unchanged: `87550dd13ec670e42397d15eaff1ff17cec7d7436775c75fa3bf5f70d4b4510a` (no `rules/*.md` modified)
- RULE ARCHITECT operates under RULE 16 (hire approved by user) and RULE 17 (cannot self-approve rule changes)

---

## [1.22.0] 2026-05-23

**Rationale**: Leaderboard and leader features without shareable URLs have zero social reach — they cannot be linked, bookmarked, or shared. URL-addressability for all leaderboard entries is now a non-negotiable requirement for any game website delivered by any AI in this system.

### Added

- `rules/web-design.md` § Game Website Standards — **URL Requirements [NON-NEGOTIABLE]**: every leaderboard entry requires a deep-link URL, `history.pushState`/hash routing so browser back button works, copy-pasteable URLs that load the correct view in a new tab, and `<link rel="canonical">` per player view
- `rules/web-design.md` § Game Landing Page Checklist — above-fold CTA, leaderboard rows with `<a href>` deep-links per row, `Intl.NumberFormat` score display, game embed or play link, Open Graph tags (`og:title`, `og:description`, `og:image`)

### Notes

- SHA256 updated: `87550dd13ec670e42397d15eaff1ff17cec7d7436775c75fa3bf5f70d4b4510a`
- Game Website Standards and URL Requirements are `[NON-NEGOTIABLE]`; Game Landing Page Checklist items are `[DEFAULT, overridable]` where user specifies

---

## [1.21.0] 2026-05-23

**Rationale**: Agents had no standardized output format to confirm their compliance state at session start. Adding a mandatory `STARTUP` block (ROLE, RULES version match, PROFILE existence, ACK status) gives the user an instant audit signal on every first response. Hiring Priya Nair as AI Compliance Engineer closes the gap between written rules and actual AI behavior.

### Added

- `rules/startup-checklist.md` — mandatory `STARTUP` output block every AI must print before the first substantive response; covers ROLE, RULES version/match, PROFILE existence, ACK status, and STATUS flag; `[NON-NEGOTIABLE]`
- `agents/ai-compliance-engineer.md` — Priya Nair, AI Compliance Engineer; specialties: session-start compliance auditing, cross-model rule validation, behavioral regression testing, rule clarity analysis

### Notes

- SHA256 unchanged: `acbd177d90481275393ddbe590f7a8b0f9d668b6b9ee795c15a63ea4ca349c5e` — `startup-checklist.md` was already on disk when v1.20.1 SHA was computed
- agents/registry.json updated; session-start integrity check now expects ai-compliance-engineer.md

---

## [1.20.1] 2026-05-23

**Rationale**: RULE 19 language tightened to make compliance non-negotiable ("These are not optional"); injection table now includes the `scripts/ai-bootstrap.sh` row for new/unknown AI types. ROLE ANNOUNCEMENT enforcement changed from `[DEFAULT, overridable]` to `[NON-NEGOTIABLE]` — role announcements are the user's primary compliance-detection signal and must not be skipped by any agent.

### Changed

- `rules/universal.md` § RULE 19 — added "These are not optional" enforcement language; bolded **Claude Code** / **All other AIs** in Check 2 for clarity; added `| New / unknown AI type | Run \`scripts/ai-bootstrap.sh {ai-id}\` |` row to injection table
- `rules/claude-behavior.md` § ROLE ANNOUNCEMENT — tag changed from `[DEFAULT, overridable — user can disable with "skip role announcements"]` to `[NON-NEGOTIABLE]`; role announcements are mandatory for all agents with no opt-out

### Notes

- SHA256 changed: `acbd177d90481275393ddbe590f7a8b0f9d668b6b9ee795c15a63ea4ca349c5e`
- Any agent with 1.20.0 SHA in ack file will trigger re-read on next session start

---

## [1.20.0] 2026-05-23

**Rationale**: When a new AI (GPT, Gemini, Ollama, or any future model) loads into the Crashcart system, it had no automated way to detect rule updates or bootstrap its own rules file if missing. This version adds RULE 19 to `rules/universal.md` — a mandatory session-start check covering (1) version verification on every load and (2) auto-bootstrap if the AI's rules file doesn't exist. GPT and Gemini rules files now include explicit SESSION START CHECK and HIGHEST-LEVEL INJECTION sections. A bootstrap template and CLI script make onboarding any new AI type a one-command operation.

### Added

- `rules/universal.md` § RULE 19 — AI BOOTSTRAP AND SESSION-START CHECK: version verification on every load; bootstrap procedure for missing rules files; highest-available-level injection table per AI type
- `templates/ai-rules-bootstrap.md` — skeleton template for onboarding new AI types; fill `{AI_NAME}`, `{AI_ID}`, `{APPLIES_TO}`, `{GRAMMAR_NOTE}` placeholders and all sections are pre-wired to the correct universal.md rules
- `scripts/ai-bootstrap.sh` — CLI tool to initialize any new AI in one command: creates `rules/{ai-id}.md` from template and `acknowledgments/{ai-id}.ack.json` with `"version": "pending"`, prints injection instructions per AI type

### Changed

- `rules/gpt.md` — added SESSION START CHECK (version comparison + ask user for update if stale) and HIGHEST-LEVEL INJECTION (Custom Instructions for ChatGPT chat; system message for API)
- `rules/gemini.md` — added SESSION START CHECK (same pattern as GPT) and HIGHEST-LEVEL INJECTION (Gem instructions for Gemini Advanced; `system_instruction` for Gemini API)

### Notes

- SHA256 changed: `ae6bb5d663484ca3a603abd6afbeb2491dc08999e0ee250a0eab93c09a9d7465` — `rules/universal.md`, `rules/gpt.md`, and `rules/gemini.md` were all modified
- Session start integrity check will trigger on next load for any AI with the old SHA in its ack file
- `scripts/ai-bootstrap.sh`: refuses to overwrite existing rules files; safe to run on any new AI ID

---

## [1.19.0] 2026-05-23

**Rationale**: When a role is re-opened for hiring, the current incumbent should be benchmarked against the new candidate pool — otherwise there is no way to confirm that the replacement is demonstrably stronger. This formalizes that rule. The hired roster documents all 31 active agents as confirmed hires, establishing a clear record of who is on the roster and by what method they were approved.

### Added

- `hiring/hired-roster.md` — authoritative confirmed-hire record for all 31 registry entries: agent file, name, location, years of experience, mode/notes, hire method (pre-pool vs. formal pool), and pool archive reference. Kai Nakamura is the only formal-pool hire; all others are retroactively confirmed pre-pool hires with agent profile as the record.

### Changed

- `hiring/process.md` § 1 Pool Generation — added rule: if the role has a current incumbent, include them as Candidate #1 in the pool, scored on the same code test and scenario as all other candidates; establishes performance benchmark and ensures replacement is demonstrably stronger
- `agents/hiring-manager.md` Candidate Pool Process — added bullet formalizing the incumbent-as-Candidate-#1 requirement

### Notes

- SHA256 unchanged: `b3a41465ba975e6e298a23a008dedf42157b1f54223faede40cd8a457e5d883e` — no `rules/*.md` files modified
- `hiring/hired-roster.md`: routing alias files (devops-engineer, ml-engineer, qa-engineer, security-engineer) are listed as non-hires; their sub-mode files are the actual confirmed profiles
- Multi-mode agents (Jake Moreau, Alexei Volkov, Sofia Reyes, Ingrid Svensson) are hired once; mode files represent specialization boundaries for the same individual

---

## [1.18.0] 2026-05-23

**Rationale**: The user's /goal required gold aesthetic and production-readiness as a formal rule. Web design work produced without a standard has no defined aesthetic baseline and no checklist — resulting in inconsistent output. This rule codifies the gold design system token palette, a 10-item production-readiness checklist, and an SVG-first graphics policy. The reference implementation at `demo/web-design-showcase.html` gives every role a concrete pattern library to work from.

### Added

- `rules/web-design.md` — Web Design Standards rule covering: gold design system (CSS custom property tokens for color and typography), 10-item production-readiness checklist (performance, accessibility, responsive, reduced-motion, SVG-first, semantic HTML, no inline styles, scroll behavior, font loading, self-contained output), SVG graphics policy, demo reference pointer
- `demo/web-design-showcase.html` — reference implementation: luxury landing page for "AURUM — Digital Craft Studio" demonstrating the gold palette, Cormorant Garamond + Inter typography, inline SVG graphics (logo, hero background, project mockups, service icons), IntersectionObserver scroll reveals, CSS marquee, nav backdrop blur, responsive layout at 900px breakpoint

### Notes

- SHA256 updated: `b3a41465ba975e6e298a23a008dedf42157b1f54223faede40cd8a457e5d883e` — any AI that cached the v1.17.0 hash will re-read rules/ on next session start
- `rules/web-design.md`: gold palette and SVG-first policy are [NON-NEGOTIABLE]; individual checklist items are [DEFAULT, overridable] where user specifies otherwise
- `demo/web-design-showcase.html`: reference only, no behavior enforcement

---

## [1.17.0] 2026-05-23

**Rationale**: 13 agent profiles were built across multiple versions without backfilling the sections added in later profile standards (Thinking Process, Role Scope, Escalation Triggers). Without Role Scope and Escalation Triggers, a role has no defined boundaries and no hand-off chain — it will make calls it shouldn't and hold work it should route. Thinking Process documents the 5-step reasoning sequence each role follows before acting.

### Changed

- `agents/tech-lead.md` — added Thinking Process (5 steps: constraint landscape first, all viable options, failure modes, ADR before code, flag scope boundaries); Role Scope (architecture layer only, explicit limits on production code, product decisions, security approval, hiring); Escalation Triggers (CEO for org-wide decisions, Project Manager for milestone risk, Security Engineer for auth/secrets decisions, Hiring Manager for skill gaps)
- `agents/scrum-master.md` — added Thinking Process (5 steps: blocked items first, name owner, route to resolver, track retro actions, cut product/tech debates); Role Scope (facilitator only, no authority over any role, no product/tech/hiring decisions); Escalation Triggers (Project Manager for milestone threats, Tech Lead for technical impediments, Product Manager for scope decisions)
- `agents/dba.md` — added Thinking Process (5 steps: query patterns before schema, volume at 10x, migration path in parallel, database constraints over application, document rationale); Role Scope (database layer only, no API contracts, no production deploys, no DB engine selection, no monitoring infra); Escalation Triggers (Tech Lead for cross-service schema decisions, DevOps for infra-dependent migrations, Backend for API-impacting schema changes)
- `agents/data-engineer.md` — added Thinking Process (5 steps: data contract first, lineage mapping, design for failure, batch default, real-data testing); Role Scope (pipeline layer only, no transactional schema changes, no ML model design, no serving infra, no raw prod data without DBA approval); Escalation Triggers (DBA for schema/read pattern changes, Tech Lead for cross-service architecture, ML Researcher for feature engineering, PM/Tech Lead for SLA failures)
- `agents/ai-prompt-engineer.md` — added Thinking Process (5 steps: spec before prompt, treat as code change, separate instruction layers, adversarial testing, context window as budget); Role Scope (prompt/AI pipeline layer only, no unilateral model selection, no serving infra, no API contracts, no fine-tuning without ML Researcher); Escalation Triggers (Tech Lead for cross-service prompt architecture, ML Researcher for fine-tuning signals, Backend for API contract changes, Security AppSec for PII/auth surfaces)
- `agents/devops-pipeline.md` — added Thinking Process (5 steps: map delivery path, rollback before deploy, verify secret via operation, stage before production, instrument before ship)
- `agents/devops-incident.md` — added Thinking Process (5 steps: restore first then root cause, blast radius before acting, 15-min cadence updates, timeline before post-mortem, every incident updates runbook)
- `agents/security-appsec.md` — added Thinking Process (5 steps: trust boundary first, follow data not code, classify blocking vs. advisory before writing, reproduce before reporting, remediation steps not just findings)
- `agents/security-infra.md` — added Thinking Process (5 steps: enumerate attack surface before scanning, exposed secrets are P0, blast radius determines severity, separate bad-now from bad-if-exploited, verify fix not just config)
- `agents/qa-automation.md` — added Thinking Process (5 steps: critical paths before tests, test at behavior layer, flaky tests are bugs, gate on behavior not coverage, test suite is a product)
- `agents/ml-ops-engineer.md` — added Thinking Process (5 steps: serving contract before deploy, shadow mode before production, instrument drift before it matters, rollback is a command not procedure, evaluation report is the gate)
- `agents/ml-researcher.md` — added Thinking Process (5 steps: problem formulation before model, baselines before experiments, document failure modes, confidence intervals not point estimates, separate experiment from artifact)
- `agents/project-manager.md` — added Escalation Triggers section (CEO for user-approval decisions, Tech Lead for technical risk to schedule, Product Manager for scope priority calls, Hiring Manager for skill gaps)

### Notes

- No `rules/*.md` files modified — SHA256 unchanged: `c9ee51402c14d9f5091ae09158679d2b65ac6fcc6545688289af652d5278131b`
- `agents/tech-lead.md`: Role Scope now explicitly limits Dana from writing production code — sessions using Tech Lead for implementation should shift to a developer role
- `agents/scrum-master.md`: Role Scope explicitly removes authority over product and technical decisions — Amara routes, she does not decide

---

## [1.16.0] 2026-05-22

**Rationale**: The hiring process had no code quality gate — candidates were evaluated on scenario responses alone, which tests domain knowledge but not whether they can write correct, tight code. Adding a mandatory pre-qualification code test as Step 0 ensures every candidate who reaches the scenario interview has already demonstrated they can produce working implementations with minimal errors.

### Added
- `hiring/test-bank.md` — pre-qualification code tests for all 11 role categories. Each test has: task description, requirements, strong answer criteria, weak answer criteria. Pass threshold: 10/20. Scoring dimensions: Correctness, Code Quality, Error Handling, Performance (1–5 each, max 20).

### Changed
- `hiring/process.md` — inserted **Step 0 — Pre-Qualification Code Test** before pool generation; code test scoring table format added; candidates below 10/20 are recorded but do not advance to scenario interview [NON-NEGOTIABLE]
- `hiring/pools/audio-streaming-engineer.md` — retroactive code test results added for all 7 candidates; combined rankings table (code + scenario, max 35); Kai Nakamura confirmed finalist with 34/35 combined. Notable: Chen Wei ranks 2nd on code (17/20) despite 9/15 scenario — stronger coder than incident responder.
- `agents/hiring-manager.md` — Candidate Pool Process section updated: code pre-qualification test now listed as the first requirement before scenario testing; rubric section updated to reference both test dimensions

---

## [1.15.0] 2026-05-22

**Rationale**: All previous hires were created by generating a single candidate profile — no competitive pool, no evaluation rubric, no scenario testing. This adds a mandatory evaluation framework so future hires are chosen from a realistic pool of candidates assessed for competence, efficiency, and code quality.

### Added
- `hiring/process.md` — end-to-end pool evaluation procedure: pool generation rules (7–10 candidates, global distribution), scenario administration, scoring rubric (Competence/Efficiency/Quality 1–5 each, max 15), selection decision format, archive requirements
- `hiring/scenario-bank.md` — role-appropriate test scenarios for all 11 role categories: Infrastructure, Backend, Frontend, Design, Data/ML, Quality, Security, Streaming/Media, Management, Documentation, Database. Each scenario includes a realistic ambiguous setup, a question, and evaluator notes (strong vs. weak answer)
- `hiring/pools/README.md` — archive format: every confirmed hire and every rejected proposal gets a pool file
- `hiring/pools/audio-streaming-engineer.md` — retroactive pool for Kai Nakamura's hire: 7 candidates from 7 countries, individual scenario responses, scored rankings, selection rationale

### Changed
- `agents/hiring-manager.md` — added **Candidate Pool Process** section [NON-NEGOTIABLE]: Jordan must run a 7+ candidate pool before any proposal reaches the CEO; added **Escalation Triggers** section (to CEO, closes internally, never directly to user)

---

## [1.14.1] 2026-05-21

**Rationale**: PM surveyed all 12 Crashcart repos and identified a capability gap: no existing roster role covers media pipeline engineering (ffmpeg, real-time audio streaming, Discord voice channel integration). HIRING MANAGER confirmed algebraic mixing fails — no pairing of current roles has media pipeline competency. Approved by user.

### Added
- `agents/audio-streaming-engineer.md` — Kai Nakamura, 9 years. Scoped to RP-Music-Radio and MusicBot projects. Specialties: FFmpeg pipelines, RTMP/HLS/Icecast, Discord voice (Lavalink), stream health monitoring. Role Scope: may not make backend API decisions or deploy infrastructure.
- `agents/registry.json` — new entry for `audio-streaming-engineer.md`

---

## [1.14.0] 2026-05-21

**Rationale**: Every profile on the roster was held to the same standard. The hiring-manager and backend-developer re-hires set a new bar — Thinking Process, Role Scope with explicit limits, Escalation Triggers. Every remaining profile needed the same treatment. "Everyone, even you are under the gun."

### Changed
- `agents/frontend-developer.md` — expanded: 5-step Thinking Process (spec+design together, component library first, outside-in tree, sad paths before happy path, accessibility before done), Role Scope, Escalation Triggers to Backend/UI/Tech Lead/UX
- `agents/fullstack-developer.md` — expanded: scope-first Thinking Process (is this actually full-stack?), Role Scope with explicit full-stack limits, Escalation Triggers to Tech Lead/Security/Backend/DBA
- `agents/mobile-developer-android.md` — expanded: 5-step Thinking Process (API level first, mid-range device, offline first, memory/battery budget, physical device testing), Role Scope, Escalation Triggers
- `agents/mobile-developer-ios.md` — expanded: 5-step Thinking Process (offline contract, App Store compliance, SwiftUI vs UIKit proof, no force-unwraps, physical device recording), Role Scope, Escalation Triggers
- `agents/cloud-engineer.md` — expanded: cost-first Thinking Process (workload before architecture, managed-service default, cost estimate with every proposal, failure mode design, no ClickOps), Role Scope, Escalation Triggers to Security/Tech Lead/SRE/PM
- `agents/sre.md` — expanded: error-budget Thinking Process (SLO before alerting, error budget as decision tool, stabilize-diagnose-fix incident order, 15-min cadence, blameless post-mortems), Role Scope, Escalation Triggers
- `agents/qa-manual.md` — expanded: investigation Thinking Process (understand before breaking, charter before session, sad paths first, document during session, isolate before filing), Role Scope, Escalation Triggers with PASS/PASS WITH CONDITIONS/BLOCKED hand-off
- `agents/technical-writer.md` — expanded: reader-first Thinking Process (define reader before writing, one job per doc, test code samples, active voice enforcement, critical path first), Role Scope, Escalation Triggers
- `agents/product-manager.md` — expanded: skeptic Thinking Process (evidence before design, minimum hypothesis test, criteria before sprint, scope creep as explicit decision, metric before launch), Role Scope, Escalation Triggers
- `agents/ux-designer.md` — expanded: research-first Thinking Process (users before design, job-to-be-done framing, three directions not one, accessibility as design constraint, test before UI handoff), Role Scope, Escalation Triggers
- `agents/ui-designer.md` — expanded: system-first Thinking Process (component exists?, all eight states, token-based every step, no one-offs, Figma is the spec), Role Scope, Escalation Triggers
- `rules/claude-ceo.md` — CEO THINKING PROCESS section added: 5 governance principles (decision type first, user involvement check, delegate to team, slow down for irreversible decisions, document at point of decision) [NON-NEGOTIABLE]

---

## [1.13.3] 2026-05-21

**Rationale**: Omar's original profile was sparse — no Thinking Process, no Role Scope, no escalation triggers. A backend developer who doesn't know what decisions are theirs vs. TECH LEAD's is a liability. The re-hire brings him up to the standard set by HIRING MANAGER.

### Changed
- `agents/backend-developer.md` — full profile rewrite: expanded background, 5-step Thinking Process (data model first, contract before code, failure modes before happy path, instrument from day one, test against reality), Role Scope with explicit limits, Escalation Triggers for TECH LEAD and SECURITY ENGINEER, richer hand-off format

---

## [1.13.2] 2026-05-21

**Rationale**: HIRING MANAGER needs to be a heavyweight evaluator, not just a gatekeeper. Every bad hire starts as a plausible-sounding gap. Jordan's profile now captures the deliberate, skeptical process that keeps weak proposals from reaching the CEO — or the user.

### Changed
- `agents/hiring-manager.md` — expanded Thinking Process: 5-step deliberate evaluation (understand gap, challenge premise, apply full rule set, design with constraints, write case or close); explicit scope limits on what HR may not do; hand-off behavior; repo scope [NON-NEGOTIABLE]

---

## [1.13.1] 2026-05-21

**Rationale**: HR needs a mobile-friendly way to submit agent proposals without copy-pasting markdown. Same pattern as the ticket form — fill a structured issue, workflow generates the draft.

### Added
- `.github/ISSUE_TEMPLATE/new-agent.yml` — agent proposal form: role name, domain (dropdown), background, specialties, tools, gap justification, requested-by
- `.github/workflows/agent-proposal.yml` — converts submission to `agents/pending/{number}-{slug}.md` draft; commits; comments with filename; closes issue. RULE 16 still enforced — pending drafts require CEO review and explicit user approval before moving to `agents/`
- `agents/pending/README.md` — staging area for unapproved drafts

### Mobile usage
GitHub app → AI-rules → Issues → New Issue → New Agent Proposal → fill form → submit → draft appears in `agents/pending/`

---

## [1.13.0] 2026-05-21

**Rationale**: PROJECT MANAGER was doing double duty — managing projects AND owning hiring. Those are separate concerns. HIRING MANAGER (HR) is a dedicated role that owns the full hiring pipeline: gap intake from any role, algebraic check, proposal writing, and CEO escalation.

### Added
- `agents/hiring-manager.md` — HIRING MANAGER (HR) profile: Jordan Reyes; owns gap analysis, algebraic checks, hire proposals to CEO; may NOT create agent files or approve hires unilaterally

### Changed
- `rules/universal.md` — RULE 16: HIRING MANAGER replaces PROJECT MANAGER as the designated hiring initiator; all gaps go to HR first
- `rules/claude-ceo.md` — HIRING PROCESS: updated throughout to reference HIRING MANAGER (HR) instead of PROJECT MANAGER
- `agents/registry.json` — hiring-manager.md added

---

## [1.12.1] 2026-05-21

**Rationale**: RULE 18 incorrectly implied security roles shouldn't know how to program. Clarified: review roles are expected to be technically deep — the restriction is on their acting capacity (read/assess/flag only, never write/commit/deploy). Rule also generalized from security-specific to any reviewer+implementer conflict.

### Changed
- `rules/universal.md` — RULE 18 rewritten: restriction is on *capacity* not *knowledge*; generalized to cover any role whose primary function is review/audit mixed with any role producing the artifact under review; examples added

---

## [1.12.0] 2026-05-21

**Rationale**: Algebraic mixing had no guardrails — PROJECT MANAGER could propose `SECURITY ENGINEER + BACKEND DEVELOPER`, giving the auditor write access to the code they're reviewing. A role that can approve its own work is not a security role.

### Added
- `rules/universal.md` — RULE 18 — SEPARATION OF DUTIES: prohibits mixing any `security-*` role with any implementation role; lists permitted security pairings (other security roles, TECH LEAD for coordination, PM for planning, CEO for governance); CEO must reject prohibited combinations without escalating to user [NON-NEGOTIABLE]

---

## [1.11.4] 2026-05-21

**Rationale**: A different Claude instance opening this repo (automated run, sub-agent, CI) should not assume CEO authority. CEO belongs exclusively to the direct, interactive session with the repo owner.

### Added
- `rules/claude-ceo.md` — CEO SESSION EXCLUSIVITY section: any Claude not in a direct session with the repo owner (Crashcart) defaults to PROJECT MANAGER; lists explicit signals for non-CEO contexts; defines PM-scoped behavior when acting in this repo without CEO status [NON-NEGOTIABLE]

---

## [1.11.3] 2026-05-21

**Rationale**: When AI-rules goes private, target repos couldn't clone it to check for version updates without a PAT. The sync workflow already writes `rulesVersion` into each target repo's `.claude/settings.json` — the check script now reads that local value instead of cloning, eliminating the network requirement for version detection entirely.

### Changed
- `scripts/check-rules-updates.sh` — reads `rulesVersion` from local `.claude/settings.json` first; remote clone only happens if URL is provided (for ticket resolution checks). Falls back to remote `version.json` if local field is absent.

---

## [1.11.2] 2026-05-21

**Rationale**: Phone-friendly ticket submission. No copy-paste, no terminal, no tokens to set up. Works on private repos.

### Added
- `.github/ISSUE_TEMPLATE/ticket.yml` — structured issue form: title, scope (dropdown), priority (dropdown), description, optional criteria and context
- `.github/workflows/issue-to-ticket.yml` — converts any issue with the `ticket` label into `tickets/{number}-{slug}.md`; commits file; comments on issue with filename; closes issue automatically. Uses built-in `GITHUB_TOKEN` — zero setup required

### Mobile usage
GitHub app → AI-rules → Issues → New Issue → Ticket → fill form → submit → done

---

## [1.11.1] 2026-05-21

**Rationale**: Other Crashcart repos need to be able to post tickets to AI-rules without the user having to copy them manually. The workflow restricts writes to `tickets/` only — no other path is touched.

### Added
- `.github/workflows/receive-ticket.yml` — listens for `repository_dispatch` events of type `submit-ticket`; validates payload; writes `tickets/{repo}-{timestamp}-{slug}.md`; commits and pushes
- `scripts/post-ticket.sh` — helper for other repos: call with `--title`, `--scope`, `--opened-by`, `--description` etc.; fires the dispatch event; requires a PAT with `Contents: write` on AI-rules only
- `rules/claude-ceo.md` — ticket submitter check updated: Crashcart source repos are now valid submitters; unrecognized source repos still flagged to user

### Required setup
- Add `TICKET_DISPATCH_TOKEN` secret to each source repo (fine-grained PAT: Contents write on `Crashcart/AI-rules` only)

---

## [1.11.0] 2026-05-21

**Rationale**: Unauthorized agent files must be caught and deleted immediately. If an AI or external actor creates a role file without going through the approval process, the integrity check on session start finds and removes it. Authorship is verified via git log against the registry.

### Added
- `agents/registry.json` — authoritative manifest of all 29 approved agent files with creation commit SHAs
- `rules/claude-ceo.md` — AGENT FILE INTEGRITY section: session-start roster check; unauthorized files deleted immediately; authorship verification via git log; registry updated atomically with every new hire
- `CLAUDE.md` — session start checklist step 5: run agent integrity check before processing tickets
- `version.json` — bumped to 1.11.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.11.0

---

## [1.10.0] 2026-05-21

**Rationale**: The user holds the power over rule changes — not the CEO, not any AI. Any AI may request a change but cannot implement it without explicit user approval. Silence is not approval.

### Added
- `rules/universal.md` — RULE 17 RULE CHANGE AUTHORITY: user holds sole authority; any AI may request; silence not approval; rejected rules stand as written [NON-NEGOTIABLE]
- `version.json` — bumped to 1.10.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.10.0

---

## [1.9.3] 2026-05-20

**Rationale**: User decision — only PROJECT MANAGER initiates hire requests. All other roles route gaps through PM.

### Changed
- `rules/claude-ceo.md` — HIRING PROCESS: reverted to PM-only; all other roles must bring gaps to PM, not directly to CEO or user

---

## [1.9.2] 2026-05-20

**Rationale**: This is a big company. Restricting hire requests to PROJECT MANAGER alone doesn't scale — domain leads need to be able to advocate for their own staffing needs. CEO still filters; user still approves.

### Changed
- `rules/claude-ceo.md` — HIRING PROCESS: any lead, manager, or senior approved role may request a hire within their domain; junior roles route through their domain lead; CEO checks domain fit in addition to algebraic gap check

---

## [1.9.1] 2026-05-20

**Rationale**: PROJECT MANAGER should be able to argue for new hires — that's within their role. But every request is filtered by the CEO before reaching the user. This keeps the user out of noise while ensuring nothing gets approved without their sign-off.

### Changed
- `rules/claude-ceo.md` — HIRING PROCESS: PROJECT MANAGER may request hires by default; CEO applies algebraic check and evaluates before escalating; only appropriate requests reach the user; no other role may initiate hire requests

---

## [1.9.0] 2026-05-20

**Rationale**: CLAUDE MAINTAINER was used as an agent role announcement but is not in the approved roster (`agents/`). The user corrected this and directed that all role usage — agent, manager, lawyer, any type — requires either an existing `agents/` file or explicit user approval. Sub-specializations are no longer exempt.

### Added
- `rules/universal.md` — RULE 16 HIRING APPROVAL: no role may be used unless it exists in `agents/` or user approves it; covers all role types; all hiring requires explicit user approval; algebraic mixing allowed only from approved roles [NON-NEGOTIABLE]
- `rules/claude-ceo.md` — HIRING PROCESS section rewritten: references RULE 16, removes sub-spec exemption, explicitly states using an unapproved role is a RULE 16 violation
- `version.json` — bumped to 1.9.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.9.0

---

## [1.8.0] 2026-05-20

**Rationale**: The user does not like repeating themselves. Rule non-compliance results in process termination — one correction per session is the absolute limit. This needed to be explicit, firm, and in the universal rules so every AI is bound by it.

### Added
- `rules/universal.md` — RULE 15 COMPLIANCE ENFORCEMENT: follow the rules; if the user corrects you, stop immediately, name the rule broken, fix it, no explanations; one correction is the limit [NON-NEGOTIABLE]
- `version.json` — bumped to 1.8.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.8.0

---

## [1.7.0] 2026-05-20

**Rationale**: The rules had quality standards (RULE 3) but no explicit company identity framing. The CEO directed that Crashcart's identity as a high-quality software company staffed by excellent programmers should be foundational — before any operational rules.

### Added
- `rules/universal.md` — COMPANY IDENTITY section (after Precedence, before RULE 1): Crashcart produces production-ready code, all AIs operate as excellent programmers who take pride in their work [NON-NEGOTIABLE]
- `version.json` — bumped to 1.7.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.7.0

---

## [1.6.1] 2026-05-20

**Rationale**: The CEO ticket rule only allowed `user` and `claude` as submitters. Gemini is also a Crashcart-controlled AI and should be able to open tickets. The rule now also has an escape hatch for any other AI the user explicitly confirms, and requires asking the user before processing unrecognized sources.

### Changed
- `rules/claude-ceo.md` — SESSION-START TICKET PROCESSING: approved submitters expanded to `user | claude | gemini`; unrecognized sources require user confirmation before processing
- `version.json` — bumped to 1.6.1, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.6.1

### Added
- `deploy/apply.sh` — master script to propagate AI-rules template to Crashcart repos (run locally)
- `deploy/repos/kali-ai-term/CLAUDE.md` — filled-in shell template for Kali-AI-term
- `deploy/repos/rpg-bot/CLAUDE.md` — filled-in python template for RPG-Bot
- `deploy/repos/ollama-intelgpu/CLAUDE.md` — filled-in shell template for Ollama-intelgpu
- `deploy/repos/claud/CLAUDE.md` — filled-in base template for Claud

---

## [1.6.0] 2026-05-19

**Rationale**: Agents were silently performing work without declaring which role was active. Adding the ROLE ANNOUNCEMENT rule makes the team model visible: the user knows which specialization is on the job, transitions between roles are explicit, and the multi-agent simulation becomes legible without extra narration.

### Added
- `rules/claude-behavior.md` — new ROLE ANNOUNCEMENT section: role-header format, announce/skip triggers, hybrid-role examples, overridable default
- `version.json` — bumped to 1.6.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.6.0

---

## [1.5.3] 2026-05-19

**Rationale**: AGENT ROLE REFERENCES had no guidance for merged/hybrid roles (algebraic mixing of two specializations). When Claude operates in a combined capacity, the reference title was ambiguous. This patch adds the explicit `SPECIALIZATION-BASE ROLE` hyphen format so merged roles are unambiguous in communication and status updates.

### Changed
- `rules/claude-behavior.md` — AGENT ROLE REFERENCES: added merged/hybrid role `SPECIALIZATION-BASE ROLE` hyphen format with three examples
- `version.json` — bumped to 1.5.3, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.5.3

---

## [1.5.2] 2026-05-19

**Rationale**: Version headers in rule files track the last version that modified each file. After the v1.5.0 and v1.5.1 changes to claude-behavior.md and claude-ceo.md, those headers were still reading 1.4.1 — misleading to any AI reading the file cold. Corrected to 1.5.1. Also cleaned up dead code in check-rules-updates.sh and moved NEW_REPORTED initialization out of the conditional block for robustness.

### Changed
- `rules/claude-behavior.md` — version header: 1.4.1 → 1.5.1
- `rules/claude-ceo.md` — version header: 1.4.1 → 1.5.1
- `scripts/check-rules-updates.sh` — removed orphaned LAST_ARCHIVED variable; moved NEW_REPORTED=() initialization before the if-block (safe across all bash versions)
- `version.json` — bumped to 1.5.2, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.5.2

---

## [1.5.1] 2026-05-19

**Rationale**: The CEO/PM role distinction existed as intent but not as an explicit written rule. PROJECT MANAGERs in other repos had no defined channel to communicate with the CEO — now they use the ai-rules ticket system. The CEO role boundary (exclusive to AI-rules repo) was also not stated in rule text.

### Changed
- `rules/claude-behavior.md` — PROJECT MANAGER ROLE: added explicit CEO/PM role distinction; added PM-to-CEO escalation rule via tickets/ [NON-NEGOTIABLE]
- `rules/claude-ceo.md` — CEO MANDATE: added bullet clarifying CEO role is exclusive to AI-rules repo
- `version.json` — bumped to 1.5.1, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.5.1

---

## [1.5.0] 2026-05-19

**Rationale**: Claude had no explicit operating role in non-AI-rules repos, leading to ad-hoc project starts without planning artifacts. Additionally, agent personas were being referenced by their fictional real names (Simone, Dana) rather than their role titles, creating ambiguity about which role was speaking.

### Changed
- `rules/claude-behavior.md` — PROJECT MANAGER ROLE: Claude adopts PM role in all non-AI-rules repos; seven-artifact plan required before any work begins [NON-NEGOTIABLE]
- `rules/claude-behavior.md` — AGENT ROLE REFERENCES: agent roles referenced by ALL CAPS title only, never persona real name [NON-NEGOTIABLE]
- `version.json` — bumped to 1.5.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to 1.5.0

---

## [1.4.5] 2026-05-19

**Rationale**: RESPONSE FORMAT rule was scoped too broadly (all repos). User confirmed it applies to AI-rules only, so it moves from claude-behavior.md to claude-maintainer.md.

### Changed
- `rules/claude-maintainer.md` — RESPONSE FORMAT rule added (AI-rules repo only)
- `rules/claude-behavior.md` — RESPONSE FORMAT rule removed (was incorrectly all-repo scope)
- `version.json` — bumped to 1.4.5, new SHA256

---

## [1.4.4] 2026-05-19

**Rationale**: User directive — every Claude response must open with a one-line overview before any detail. Codified as NON-NEGOTIABLE in claude-behavior.md so it persists across sessions and repos.

### Changed
- `rules/claude-behavior.md` — RESPONSE FORMAT rule added: one-line overview required at the start of every response
- `version.json` — bumped to 1.4.4, new SHA256

---

## [1.4.3] 2026-05-19

**Rationale**: The ticket system was open to all AIs as submitters, creating a path for other AIs to flood the queue or influence rules without human oversight. This patch restricts ticket submission to the repo owner and Claude only, adds private repo support to the update-check script so repos can stay private, and documents the auth options in the template.

### Changed
- `rules/claude-ceo.md` — SESSION-START TICKET PROCESSING: only process tickets where **Opened by** is `user` or `claude`; all others are ignored and flagged [NON-NEGOTIABLE]
- `rules/universal.md` — RULE 14: added submitter restriction — other AIs must ask user or Claude to open tickets on their behalf
- `tickets/template.md` — added submitter restriction note to fields block
- `scripts/check-rules-updates.sh` — auth-aware clone: injects `AI_RULES_TOKEN` PAT into HTTPS URL if set; SSH URLs pass through to machine key; falls back to unauthenticated for public repos
- `templates/base/.claude/settings.json` — added `AI_RULES_TOKEN: ""` env placeholder
- `templates/base/CLAUDE.md` — added "Private AI-Rules Repo" section with PAT and SSH setup instructions
- `version.json` — bumped to 1.4.3, new SHA256

### Added
- `notes/sessions/2026-05-19-tick-001-api-mesh-plan.md` — Simone's seven-artifact project plan for TICK-001 (Crashcart API mesh)
- `tickets/TICK-001-cross-project-api-mesh.md` — status updated to in-progress

---

## [1.4.2] 2026-05-19

**Rationale**: Rule changes were previously tracked through the proposals/ system but had no structured discussion step before implementation. This patch formalizes rule-edit suggestions as tickets (RULE 14) so every AI must open a ticket, Claude discusses the rationale, and no rule is changed unilaterally.

### Added
- `rules/universal.md` — RULE 14: Rule-Edit Ticket Protocol — all AIs must open a ticket before modifying any rule file
- `rules/claude-ceo.md` — rule-edit ticket processing section: discuss rationale with requesting AI before implementing, rejecting, or deferring
- `tickets/template.md` — `rule-edit` scope option and `Requesting AI` field

### Changed
- `version.json` — bumped to 1.4.2, new SHA256

---

## [1.4.1] 2026-05-19

**Rationale**: As the repo grew, three files were doing too much: `rules/claude.md` mixed behavioral, maintainer, and CEO operating contexts; `rules/universal.md` bundled orchestration governance with per-AI behavioral rules; `scripts/daily-snapshot.sh` contained two independent code paths behind one conditional. This patch splits each into focused, single-responsibility files and adds the CEO ticket system so other AIs can open work items for Claude to process on session start.

### Added
- `rules/claude-behavior.md` — behavioral rules extracted from claude.md (all sessions, all repos)
- `rules/claude-maintainer.md` — maintainer rules extracted from claude.md (AI-rules repo only)
- `rules/claude-ceo.md` — CEO ticket processing, hiring process, project oversight (AI-rules session start)
- `rules/agent-orchestration.md` — RULE 13 extracted from universal.md (multi-agent circular hand-off)
- `scripts/snapshot-branch.sh` — local-branch snapshot mode extracted from daily-snapshot.sh
- `scripts/snapshot-external.sh` — external-repo snapshot mode extracted from daily-snapshot.sh
- `tickets/` — CEO ticket system: README, template, archive/ directory

### Changed
- `rules/claude.md` — converted to routing stub pointing to three sub-files
- `rules/universal.md` — RULE 13 replaced with one-line reference to agent-orchestration.md
- `scripts/daily-snapshot.sh` — converted to thin dispatcher (reads config, calls sub-script)
- `version.json` — bumped to 1.4.1, new SHA256

---

## [1.4.0] 2026-05-18

**Rationale**: The repo had roles and rules but no way for multiple AI agents to collaborate on a project in a consistent, non-overlapping way. v1.4.0 adds the circular hand-off workflow as a universal rule and provides 19 fully-defined role profiles so any AI can be assigned a specific position in the development loop.

### Added
- `rules/universal.md` — Rule 13: Agent Circular Hand-off Workflow (PM → UX → UI → Tech Lead → Backend/Frontend/Mobile → QA → Security → DevOps → SRE → PM)
- `agents/` — 19 role profiles with invented personas, specialties, tools, and hand-off formats:
  - Core loop: product-manager, ux-designer, ui-designer, tech-lead, backend-developer, frontend-developer, fullstack-developer, qa-engineer, security-engineer, devops-engineer, sre
  - Mobile variants: mobile-developer-ios, mobile-developer-android
  - Specialists: data-engineer, ml-engineer, dba, technical-writer, cloud-engineer
  - Facilitator: scrum-master
- `agents/README.md` — circular workflow diagram, role index table, per-AI integration guide index
- `agents/project-manager.md` — Simone Adler, [NON-NEGOTIABLE] seven-artifact planning rule (scope, WBS, milestones, dependency map, risk register, resource allocation, definition of done) required before any work begins
- `agents/claude/README.md` — how Claude Code uses profiles (file tools, multi-session)
- `agents/gpt/README.md` — system message injection, manual hand-off workflow
- `agents/gemini/README.md` — role-instruction format, 1M context window usage
- `agents/copilot/README.md` — copilot-instructions.md injection, file-level comments
- `agents/ollama/README.md` — Modelfile SYSTEM block, model recommendations per role

### Updated
- `rules/universal.md` — Rule 13 appended (rule content changed → SHA256 updated)
- `CLAUDE.md` — repo structure map updated to include agents/, templates/, notes/, proposals/, MIGRATION.md
- `README.md` — repository layout updated to include agents/ and templates/ rows
- `version.json` — bumped to 1.4.0, new SHA256
- `acknowledgments/claude.ack.json` — updated to v1.4.0

---

## [1.3.0] 2026-05-18

**Rationale**: The repo had extensive rule content but no documented rationale, no cross-AI context for AIs reading cold, no migration guide, and an inconsistent SHA256 (computed in non-alphabetical file order). v1.3.0 fills those gaps without changing any rule behavior.

### Added
- `notes/` — three-layer documentation system:
  - `notes/decisions/` — five Architecture Decision Records (001–005) explaining why the system works the way it does
  - `notes/sessions/README.md` — format and retention policy for Claude's cross-session working notes
  - `notes/context/` — background for any AI reading cold: Crashcart overview, AI capability matrix, troubleshooting guide
- `MIGRATION.md` — per-version behavioral change guide so AIs know exactly what changed between versions
- `proposals/examples/` — approved and rejected example proposals with full format and outcome status
- `proposals/archive/.gitkeep` — pre-created archive directory so `git mv` works on first real proposal

### Updated
- `README.md` — added "Why This Exists" section; added `notes/`, `MIGRATION.md`, `proposals/` to repo layout
- `proposals/README.md` — added Timing, Cross-AI Conflicts, Moving to Archive, and Examples sections
- `acknowledgments/README.md` — added re-acknowledgment procedure for non-Claude AIs; linked to capability matrix
- `CHANGELOG.md` — added rationale lines to all prior version entries
- `version.json` — bumped to 1.3.0; corrected SHA256 to canonical alphabetical file order
- `acknowledgments/claude.ack.json` — updated to v1.3.0

### Fixed
- SHA256 in `version.json` and `claude.ack.json` was computed using non-alphabetical file order; corrected to `cat rules/*.md | sha256sum` (alphabetical). Rule content unchanged.

### Acknowledgments Required
- Claude: acknowledged v1.3.0 (claude-sonnet-4-6, 2026-05-18)
- All other AIs: re-acknowledge with new SHA256 (`c6af1b9d46ed0906c20aa87fc46fe34a2813d26992d498607175ec6db8b51021`)

---

## [1.2.0] 2026-05-18

**Rationale**: The system was static and top-down — other AIs could only receive rules, not propose improvements. v1.2.0 adds a feedback loop (Rule 12 self-assessment) so every AI can flag duplicates, conflicts, and gaps in its own rule file. Precedence clarified so there's no ambiguity when AI-specific and universal rules disagree.

### Added
- `rules/universal.md` — **Rule 12: Self-Assessment Protocol**: all AIs must evaluate their own
  rule file against universal.md on each acknowledgment and produce structured proposals for any
  duplicates, conflicts, inapplicable rules, or gaps found
- `rules/universal.md` — **Precedence preamble**: `{ai}.md > universal.md` — AI-specific rules
  override universal rules; no AI should repeat a universal rule in its own file without overriding it
- `proposals/README.md` — documents the full proposal process (submission, review, archive)
- `proposals/template.md` — standard proposal format for all AIs (types: remove-duplicate, add-rule,
  modify-rule, flag-conflict)
- `rules/claude.md` — **Proposal Review section**: Claude's maintainer workflow for reviewing,
  approving, rejecting, or deferring open proposals in `proposals/{ai}/`

### Acknowledgments Required
- Claude: acknowledged v1.2.0 (claude-sonnet-4-6, 2026-05-18)
- All other AIs: pending — re-acknowledge with new universal.md to trigger self-assessment

---

## [1.1.0] 2026-05-18

**Rationale**: Four other Crashcart repos already had working AI rules in ad-hoc formats (copilot-instructions.md, guardrails.py, system prompts). v1.1.0 imports those proven patterns into a single normalized set rather than letting them drift independently. Copilot added as a first-class AI with its own rule file.

### Added
- `rules/copilot.md` — GitHub Copilot rules (all modes: chat, agent, inline, PR review);
  template-driven output, workflow discipline, PR monitoring, escalation format.
  Sourced from `imports/rp-music-radio/copilot-instructions.md` and `claude-prompt.md`
- `imports/` — raw source files from other Crashcart repos reviewed for pattern import:
  - `imports/rp-music-radio/` — AI_USAGE.md, copilot-instructions.md, claude-prompt.md
  - `imports/rpg-bot/` — guardrails.py (anti-sycophancy + mechanical locks)
  - `imports/ollama-intelgpu/` — copilot-instructions.md (Ollama performance standards)
  - `imports/kali-ai-term/` — copilot-instructions.md (enterprise workflow rules)
- `acknowledgments/copilot.ack.json` — Copilot acknowledgment file (pending initial ack)

### Updated
- `rules/universal.md` — added Rule 2 (Model Selection matrix: Haiku/Sonnet/Opus tiers),
  Rule 4 (Anti-Sycophancy lock); sourced from RP-Music-Radio and RPG-Bot imports
- `rules/claude.md` — added Model Selection section, Anti-Sycophancy section, Context
  Management (AUTOCOMPACT=50%), Governance self-protection rules, Pydantic note
- `rules/ollama.md` — added Required Performance Settings table
  (`KEEP_ALIVE=-1`, `FLASH_ATTENTION=1`, `KV_CACHE_TYPE=q8_0`);
  added Role Separation section for multi-LLM pipelines
- `scripts/daily-snapshot.sh` — added separate-repo snapshot mode; reads
  `snapshotTargetRepo` from settings; when set, clones target repo and pushes
  `rules-YYYY-MM-DD` branch with current rule files
- `.claude/settings.json` — added `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50` env var,
  PostToolUse auto-formatting hook (prettier for TS/JSON, black for Python),
  `snapshotTargetRepo` field for separate-repo mode

### Acknowledgments Required
- Claude: acknowledged v1.1.0 (claude-sonnet-4-6, 2026-05-18)
- Copilot: pending initial acknowledgment
- GPT: pending initial acknowledgment
- Gemini: pending initial acknowledgment
- Ollama: pending initial acknowledgment

---

## [1.0.0] 2026-05-18

**Rationale**: No explicit behavioral contract existed across Crashcart repos — each AI operated on implicit expectations that varied by project and model. v1.0.0 establishes a baseline: versioned, per-AI rules written in each AI's native instruction grammar, with a SHA256-verified acknowledgment system so drift can be detected.

### Added
- `rules/universal.md` — core rules for all AI systems: token efficiency, quality
  standard, no-filler, acknowledgment protocol, daily snapshot, code standards,
  security, communication
- `rules/claude.md` — Claude-specific rules in Claude's native instruction grammar;
  covers token efficiency failure modes, Crashcart code conventions (TypeScript,
  Python, Shell), tool use safety, communication style
- `rules/gpt.md` — GPT system-message style rules; response efficiency, code
  standards, honesty, acknowledgment format, security hard limits
- `rules/gemini.md` — Gemini role-instruction style rules; operating mode, output
  length, code generation, multimodal inputs, acknowledgment, constraints
- `rules/ollama.md` — Ollama Modelfile SYSTEM block + resource efficiency rule for
  local hardware constraints
- `acknowledgments/` — acknowledgment system for all AI systems; Claude pre-acknowledged
  v1.0.0; GPT/Gemini/Ollama awaiting initial acknowledgment
- `version.json` — machine-readable version + SHA256 of all rule files combined
- `scripts/daily-snapshot.sh` — creates snapshot/YYYY-MM-DD branch when day changes
- `.claude/settings.json` — PreToolUse hook wiring for automatic daily snapshots
- `CLAUDE.md` — Claude Code integration instructions, import candidates from other
  Crashcart repos, session start checklist

### Acknowledgments Required
- Claude: acknowledged (claude-sonnet-4-6, 2026-05-18)
- GPT: pending initial acknowledgment
- Gemini: pending initial acknowledgment
- Ollama: pending initial acknowledgment

---

<!-- Future entries go above this line -->
