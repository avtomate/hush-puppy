#!/bin/bash
# Read JSON from stdin (hook context)
INPUT=$(cat)

# Extract cwd using grep/sed (no jq needed)
CWD=$(echo "$INPUT" | grep -o '"cwd"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*:.*"\([^"]*\)"/\1/')
PROJECT=$(basename "$CWD" 2>/dev/null)
[ -z "$PROJECT" ] && PROJECT="Claude Code"

# Find parent's TTY and write to it
PARENT_PID=$$
while [ "$PARENT_PID" != "1" ]; do
    TTY=$(ps -o tty= -p "$PARENT_PID" 2>/dev/null | tr -d ' ')
    if [ -n "$TTY" ] && [ "$TTY" != "?" ]; then
        printf '\033]0;🔴 INPUT NEEDED - %s\007' "$PROJECT" > "/dev/$TTY" 2>/dev/null && exit 0
    fi
    PARENT_PID=$(ps -o ppid= -p "$PARENT_PID" 2>/dev/null | tr -d ' ')
done
