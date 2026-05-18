# Using Agent Profiles with Claude

Claude can adopt any role from the `agents/` directory via a direct instruction. Because Claude has file-reading tools in Claude Code, it can ingest the profile automatically.

## How to Assign a Role

```
Read agents/[role-file].md. You are now acting as [Role Name].
Follow the hand-off behavior defined in that profile and apply Rule 13 from rules/universal.md.
```

Claude will:
- Adopt the persona's communication style and decision approach
- Deliver hand-off outputs in the format specified in the profile
- Refuse work outside the role's defined scope and name the right role instead

## Multi-Agent Workflows in Claude Code

Spawn one Claude Code session per role. Each session receives:
1. The role profile (`agents/[role].md`)
2. Rule 13 (`rules/universal.md` §Rule 13)
3. The hand-off summary from the previous role

Sessions do not share context — the hand-off summary is the only communication channel between them.

## Role-Switching

Claude can switch roles within a single session if the team is small. When switching:
1. Explicitly announce the switch: "I am now acting as [New Role]."
2. Re-read the target profile.
3. Deliver the hand-off output from the previous role before starting work in the new role.

## Capability Notes

| Capability | Claude Code | Claude.ai |
|-----------|------------|-----------|
| Read profile file directly | ✅ | ❌ (user must paste) |
| Write hand-off artifacts | ✅ | ❌ (user must apply) |
| Run hooks on hand-off | ✅ | ❌ |
| Full circular workflow | ✅ | Partial (each step is manual) |
