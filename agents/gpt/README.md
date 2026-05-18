# Using Agent Profiles with GPT / OpenAI

GPT cannot read files directly — the user must paste the profile content. Use the system message to inject the role.

## How to Assign a Role

Paste the contents of `agents/[role-file].md` into the **system message**:

```
You are acting as [Role Name]. Here is your profile:

[PASTE CONTENTS OF agents/role-file.md HERE]

Follow the hand-off behavior defined in the profile. Apply Rule 13 (circular hand-off workflow):
- Receive from: [previous role]
- Deliver: [hand-off format from profile]
- Pass to: [next role]
```

## Multi-Agent Workflows

Each role requires a separate GPT conversation with its own system message. The hand-off summary from one conversation must be manually copied into the next conversation's first user message.

Recommended workflow:
1. Open a new chat for each role
2. Set the system message to the role profile
3. Paste the previous role's hand-off summary as the first user message
4. Receive the role's output
5. Copy the output as the hand-off summary for the next chat

## Capability Notes

| Capability | GPT-4o | GPT-4 |
|-----------|--------|-------|
| Read profile file | ❌ (user pastes) | ❌ (user pastes) |
| Browse repo | ✅ with plugin | ❌ |
| Write files | ❌ (user applies) | ❌ (user applies) |
| Full circular workflow | Manual | Manual |

## Acknowledgment

GPT must be given `rules/universal.md` + `rules/gpt.md` and asked to produce an acknowledgment JSON for `acknowledgments/gpt.ack.json`. The user then pastes it into the repo.
