#!/bin/bash
# Clear window title when Claude is working
PARENT_PID=$$
while [ "$PARENT_PID" != "1" ]; do
    TTY=$(ps -o tty= -p "$PARENT_PID" 2>/dev/null | tr -d ' ')
    if [ -n "$TTY" ] && [ "$TTY" != "?" ]; then
        printf '\033]0;\007' > "/dev/$TTY" 2>/dev/null && exit 0
    fi
    PARENT_PID=$(ps -o ppid= -p "$PARENT_PID" 2>/dev/null | tr -d ' ')
done
