---
name: standup
description: Generate daily standup content from your work log. Use when the user asks for standup notes, what they did yesterday, what to say in standup, scrum update, daily sync, or mentions preparing for a standup meeting. Reads the standup log files and presents a ready-to-speak summary.
---

# Standup Reader

Generate a ready-to-speak standup summary from the work logs in `~/.claude/standup/`.

## Date logic

- **Tuesday through Friday**: Read today's file (D) and yesterday's file (D-1)
- **Monday**: Read today's file (D) plus **Friday, Saturday, and Sunday** files (D-3, D-2, D-1) to cover the full weekend — all three days matter since work may have happened on any of them

If a date file doesn't exist, that's fine — just skip it. If no files exist at all, tell the user there are no logged entries.

## Output format

Present the standup in this spoken-ready format:

```
### Yesterday (what I did)
- [Combined bullets from D-1 files, grouped by project]

### Today (what I plan to do)
- [Bullets from today's D file if any exist, otherwise ask the user what they're planning]

### Blockers
- [Ask the user if they have any blockers]
```

For Monday standups, the "Yesterday" section header becomes "**Over the weekend**" and includes all entries from Friday + Saturday + Sunday.

## Steps

1. Determine today's day of week
2. Calculate which date files to read:
   - D = today (`YYYY-MM-DD.md`)
   - D-1 = yesterday (or Friday/Sat/Sun if Monday)
3. Read the files from `~/.claude/standup/`
4. Combine entries, grouping by project
5. Present in the standup format
6. Ask the user about today's plans and blockers

## Example output (Tuesday)

```
### Yesterday
**web-dashboard**
- PROJ-142: Added dark mode toggle to settings page
- PROJ-142: Fixed navbar contrast in dark theme

**api-server**
- PROJ-198: Migrated user endpoints from REST to GraphQL

### Today
What are you planning to work on today?

### Blockers
Any blockers to mention?
```

## Example output (Monday)

```
### Over the weekend
**Friday (2026-03-13)**
- PROJ-142: Completed dark mode for all settings panels
- PROJ-205: Fixed webhook retry logic on timeout

**Saturday (2026-03-14)**
- PROJ-142: Added snapshot tests for dark mode components

### Today
What are you planning to work on today?

### Blockers
Any blockers to mention?
```

Keep the output concise and conversational — this is meant to be read aloud in a 30-second update.
