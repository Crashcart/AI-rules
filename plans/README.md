# Plans

The repo is the PROJECT MANAGER's memory. Plans committed here survive context compaction, session resets, and container recycling. Plans not committed here do not exist.

## Structure

```
plans/
├── active/      ← work in progress; read at every session start
└── archive/     ← completed or superseded plans
```

## Active Plan Format

Every file in `active/` must contain these headers:

```markdown
## Status
active | blocked | complete | superseded

## Goal
One sentence — what "done" looks like.

## Next Action
The single next thing to do, and who does it.

## Context
Non-obvious constraints the next session needs.
```

## Lifecycle

1. **Create** — when work spans more than one session or requires more than one role
2. **Update** — when the initiative changes direction or a milestone is reached
3. **Archive** — move to `plans/archive/` with a `## Completed: YYYY-MM-DD` header when done

## Rule

RULE 23 in `rules/universal.md` makes plan persistence mandatory. Plans not committed before session end are violations of RULE 23.
