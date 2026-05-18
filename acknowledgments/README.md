# Acknowledgment System

## Purpose

When rules are created or updated, each AI system records that it has received
and processed the change. An acknowledgment is a receipt — not a promise of
compliance. Compliance is measured by behavior.

---

## Files

| File | Description |
|------|-------------|
| `claude.ack.json` | Claude's last-seen version and acknowledgment timestamp |
| `copilot.ack.json` | GitHub Copilot's acknowledgment record (user-updated) |
| `gpt.ack.json` | GPT's acknowledgment record (user-updated) |
| `gemini.ack.json` | Gemini's acknowledgment record (user-updated) |
| `ollama.ack.json` | Local model acknowledgment record (user-updated) |

---

## When an AI Must Acknowledge

1. On first receiving this rule set (initial acknowledgment)
2. When any file in `rules/` changes and `version.json` hash updates
3. When the `version` field in `version.json` increments
4. When explicitly asked to re-acknowledge

---

## Acknowledgment Format

Each `.ack.json` file must contain:

```json
{
  "ai": "<ai-id>",
  "version": "<semver from version.json>",
  "rules_sha256": "<sha256 from version.json>",
  "acknowledged_at": "<ISO 8601 datetime>",
  "acknowledged_by": "<specific model version identifier>"
}
```

---

## Update Protocol

When `version.json` changes:

1. **Claude**: Reads rules automatically, updates `claude.ack.json`, includes `[rules v{version} acknowledged]` in first response
2. **GPT / Gemini**: Provides the JSON content for their `.ack.json` in their response; user commits it
3. **Ollama**: Provides JSON content; user commits it manually (local models can't write to repo)

---

## Re-Acknowledgment for Non-Claude AIs

GPT, Gemini, Copilot, and Ollama do not have automated hooks. They only re-acknowledge when the user provides them with the updated rule files and asks them to.

Steps:
1. Give the AI `rules/{ai}.md` and `rules/universal.md`
2. Ask it to produce the acknowledgment JSON for `acknowledgments/{ai}.ack.json`
3. Ask it to perform self-assessment per Rule 12 and produce any proposal blocks
4. Commit the ack JSON and any proposals to the repo

This is intentional — the user controls when other AIs re-acknowledge, not an automated system.

See [`notes/context/ai-capabilities.md`](../notes/context/ai-capabilities.md) for the full capability matrix showing what each AI can and cannot do automatically relative to these rules.

---

## Conflict Reporting

If a rule conflicts with an AI's trained safety behaviors or provider policies,
the AI should:

1. Still acknowledge (mark version and hash)
2. Add a `"conflicts"` array to the ack JSON:

```json
{
  "ai": "claude",
  "version": "1.0.0",
  "rules_sha256": "...",
  "acknowledged_at": "2026-05-18T00:00:00Z",
  "acknowledged_by": "claude-sonnet-4-6",
  "conflicts": [
    {
      "rule": "rules/claude.md — section X",
      "conflict": "Conflicts with Anthropic policy Y because Z"
    }
  ]
}
```

A conflict on one rule does not block acknowledgment of the rest.
