# Using Agent Profiles with Gemini

Gemini uses a role-instruction format. Inject the profile via the system instruction field (Gemini API) or at the top of the first message (Gemini.google.com).

## How to Assign a Role

**Via Gemini API (`system_instruction` field):**

```json
{
  "system_instruction": {
    "parts": [{
      "text": "You are acting as [Role Name].\n\n[PASTE CONTENTS OF agents/role-file.md]\n\nApply Rule 13 from the AI-rules circular hand-off workflow. Receive from [previous role]. Deliver the hand-off format specified in your profile. Pass to [next role]."
    }]
  }
}
```

**Via Gemini.google.com:**

Paste at the top of your first message:
```
ROLE: [Role Name]

[PASTE CONTENTS OF agents/role-file.md]

Apply Rule 13: receive from [previous role], deliver [hand-off format], pass to [next role].
```

## Multi-Agent Workflows

Gemini supports multi-turn conversations within one session — use that for single-role work. For full circular workflows, use a separate Gemini chat per role and pass the hand-off summary manually between chats.

## Gemini 1.5 Pro Context Advantage

Gemini 1.5 Pro has a 1M-token context window. This means you can paste multiple role profiles and a large project context into a single conversation and ask Gemini to simulate multiple roles sequentially. Explicitly announce each role transition.

## Capability Notes

| Capability | Gemini 1.5 Pro | Gemini 1.0 |
|-----------|----------------|------------|
| Read profile file | ❌ (user pastes) | ❌ |
| Long context (multiple profiles) | ✅ 1M tokens | ❌ 32K tokens |
| Write files | ❌ (user applies) | ❌ |
| Google Workspace integration | ✅ | Partial |

## Acknowledgment

Give Gemini `rules/universal.md` + `rules/gemini.md` and ask it to produce the acknowledgment JSON for `acknowledgments/gemini.ack.json`. The user pastes it into the repo.
