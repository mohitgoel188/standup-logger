# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code plugin that auto-logs daily work and generates ready-to-speak standup summaries. It provides two slash commands (`/standup-log`, `/standup`) and a SessionEnd hook that creates placeholder entries when users forget to log before exiting.

## Architecture

This is a **Claude Code plugin** (not a traditional app with build/test tooling). There is no build step, no package manager, and no test suite.

### Key components:

- **`.claude-plugin/plugin.json`** — Plugin manifest (name, version, description, keywords)
- **`.claude-plugin/marketplace.json`** — GitHub-based marketplace installation metadata
- **`commands/standup-log.md`** — Slash command that appends session work to `~/.claude/standup/YYYY-MM-DD.md`. Extracts Jira IDs from git branches and commits. Does NOT query Jira API — only uses ticket info already in the session.
- **`commands/standup.md`** — Slash command that reads log files and generates Yesterday/Today/Blockers summary. Monday-aware: combines Friday+Saturday+Sunday entries.
- **`hooks/hooks.json`** — Registers the SessionEnd hook with a 5-second timeout
- **`hooks/standup-check.sh`** — Bash script triggered on session end. If the current project wasn't logged today, appends a placeholder entry with Jira ID from the current branch.

### Data flow:

1. During a session: `/standup-log` writes to `~/.claude/standup/YYYY-MM-DD.md`
2. On session exit without logging: `standup-check.sh` appends a placeholder to the same file
3. Before standup: `/standup` reads yesterday's + today's files and formats a spoken summary

### Log file format:

```markdown
# YYYY-MM-DD

## project-name (HH:MM)
- JIRA-ID: Description of work done
```

Multiple projects append sections to the same daily file.

## Installation

```bash
claude plugins install standup-logger
```

## Shell hook note

The `standup-check.sh` script uses `grep -oP` (Perl-compatible regex) which may not work on macOS default grep. If modifying regex patterns, ensure PCRE compatibility or use an alternative.
