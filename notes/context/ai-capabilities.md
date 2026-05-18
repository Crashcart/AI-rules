# AI Capabilities Matrix

What each AI system can and cannot do relative to the rules in this repo.
Use this to understand why different AIs have different acknowledgment protocols.

---

## Capability Matrix

| Capability | Claude | GPT | Gemini | Copilot | Ollama |
|---|---|---|---|---|---|
| Read files directly | ✅ via tools | ❌ user must paste | ❌ user must paste | ✅ via IDE | ❌ inference only |
| Write files | ✅ via tools | ❌ user must apply | ❌ user must apply | ✅ via IDE | ❌ |
| Auto-update `ack.json` | ✅ automatic | ❌ manual | ❌ manual | ❌ manual | ❌ manual |
| Run pre/post hooks | ✅ Claude Code | ❌ | ❌ | ✅ PR checks | ❌ |
| Execute shell commands | ✅ Bash tool | ❌ | ❌ | ❌ | ❌ |
| Daily snapshot | ✅ automatic hook | ❌ | ❌ | ❌ | ❌ |
| Self-assess (Rule 12) | ✅ automatic | ✅ when prompted | ✅ when prompted | ✅ when prompted | ✅ output to user |
| Submit proposals directly | ❌ user-mediated | ❌ user-mediated | ❌ user-mediated | ❌ user-mediated | ❌ user-mediated |
| Enforce governance rules | ✅ built-in | ❌ honor system | ❌ honor system | ✅ PR policies | ❌ honor system |
| Verify SHA256 | ✅ session start | ❌ | ❌ | ❌ | ❌ |
| Access repo directly | ✅ local clone | ❌ | ❌ | ✅ IDE | ❌ |

---

## What This Means Per AI

### Claude
Has the most capability. Auto-updates `ack.json`, runs daily snapshot, verifies SHA256. Governance is enforced mechanically through Claude Code hooks, not just through rules.

### GPT
No file access. User must paste rule files into the chat. GPT produces the acknowledgment JSON and any proposal blocks; user manually commits them. Honor system for governance rules — nothing enforces them mechanically.

### Gemini
Same as GPT. User-pasted input, user-committed output. No automated hooks or verification.

### Copilot
Has IDE file access but no connection to this repo's automation. Copilot can write files in the repos it's working in, but it doesn't have access to `.claude/settings.json` hooks or the daily snapshot script. Governance enforcement via GitHub PR checks (branch protection, required reviews) — not rule-based.

### Ollama
Local inference only. Cannot write files, cannot make network requests (depends on configuration), cannot run hooks. Entire interaction is through the Modelfile SYSTEM block baked in at deploy time. User must manually update `ollama.ack.json` by running a local model and capturing its output.

---

## Implications for Rule Design

Rules that assume file write access (e.g., "update `acknowledgments/{ai}.ack.json`") only apply to Claude automatically. For other AIs, the rule means "produce the JSON; user will commit it."

Rules that reference `.claude/settings.json` or hooks are Claude-specific. When writing rules for other AIs, these sections either don't apply or need AI-specific equivalents.

This is why `{ai}.md > universal.md` matters: the universal rules are written for the common case. AI-specific files handle the capability differences.
