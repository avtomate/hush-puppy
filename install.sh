#!/bin/bash
set -e

VERSION="1.1.0"
BASE_URL="https://raw.githubusercontent.com/avtomate/hush-puppy/master/scripts"
SCRIPTS_DIR="$HOME/.claude/scripts"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "🐕 Installing Hush Puppy v$VERSION..."

# Create scripts directory
mkdir -p "$SCRIPTS_DIR"

# Download scripts
curl -fsSL "$BASE_URL/notify-input.sh" -o "$SCRIPTS_DIR/notify-input.sh"
curl -fsSL "$BASE_URL/clear-title.sh" -o "$SCRIPTS_DIR/clear-title.sh"
chmod +x "$SCRIPTS_DIR/notify-input.sh" "$SCRIPTS_DIR/clear-title.sh"

# Hook configuration with all 3 hooks
HOOK_CONFIG='{
  "hooks": {
    "UserPromptSubmit": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/clear-title.sh"}]}],
    "PreToolUse": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/clear-title.sh"}]}],
    "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/notify-input.sh"}]}]
  }
}'

if [ -f "$SETTINGS_FILE" ]; then
    # Backup existing settings
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"

    if command -v jq &> /dev/null; then
        # Merge with jq
        echo "$HOOK_CONFIG" > "$SETTINGS_FILE.hook"
        jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$SETTINGS_FILE.hook" > "$SETTINGS_FILE.tmp"
        mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        rm "$SETTINGS_FILE.hook"
    else
        # Simple merge without jq - add hooks if not present
        if grep -q '"hooks"' "$SETTINGS_FILE"; then
            echo "⚠️  settings.json already has hooks. Please manually merge the hooks."
            echo "   Backup saved to $SETTINGS_FILE.backup"
            echo ""
            echo "Add these hooks to your settings.json:"
            echo '    "UserPromptSubmit": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/clear-title.sh"}]}]'
            echo '    "PreToolUse": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/clear-title.sh"}]}]'
            echo '    "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/notify-input.sh"}]}]'
        else
            # Remove closing brace, add hooks, close brace
            sed '$ d' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
            mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
            echo '  ,"hooks": {"UserPromptSubmit": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/clear-title.sh"}]}], "PreToolUse": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/clear-title.sh"}]}], "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/notify-input.sh"}]}]}' >> "$SETTINGS_FILE"
            echo '}' >> "$SETTINGS_FILE"
        fi
    fi
else
    # Create new settings file
    echo "$HOOK_CONFIG" > "$SETTINGS_FILE"
fi

echo "✅ Hush Puppy installed!"
echo ""
echo "Restart Claude Code to activate tab notifications."
echo "Your tab will show 🔴 INPUT NEEDED when Claude needs your input."
