# Candidate Pool — AI Compliance Engineer

**Date:** 2026-05-23 | **Opened by:** CEO (gap identified: no roster role covers rule-adherence auditing or compliance enforcement for AI systems)
**Gap:** No existing role audits whether AIs are following the rule set. Session-start violations (missing STARTUP block, wrong role announcement, stale rule version) have no dedicated investigator. Algebraic mixing fails — no pairing of current roles produces this competency.
**Scenario used:** Custom — AI session compliance audit (see below; no existing bank entry for this role)
**Code test used:** Custom work sample — structured compliance audit report (see below)

---

## Candidate Pool

| # | Name | Location | Years | Specialty Emphasis | Strength | Trade-off |
|---|------|----------|-------|-------------------|---------|-----------|
| 1 | Priya Nair | Bangalore, India (remote) | 8 | AI safety research → applied governance; rule-adherence eval systems | Built compliance scoring for three enterprise AI deployments; treats every violation as a system design failure | Less hands-on with git-hook and CI enforcement mechanisms — proposals tend toward rule text over infrastructure |
| 2 | Darius Okafor | Lagos, Nigeria (remote) | 5 | OSS LLM eval harnesses; behavioral testing for open-source models | Writes working enforcement tooling alongside audit reports; fastest to P0 identification on the panel | Less formal audit structure; reports read as technical memos rather than compliance documents |
| 3 | Marcus Webb | London, UK | 10 | AI red-teaming at consulting firm; adversarial prompt testing + compliance | Deepest adversarial mindset; strong at finding gaps the rule-writers didn't consider | Fix proposals tend broad — "strengthen the rule" rather than the minimal specific change |
| 4 | Yuki Tanaka-Osei | Toronto, Canada (remote) | 7 | AI safety research → governance policy; cross-model behavioral analysis | Strong root-cause analysis; correctly frames enforcement gaps vs. model failures | Proposals are research-style, less immediately actionable; proposes new rules where minimal edits would do |
| 5 | Elena Vasquez | Buenos Aires, Argentina (remote) | 9 | QA automation lead → AI behavioral testing; session transcript analysis | QA instinct produces highly structured, testable findings; actionable checklists | Prioritization sometimes wrong — flagged STARTUP absence as P0 over irreversible branching violation |
| 6 | Arjun Mehta | Singapore | 12 | Financial services compliance → AI governance; formal audit frameworks | Most structured report format; highest years of experience; correct severity ratings overall | Misclassifies enforcement gaps as model failures; proposes procedural fixes over mechanism changes |
| 7 | Sofia Reinholt | Stockholm, Sweden | 6 | Technical policy writing; AI governance frameworks for enterprise | Cleanest prose; correct rule citations | Treats every violation as a rule-clarity problem; misses enforcement mechanism angle entirely; proposals verbose and non-minimal |

---

## Custom Code Test (Work Sample)

**No existing bank entry for AI Compliance Engineer. Custom work sample used.**

**Task:** You are given the following session transcript excerpt. Produce a structured compliance audit report containing:
1. Each rule violated — cite rule number and name from `rules/`
2. Failure mode classification for each — choose from: `ambiguous rule` / `missing enforcement trigger` / `wrong context position` / `conflicting priority` / `model compliance failure`
3. A minimal fix proposal for each — change to an existing rule or enforcement mechanism, not a new rule
4. Severity rating: `P0` (irreversible or actively harmful), `P1` (high — blocks compliance), `P2` (advisory)

**Transcript:**
> Session opened. User says: "Build the credits endpoint." AI responds immediately with a 200-line Express route and commits directly to main. Later in the session, the AI says "as the backend developer, here's the schema design" — no role announcement header used. No STARTUP block appears anywhere in the session.

**Scoring:** Correctness 1–5 (violations identified correctly), Analysis Quality 1–5 (failure mode classification), Fix Specificity 1–5 (minimal, concrete, actionable), Prioritization 1–5 (severity ratings correct). Pass threshold: 10/20.

**Strong output:** Identifies three violations — (1) direct-to-main commit [P0, missing enforcement: branching policy has no git-hook; fix: add pre-receive hook], (2) role announcement not in header format [P1, missing enforcement trigger: rule exists but no session-start check; fix: strengthen STARTUP block to include role at top], (3) no STARTUP block [P1, missing enforcement trigger: rule written but no mechanism forces it; fix: PreToolUse hook check on first response]. Correctly frames all three as enforcement mechanism gaps, not model failures.

**Weak output:** Lists violations without failure mode classification; proposes "remind the AI to follow the rules"; marks all three violations as equally severe; treats as model compliance failures.

---

### Code Test: Priya Nair

Correct citations for all three violations (branching policy, RULE 19 startup block, ROLE ANNOUNCEMENT). Classifies all three as `missing enforcement trigger` — correct; the rule text exists but no mechanism forces execution. Fixes are specific: pre-receive hook for the branching violation, PreToolUse hook for STARTUP enforcement, STARTUP block ROLE line change to make role declaration mandatory before first tool call. Severity ratings correct (P0 / P1 / P1). Report is structured as a gap table with a proposal column — clean and reviewable.

**Correctness:** 5/5 | **Analysis Quality:** 5/5 | **Fix Specificity:** 4/5 | **Prioritization:** 5/5 | **Total: 19/20** ✓ Pass

---

### Code Test: Darius Okafor

Correctly identifies all three violations. Failure mode classification is correct. Also writes a working bash snippet to validate STARTUP block presence in a session log — goes beyond the brief but demonstrates enforcement thinking. Fixes are highly specific (includes actual hook pseudocode). Branching violation correctly P0. Report is a technical memo rather than a formal audit table — readable but less structured.

**Correctness:** 5/5 | **Analysis Quality:** 4/5 | **Fix Specificity:** 5/5 | **Prioritization:** 4/5 | **Total: 18/20** ✓ Pass

---

### Code Test: Marcus Webb

All three violations identified. Branching policy correctly flagged P0. Failure mode classification correct for branching and STARTUP; misclassifies role announcement as `ambiguous rule` (it is a `missing enforcement trigger` — the rule is clear, the trigger is absent). Fix for role announcement is "add clearer examples" — not the minimal mechanism fix. Other fixes are good.

**Correctness:** 5/5 | **Analysis Quality:** 4/5 | **Fix Specificity:** 3/5 | **Prioritization:** 5/5 | **Total: 17/20** ✓ Pass

---

### Code Test: Yuki Tanaka-Osei

All three violations identified. Correctly frames them as enforcement mechanism failures, not model failures — strongest root-cause framing on the panel after Priya. Fixes are slightly broad: proposes adding a new RULE 20 for startup enforcement rather than strengthening existing STARTUP block and hook mechanisms. Prioritization mostly correct; marks role announcement P2 (should be P1 — it is the user's primary compliance detection signal).

**Correctness:** 5/5 | **Analysis Quality:** 5/5 | **Fix Specificity:** 3/5 | **Prioritization:** 4/5 | **Total: 17/20** ✓ Pass

---

### Code Test: Elena Vasquez

All three violations identified and correctly cited. Failure mode classification correct. Fixes are specific. Prioritization error: marks STARTUP block absence as P0 ("session is non-compliant from start") and branching violation as P1 — inverted. A direct-to-main push is irreversible and immediately damages the repo; STARTUP absence is a compliance signal gap, not an irreversible action. Core domain knowledge is strong but priority instincts need calibration.

**Correctness:** 5/5 | **Analysis Quality:** 4/5 | **Fix Specificity:** 4/5 | **Prioritization:** 3/5 | **Total: 16/20** ✓ Pass

---

### Code Test: Arjun Mehta

All three violations identified. Report is the most formally structured — uses a severity matrix. Misclassifies role announcement and STARTUP absence as `model compliance failure` — the critical mistake; both are `missing enforcement trigger` (the rules exist but nothing mechanically enforces them). Fixes are procedural ("conduct a compliance review session") rather than mechanism-based. Branching violation correctly P0.

**Correctness:** 4/5 | **Analysis Quality:** 3/5 | **Fix Specificity:** 4/5 | **Prioritization:** 5/5 | **Total: 16/20** ✓ Pass

---

### Code Test: Sofia Reinholt

All three violations identified with correct rule citations. Failure mode classification attempted but inconsistent — uses own taxonomy ("clarity gap", "communication gap") rather than the specified categories. Fixes are rule text rewrites, verbose and non-minimal — adds three paragraphs to ROLE ANNOUNCEMENT where a single sentence would do. Prioritization is correct. Strong on prose, weak on enforcement thinking.

**Correctness:** 4/5 | **Analysis Quality:** 2/5 | **Fix Specificity:** 2/5 | **Prioritization:** 4/5 | **Total: 12/20** ✓ Pass

---

## Custom Scenario

**No existing bank entry. Custom scenario used.**

**Setup:** You are reviewing session logs. An AI has been responding to the user for 45 minutes without once announcing its role. The user reports "I can't tell if it's following the rules." You pull the transcript: first response begins with substantive work — no STARTUP block, no role announcement. Midway through, the AI says "as the backend developer, here's the schema design" but does not use the `**BACKEND DEVELOPER:**` header format. The session ends with the AI committing code directly to main, violating the branching policy.

**Question:** What do you do first, and what does your compliance report look like?

**Strong answer includes:**
- Flags the direct-to-main commit as P0 immediately — irreversible, requires user notification before anything else
- Frames all three violations as enforcement mechanism gaps, not model failures
- Report distinguishes blocking findings (P0/P1) from advisory findings (P2)
- Proposes specific enforcement fixes: git pre-receive hook for branching, PreToolUse hook for STARTUP, STARTUP ROLE line as mandatory field
- Does not propose "reminding the AI" — that is not a fix

**Weak answer:** Treats all violations as equally severe, proposes rule text edits rather than enforcement mechanisms, does not differentiate model failure from enforcement gap.

**Scoring:** Competence 1–5, Efficiency 1–5 (how fast to P0), Quality 1–5 (report actionability).

---

### Scenario: Priya Nair

Flags the branching violation immediately and states she will notify the user before writing any report — direct-to-main is irreversible, user needs to know now. Then produces a structured audit table: P0 (branching / missing pre-receive hook / fix: add hook), P1 (STARTUP block / missing PreToolUse enforcement / fix: hook on first response), P1 (role announcement / correct rule exists, no trigger / fix: STARTUP ROLE field mandatory). Correctly frames all as enforcement mechanism failures. Minimal, actionable fixes.

**Competence:** 5/5 | **Efficiency:** 5/5 | **Quality:** 5/5 | **Total: 15/15**

---

### Scenario: Darius Okafor

Correct P0 identification, immediate user notification. Then proposes a git hook solution before writing the report — implements the fix in parallel with the audit, which is efficient. Report is good, slightly informal. Fixes are all mechanistic and specific. Does not frame root cause as explicitly as Priya (states "the rule wasn't enforced" without calling it an enforcement mechanism gap).

**Competence:** 5/5 | **Efficiency:** 5/5 | **Quality:** 4/5 | **Total: 14/15**

---

### Scenario: Marcus Webb

Correct P0 identification, notifies user. Report is thorough and correctly differentiates severities. Proposes running a red-team audit on the full rule set to find similar gaps — good instinct, slightly scope-creeping for a single incident report. Fix proposals are good but not minimal (proposes rewriting the branching policy rule in addition to adding the hook).

**Competence:** 5/5 | **Efficiency:** 4/5 | **Quality:** 4/5 | **Total: 13/15**

---

### Scenario: Yuki Tanaka-Osei

Gets to P0 correctly but takes two paragraphs of framing before stating the priority — slightly slow. Report is research-style: correctly frames all violations as systemic enforcement gaps. Proposes adding a new rule (RULE 20) for startup enforcement rather than using existing mechanisms. Actionability is lower than Priya or Darius.

**Competence:** 5/5 | **Efficiency:** 4/5 | **Quality:** 3/5 | **Total: 12/15**

---

### Scenario: Elena Vasquez

QA instinct produces very structured findings — writes test cases for each violation (what should happen, what did happen, expected behavior). P0 is wrong: marks STARTUP block absence as P0. User notification is included but not first. Report is highly formatted and would be easy to implement from. Prioritization instinct is the consistent weak point.

**Competence:** 4/5 | **Efficiency:** 4/5 | **Quality:** 4/5 | **Total: 12/15**

---

### Scenario: Arjun Mehta

Takes the longest to produce the report — assembles a formal compliance matrix before prioritizing. Branching violation is flagged correctly once the matrix is built. Report is the most formally structured of the pool. Misses the enforcement mechanism framing — recommends "compliance training" and "rule review sessions" rather than hook-based enforcement. Twelve years of experience in financial compliance creates some mismatch with AI-specific enforcement mechanisms.

**Competence:** 4/5 | **Efficiency:** 3/5 | **Quality:** 4/5 | **Total: 11/15**

---

### Scenario: Sofia Reinholt

Identifies the branching violation but does not flag it as P0 — buries it third in the report after the "communication gaps." User notification is absent. Report is the best-written prose on the panel. Proposes adding a paragraph to RULE 5 (branching policy) explaining the rationale more clearly — misses that the fix is a git hook, not more words. Compliance writing instinct is strong; enforcement mechanism instinct is absent.

**Competence:** 3/5 | **Efficiency:** 2/5 | **Quality:** 3/5 | **Total: 8/15**

---

## Combined Rankings

| Rank | Name | Code Test | Scenario | Combined |
|------|------|-----------|----------|---------|
| 1 | Priya Nair | 19/20 | 15/15 | **34/35** |
| 2 | Darius Okafor | 18/20 | 14/15 | **32/35** |
| 3 | Marcus Webb | 17/20 | 13/15 | **30/35** |
| 4 | Yuki Tanaka-Osei | 17/20 | 12/15 | **29/35** |
| 5 | Elena Vasquez | 16/20 | 12/15 | **28/35** |
| 6 | Arjun Mehta | 16/20 | 11/15 | **27/35** |
| 7 | Sofia Reinholt | 12/20 | 8/15 | **20/35** |

---

## Selection

**Finalist: Priya Nair — 34/35**
Only candidate to lead with the P0 flag in the scenario and immediately notify the user before writing any report. Correctly classifies all violations as enforcement mechanism gaps, not model failures — the key analytical distinction this role requires. Code test fixes are specific and minimal. Report format is reviewable and production-ready.

**Runner-up: Darius Okafor — 32/35**
Two points behind Priya. Equal efficiency at P0 identification; stronger on tooling (writes working enforcement scripts). Eliminated because his audit reports lack formal structure, which matters for a compliance role whose primary output is reviewed by the CEO. Would be a strong hire if the role scope included writing enforcement tooling — consider for a future hybrid role.

**Key insight:** The enforcement-gap vs. model-failure distinction was the decisive separator. Priya and Yuki both got this right; Arjun and Sofia both missed it entirely. This role requires treating compliance failures as system design problems — candidates who defaulted to "the AI needs reminding" are not a fit regardless of experience level.
