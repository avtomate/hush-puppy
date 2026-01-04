#!/bin/bash
set -e

VERSION="1.1.0"
SCRIPTS_DIR="$HOME/.claude/scripts"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "🐕 Uninstalling Hush Puppy..."

# Remove the scripts
for script in notify-input.sh clear-title.sh; do
    if [ -f "$SCRIPTS_DIR/$script" ]; then
        rm "$SCRIPTS_DIR/$script"
        echo "✓ Removed $script"
    fi
done

# Remove hooks from settings.json
if [ -f "$SETTINGS_FILE" ]; then
    if command -v jq &> /dev/null; then
        # Remove all hush-puppy hooks with jq
        jq 'del(.hooks.Stop, .hooks.PreToolUse, .hooks.UserPromptSubmit)' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
        # Remove hooks object if empty
        jq 'if .hooks == {} then del(.hooks) else . end' "$SETTINGS_FILE.tmp" > "$SETTINGS_FILE"
        rm "$SETTINGS_FILE.tmp"
        echo "✓ Removed hooks from settings.json"
    else
        echo "⚠️  Please manually remove these hooks from $SETTINGS_FILE:"
        echo "   - UserPromptSubmit"
        echo "   - PreToolUse"
        echo "   - Stop"
        echo "   (Install jq for automatic removal)"
    fi
fi

# Restore backup if it exists
if [ -f "$SETTINGS_FILE.backup" ]; then
    echo ""
    echo "💡 A backup of your original settings exists at $SETTINGS_FILE.backup"
fi

echo ""
echo "✅ Hush Puppy uninstalled!"
echo "Restart Claude Code to apply changes."
