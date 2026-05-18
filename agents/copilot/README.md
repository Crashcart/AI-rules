# Using Agent Profiles with GitHub Copilot

Copilot operates inside the IDE. Role profiles can be injected via `.github/copilot-instructions.md` (repo-level) or as inline comments at the top of a file.

## How to Assign a Role (Repo-Level)

Add to `.github/copilot-instructions.md`:

```markdown
## Active Agent Role

You are acting as [Role Name]. Profile:

[PASTE CONTENTS OF agents/role-file.md]

Apply Rule 13 from rules/universal.md: receive from [previous role], deliver [hand-off format], pass to [next role].
```

This applies the role to all Copilot suggestions in the repo.

## How to Assign a Role (File-Level)

Add at the top of the file you are working in:

```typescript
// AGENT ROLE: [Role Name]
// Applies: agents/[role-file].md — [one-line summary of role]
// Circular workflow position: receives from [prev], hands off to [next]
```

## Copilot Chat

In Copilot Chat, paste the profile in your first message:

```
Act as [Role Name]. Profile: [PASTE PROFILE CONTENT]. 
Now help me with: [your task]
```

## Multi-Agent Workflows with Copilot

Copilot is best suited to single-role work. For full circular workflows, assign a different role in `.github/copilot-instructions.md` for each phase of development, committing the change before starting the next phase.

## Capability Notes

| Capability | Copilot (IDE) | Copilot Chat |
|-----------|--------------|-------------|
| Read profile file | ✅ via copilot-instructions.md | ❌ user pastes |
| Write files | ✅ suggestions only | ✅ with /new |
| PR review with role context | ✅ | ✅ |
| Enforce role hand-off | ❌ (honor system) | ❌ |

## Acknowledgment

Give Copilot `rules/universal.md` + `rules/copilot.md` in a chat session and ask it to produce the acknowledgment JSON for `acknowledgments/copilot.ack.json`. The user pastes it into the repo.
