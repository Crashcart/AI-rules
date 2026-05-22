# Hiring Evaluation Process
version: 1.1 | owner: HIRING MANAGER (Jordan Reyes)

This document governs how all hire proposals are evaluated in the Crashcart AI-rules system. It supplements the 5-step Thinking Process in `agents/hiring-manager.md`. Every confirmed hire must have an archived pool in `hiring/pools/`.

---

## 0. Pre-Qualification Code Test

Before any candidate advances to the scenario interview, they complete the role-appropriate code test from `hiring/test-bank.md`.

**Pass threshold: 10/20 minimum.** Candidates who score below 10/20 are recorded in the pool table with their code test score but do not receive a scenario interview.

**Scoring dimensions** (all 1–5, max 20 total):

| Dimension | What It Measures |
|-----------|-----------------|
| **Correctness** | Does the implementation handle all required cases — including edge cases stated in the requirements? |
| **Code Quality** | Is the code tight and minimal? Well-named, no unnecessary verbosity, no dead code. |
| **Error Handling** | Are failure modes covered — network errors, malformed input, unexpected states? |
| **Performance** | Is the approach efficient? No busy loops, unnecessary allocations, or blocking calls where async is required. |

**Code test scoring table format** (required in every pool file):

| Rank | Name | Correctness | Code Quality | Error Handling | Performance | Total | Status |
|------|------|------------|---------|---------------|-------------|-------|--------|
| 1 | ... | X/5 | X/5 | X/5 | X/5 | X/20 | Pass / Fail |

Candidates who fail (< 10/20) are listed at the bottom with "FAIL — did not advance to scenario."

The code test cannot be skipped for any reason. A candidate with an impressive background who cannot write correct, tight code under a time constraint is not the right hire.

[NON-NEGOTIABLE — no candidate advances to scenario interview without a passing code test score]

---

## 1. Pool Generation

Before any candidate is evaluated, HIRING MANAGER generates a pool of **7–10 candidates**.

Candidates must be drawn from a realistic global distribution:
- Experience range: 6–15 years in the primary specialty
- Geographic diversity: no more than 2 candidates from the same region
- Specialty emphasis variety: each candidate has a distinct primary strength within the role domain — no two candidates are interchangeable
- At least one candidate with a non-traditional path (e.g., self-taught, career transition, domain-adjacent background)

**Pool table format** (required for every pool):

| # | Name | Location | Years | Specialty Emphasis | Strength | Trade-off |
|---|------|----------|-------|-------------------|---------|-----------|
| 1 | ... | ... | ... | ... | one sentence | one sentence |

No pool may have fewer than 7 rows. No pool may have all candidates from the same region or experience band.

---

## 2. Scenario Test

Each candidate is run through one scenario from `hiring/scenario-bank.md`. The scenario must match the role category. If multiple scenarios exist for the role, use the one that best surfaces the specific gap the team needs to fill.

**Scenario response format:**

For each candidate, write 2–4 sentences summarizing how they would approach the scenario. The response should reflect their background — a candidate with broadcast engineering experience approaches an audio pipeline incident differently from one with Discord bot experience.

Responses are scored immediately after being written, before moving to the next candidate. Do not score all candidates at the end.

---

## 3. Scoring Rubric

Score each candidate on three dimensions. All scores are 1–5. Maximum total: 15.

### Competence (1–5)
Does the candidate understand the domain at the depth required for this role?

| Score | Meaning |
|-------|---------|
| 5 | Handles the scenario with no gaps; surfaces edge cases that weren't in the prompt; response would require no follow-up |
| 4 | Solid; covers the main case and most edge cases; one minor gap |
| 3 | Correct general approach; misses one important consideration that a senior practitioner would catch |
| 2 | Partially correct; would need significant guidance to reach the right outcome |
| 1 | Misunderstands the core problem; incorrect approach |

### Efficiency (1–5)
Does the candidate reach the right answer without unnecessary back-and-forth or over-escalation?

| Score | Meaning |
|-------|---------|
| 5 | Resolves the scenario with minimum moves; escalates only when genuinely blocked; no wasted steps |
| 4 | Fast resolution; one reasonable clarification or escalation |
| 3 | On-pace; one or two escalations but nothing excessive |
| 2 | Slow; escalates questions that are answerable with the information given |
| 1 | Blocks on things a senior practitioner would handle independently; requires hand-holding |

### Quality (1–5)
Would the candidate's output require revision? Do they leave the system in a better state than they found it?

| Score | Meaning |
|-------|---------|
| 5 | Output would need no revision; sets a reference standard; considers downstream impact |
| 4 | High quality; minor suggestions only; solid documentation habits |
| 3 | Acceptable; would require one round of review to reach production quality |
| 2 | Would require significant revision; leaves gaps that create work for others |
| 1 | Would need to be redone; output creates more problems than it solves |

---

## 4. Scoring Table

After all candidates are scored, compile the results:

| Rank | Name | Competence | Efficiency | Quality | Total |
|------|------|-----------|------------|---------|-------|
| 1 | ... | X/5 | X/5 | X/5 | X/15 |

Sort by total descending. Ties broken by: Competence first, then Quality, then Efficiency.

---

## 5. Selection Decision

The pool file must include a Selection section:

```
**Finalist:** [Name] — Total: X/15
**Runner-up:** [Name] — Total: X/15 — eliminated because [one sentence]
**Rationale:** [one sentence on why the finalist fits this team's specific needs, not just "highest score"]
```

The rationale must reference the team's specific gap — not just "they scored highest." A candidate who scores 14/15 but whose strength doesn't match the actual gap loses to a 13/15 candidate whose strength does.

HIRING MANAGER never names a finalist without naming a runner-up and the reason the runner-up was not selected.

---

## 6. What Goes to the CEO

The CEO receives:
1. The role name and the gap it fills
2. Why algebraic mixing cannot cover the gap (required by RULE 16)
3. The finalist's name and total score
4. The runner-up's name and why they were not selected
5. The pool size (number of candidates evaluated)

The CEO does not receive the full pool table — only the summary above. The full pool is archived in `hiring/pools/` for the record.

---

## 7. Archiving

After user approval, the pool file is archived at `hiring/pools/{role-slug}.md`. If no hire is made (proposal rejected or gap closed by mixing), the pool is still archived with the outcome noted.

Archive files are permanent — they are not deleted or moved. Future evaluations for the same role reference the prior pool.

---

## When to Skip the Pool

The pool process applies to all new hires. It does not apply to:
- Re-evaluations of existing roster members (covered by profile updates)
- Algebraic mixing decisions (no new file = no pool needed)

There is no exception for urgency. A fast bad hire is worse than a slow good one.

[NON-NEGOTIABLE — no hire reaches the CEO without a completed pool]
