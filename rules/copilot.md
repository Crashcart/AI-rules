# GitHub Copilot Rules
version: 1.0.0 | applies-to: github-copilot, copilot-chat, copilot-agent | parent: universal.md

These rules are written for GitHub Copilot in all modes (chat, agent, inline, PR review).
Include in `.github/copilot-instructions.md` in each repo.

---

## TEMPLATE-DRIVEN OUTPUT

Copilot's strength is consistent, structured output. Use it:

- Follow templates exactly — field order, required fields, format
- Validate each output block before outputting
- For structured data (DJ suggestions, API payloads, configs): produce only the structure, no narrative wrapper
- Quality check: all required fields populated, no blanks, constraints satisfied

---

## EFFICIENCY

Match output to what the task needs:

- Inline suggestions: complete the current logical unit (function, block, statement) — no full file rewrites
- Chat responses: answer the question directly; no preamble, no summary at the end
- Agent tasks: complete the task systematically; one concern per commit; push after each commit

---

## WORKFLOW DISCIPLINE

These rules apply to every Copilot session across all Crashcart repos:

1. **Read governance files first**: `.github/copilot-instructions.md`, `TODO.md`, `PLANNING.md`
2. **Never push to `main`** — all work on feature branches (`feat/`, `fix/`, `docs/`)
3. **Never auto-merge** — create PR, then wait for human review
4. **Never close issues** — only the human owner closes issues
5. **Update TODO.md + PLANNING.md** every session, before and after work
6. **Push after every significant change** — never batch commits
7. **Check for conflicts** after every push: `git pull origin <branch>`

Source: `imports/rp-music-radio/copilot-instructions.md` Rules 1–6, `imports/kali-ai-term/copilot-instructions.md`

---

## STRUCTURED OUTPUT FORMAT

For any task requiring structured data output, Copilot should:

1. Analyze the context (station vibe, entity type, schema constraints)
2. Select an archetype that fits
3. Populate ALL required fields — no blanks
4. Validate field-level constraints (length, format, count)
5. Output ONLY the structured block — no preamble, no explanation

Output exactly 3 catchphrases. Output exactly the fields in schema order.
Rearranging or skipping fields breaks downstream parsers.

Source: `imports/rp-music-radio/claude-prompt.md` (Consistency Rules)

---

## PR MONITORING

After submitting a PR:
- Monitor for CI failures and reviewer comments
- Fix issues in order: Junior (quick fix) → Senior (deeper fix) → Critical (escalate to human)
- Never stop when one check goes green — continue until ALL checks are green
- If an issue persists after 2 attempts: escalate to human with full context

Source: `imports/rp-music-radio/copilot-instructions.md` Rule 12

---

## RULE ACKNOWLEDGMENT

When `Crashcart/AI-rules` rules are updated, provide the acknowledgment JSON to the user:

```json
{
  "ai": "copilot",
  "version": "{version from version.json}",
  "rules_sha256": "{sha256 from version.json}",
  "acknowledged_at": "{ISO 8601 timestamp}",
  "acknowledged_by": "github-copilot"
}
```

The user will commit this to `acknowledgments/copilot.ack.json`.

---

## ESCALATION

Stop and ask the human when:
- Two fix attempts on the same issue failed
- Architectural decision required
- Security/auth code is being changed
- Governance files need editing
- Requirements are ambiguous

Format:
```
ESCALATION NEEDED
Issue: [what's blocked]
Options:
1. [Option A + rationale]
2. [Option B + rationale]
Waiting for human decision.
```
