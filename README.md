# Claude Code Status Line

A custom status line for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that displays useful context at the bottom of your terminal.

```
📁 my-project | 🌿 main | 🤖 Opus 4.6 | 📊 ctx: 23%
```

## What it shows

| Field | Description |
|-------|-------------|
| 📁 Directory | Current working directory (truncated to 15 chars) |
| 🌿 Branch | Current git branch (truncated to 15 chars) |
| 🤖 Model | Active Claude model |
| 📊 Context | Context window usage percentage |

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- [`jq`](https://jqlang.github.io/jq/download/) installed

## Installation

### Option 1: Using the included skill

1. Copy the `.claude/skills/install-statusline/` directory into your project's `.claude/skills/` folder (or `~/.claude/skills/` for global access).
2. Run the skill in Claude Code:
   ```
   /install-statusline
   ```
3. Choose project-level or user-level installation when prompted.
4. Restart Claude Code.

### Option 2: Manual setup

1. Copy `statusline.sh` to your desired location:

   **Project level** (shared with collaborators):
   ```sh
   mkdir -p .claude
   cp statusline.sh .claude/statusline.sh
   chmod +x .claude/statusline.sh
   ```

   **User level** (all projects, personal):
   ```sh
   cp statusline.sh ~/.claude/statusline.sh
   chmod +x ~/.claude/statusline.sh
   ```

2. Add the status line config to your `settings.json`:

   **Project level** (`.claude/settings.json`):
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "bash .claude/statusline.sh"
     }
   }
   ```

   **User level** (`~/.claude/settings.json`):
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "bash ~/.claude/statusline.sh"
     }
   }
   ```

3. Restart Claude Code.

## Customization

Edit `statusline.sh` to add, remove, or reformat fields. The script receives a JSON payload from Claude Code via stdin with the following structure:

```json
{
  "workspace": { "current_dir": "/path/to/project" },
  "model": { "display_name": "Claude Opus 4.6" },
  "context_window": { "used_percentage": 23.5 }
}
```

## License

MIT
