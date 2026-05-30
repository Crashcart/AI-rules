List all available slash commands. Read the `.claude/commands/` directory to find every command file, then produce a formatted reference.

Format:

---
## Available Commands

### Project Tracking
/report                    — Full portfolio report (all projects)
/report <repo-name>        — Report for one project
/new-project <repo-name>   — Onboard a new project (team check + tracking file)

### Rules Management
/update-rules              — Pull latest AI-rules into this repo (no confirmation needed)

### Help
/help                      — This list

---

If any commands exist in `.claude/commands/` that are not in the list above, add them.
Keep descriptions to one line each.
