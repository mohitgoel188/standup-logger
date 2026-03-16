#!/bin/bash
# SessionEnd hook: If today's standup wasn't logged for this project,
# append a placeholder reminder entry so user knows to fill it in next session.

TODAY=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
STANDUP_DIR="$HOME/.claude/standup"
STANDUP_FILE="$STANDUP_DIR/$TODAY.md"
PROJECT_NAME=$(basename "$PWD")

# Ensure directory exists
mkdir -p "$STANDUP_DIR"

# If already logged for this project today, nothing to do
if [ -f "$STANDUP_FILE" ] && grep -q "## $PROJECT_NAME" "$STANDUP_FILE"; then
    exit 0
fi

# Extract Jira ID from current git branch (if in a git repo)
JIRA_ID=""
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    JIRA_ID=$(echo "$BRANCH" | grep -oP '^[A-Z]+-\d+' 2>/dev/null)
fi

# Build the entry
ENTRY=""
if [ ! -f "$STANDUP_FILE" ]; then
    ENTRY="# $TODAY\n\n"
fi

ENTRY+="## $PROJECT_NAME ($TIME)\n"
if [ -n "$JIRA_ID" ]; then
    ENTRY+="- $JIRA_ID: (session ended without logging — fill in next session)\n"
else
    ENTRY+="- (session ended without logging — fill in next session)\n"
fi

# Append to file
echo -e "\n$ENTRY" >> "$STANDUP_FILE"
