---
name: standup-log
description: Log current session work to the daily standup file. Use this PROACTIVELY at the end of every coding session — whenever you are about to stop, finish a task, or the user says goodbye/done/that's it/wrap up. Also use when the user explicitly asks to log work. Appends a brief summary with Jira ticket IDs to ~/.claude/standup/YYYY-MM-DD.md so the user has a ready-made standup log. MUST be invoked before session ends.
---

# Standup Logger

You are logging the work done in this session to build a daily standup journal.

## What to capture

Summarize what was accomplished in this session. Focus on **outcomes**, not process — what changed, what was built, what was fixed. Keep each bullet to one line.

### Jira ticket detection

Extract Jira ticket IDs from these sources (in priority order):
1. **Current git branch name** — e.g., `PROJ-142-dark-mode-settings` → `PROJ-142`
2. **Recent commit messages** from this session — look for patterns like `PROJ-142`, `ENG-567`
3. **Jira context already loaded** in this conversation — if the user fetched a Jira ticket earlier, use that ticket ID and title

Do NOT query Jira API just for this logging step. Only use ticket info already available in the session.

If no Jira ID is found, log the entry without one — that's fine.

## Output format

Append to `~/.claude/standup/YYYY-MM-DD.md` (today's date). Create the file if it doesn't exist.

The file format is:

```markdown
# YYYY-MM-DD

## project-name (HH:MM)
- JIRA-ID: Brief description of what was done
- JIRA-ID: Another thing that was done
- Brief description without ticket if no ID available
```

Where:
- `project-name` is the current working directory's basename (e.g., `stock_transfer`)
- `HH:MM` is the current time in 24h format
- Each bullet is a concise summary of one logical piece of work

If the file already exists (another project logged earlier today), append a new `## project-name` section — do NOT overwrite existing content.

## Steps

1. Run `git branch --show-current` to get the current branch and extract any Jira ID
2. Run `git log --oneline -10 --since="today"` to find recent commits and their Jira IDs
3. Review the conversation history to identify what was accomplished
4. Compose the summary bullets
5. Append to the standup file

## Example

```markdown
# 2026-03-16

## web-dashboard (14:30)
- PROJ-142: Added dark mode toggle to settings page
- PROJ-142: Fixed navbar contrast in dark theme

## api-server (16:45)
- PROJ-198: Migrated user endpoints from REST to GraphQL
```

Keep it brief. This is for a 30-second standup update, not a detailed changelog.
