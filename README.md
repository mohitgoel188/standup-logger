# Standup Logger

A Claude Code plugin that automatically logs your daily work and generates ready-to-speak standup summaries.

## Features

- **Auto-logging**: SessionEnd hook captures a placeholder entry when you forget to log before exiting
- **Jira integration**: Automatically extracts Jira ticket IDs from git branch names and commit messages
- **Multi-project**: Multiple projects append to the same daily file
- **Monday-aware**: Weekend standups combine Friday, Saturday, and Sunday entries
- **Spoken-ready**: Output is formatted for a 30-second standup update

## Commands

### `/standup-log`
Logs the current session's work to `~/.claude/standup/YYYY-MM-DD.md`. Auto-triggers when you wrap up a session (say "done", "bye", etc.) or invoke manually anytime.

### `/standup`
Reads yesterday's and today's log files and generates a standup summary with:
- **Yesterday** — what you accomplished (grouped by project)
- **Today** — what you're planning
- **Blockers** — prompts you to mention any

## How it works

### Log format
```markdown
# 2026-03-16

## web-dashboard (14:30)
- PROJ-142: Added dark mode toggle to settings page
- PROJ-142: Fixed navbar contrast in dark theme

## api-server (16:45)
- PROJ-198: Migrated user endpoints from REST to GraphQL
```

### SessionEnd hook
When a session ends without `/standup-log` being run, the hook appends a placeholder:
```markdown
## my_project (18:30)
- PROJ-142: (session ended without logging — fill in next session)
```

This ensures you always have *something* in your standup file, even if you forgot to log.

## Installation

```bash
claude plugins install standup-logger
```

Or install from GitHub:
```bash
claude plugins marketplace add --source github --repo <your-username>/standup-logger
claude plugins install standup-logger@<your-username>-standup-logger
```

## Configuration

### Extend SessionEnd hook timeout (optional)
Add to your environment if the default 1.5s is too short:
```bash
export CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS=5000
```

## Requirements

- Claude Code v2.0+
- Git (for branch name / commit Jira ID extraction)
- Bash (for the SessionEnd hook script)

## License

MIT
