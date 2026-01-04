#!/bin/bash
set -e

SCRIPT_URL="https://raw.githubusercontent.com/avtomate/hush-puppy/master/scripts/notify-input.sh"
SCRIPTS_DIR="$HOME/.claude/scripts"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "🐕 Installing Hush Puppy..."

# Create scripts directory
mkdir -p "$SCRIPTS_DIR"

# Download the notification script
curl -fsSL "$SCRIPT_URL" -o "$SCRIPTS_DIR/notify-input.sh"
chmod +x "$SCRIPTS_DIR/notify-input.sh"

# Add hooks to settings.json
HOOK_CONFIG='{
  "hooks": {
    "Stop": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/scripts/notify-input.sh"
      }]
    }]
  }
}'

if [ -f "$SETTINGS_FILE" ]; then
    # Backup existing settings
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"

    if command -v jq &> /dev/null; then
        # Merge with jq
        jq -s '.[0] * .[1]' "$SETTINGS_FILE" <(echo "$HOOK_CONFIG") > "$SETTINGS_FILE.tmp"
        mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
    else
        # Simple merge without jq - add hooks if not present
        if grep -q '"hooks"' "$SETTINGS_FILE"; then
            echo "⚠️  settings.json already has hooks. Please manually add the Stop hook."
            echo "   Backup saved to $SETTINGS_FILE.backup"
            echo ""
            echo "Add this to your hooks:"
            echo '    "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/notify-input.sh"}]}]'
        else
            # Remove closing brace, add hooks, close brace
            sed -i '$ d' "$SETTINGS_FILE"
            echo '  ,"hooks": {"Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/scripts/notify-input.sh"}]}]}' >> "$SETTINGS_FILE"
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
