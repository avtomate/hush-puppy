# Hush Puppy 🐕

Quiet, visual tab notifications for [Claude Code](https://github.com/anthropics/claude-code). Never miss when Claude needs your input.

![Demo](https://img.shields.io/badge/🔴_INPUT_NEEDED-myproject-red?style=for-the-badge)

## Why?

When running multiple Claude Code sessions, it's hard to know which tab needs attention. This hook changes the terminal tab title to **🔴 INPUT NEEDED - [project]** when Claude finishes and is waiting for your input.

No sounds. No popups. Just a quiet visual indicator.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/avtomate/hush-puppy/master/install.sh | bash
```

Then restart Claude Code.

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/avtomate/hush-puppy/master/uninstall.sh | bash
```

## How it works

Uses Claude Code's [hooks system](https://docs.anthropic.com/en/docs/claude-code/hooks) to run a script when Claude stops responding. The script:

1. Reads the current working directory from the hook context
2. Finds the parent terminal's TTY
3. Sets the tab title using ANSI escape sequences

## Compatibility

- **Linux** ✅ (tested on WSL2 + Windows Terminal)
- **macOS** ✅ (should work, untested)
- **Windows** ⚠️ (WSL only)

## Manual Install

If you prefer not to pipe to bash:

```bash
git clone https://github.com/avtomate/hush-puppy.git /tmp/hush-puppy
cd /tmp/hush-puppy && ./install.sh
rm -rf /tmp/hush-puppy
```

## Related

- [Feature Request #7229](https://github.com/anthropics/claude-code/issues/7229) - Vote for built-in support!

## License

MIT
