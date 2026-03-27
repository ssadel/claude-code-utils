# Claude Code Utils

A collection of utilities and skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Skills

Copy any skill's directory into your project's `.claude/skills/` folder (or `~/.claude/skills/` for global access).

### `/q` — Question

Ask Claude a question without it taking any actions. No edits, no writes, no commits. It will only read code, search, and respond.

```
/q How does the auth middleware work?
```

### `/a` — Action

Tell Claude to just do the thing. Edit files, write code, run commands — get it done.

```
/a Add input validation to the signup form
```

### `/dr` — Dry Run

Preview exactly what would happen before it happens. For code changes, Claude makes the real edits in an isolated worktree and shows you the full diff. For external actions (tickets, comments, API calls), it shows the exact content that would be sent. Nothing is applied until you approve.

```
/dr Refactor the API routes into separate modules
/dr Create a Linear ticket for the auth bug
```

### `/scp` — Stage, Commit, Push

Stage all changes, commit with a descriptive message, and push to the current branch. Optionally pass a commit message.

```
/scp
/scp Fix login redirect bug
```

### `/install-statusline` — Status Line

Installs a custom status line that displays useful context at the bottom of your terminal:

```
📁 my-project | 🌿 main | 🤖 Opus 4.6 | 📊 ctx: 23%
💲 session: $12.40
```

### Line 1: Session Info

| Field | Description |
|-------|-------------|
| 📁 Directory | Current working directory (truncated to 15 chars) |
| 🌿 Branch | Current git branch (truncated to 15 chars) |
| 🤖 Model | Active Claude model |
| 📊 Context | Context window usage percentage |

### Line 2: Cost Tracking

| Field | Description |
|-------|-------------|
| 💲 Session | Total session cost. Uses Claude Code's `total_cost_usd` directly. |

**Resume-persistent:** When you resume a session, Claude Code resets `total_cost_usd` to 0. The status line detects this and recovers the pre-resume cost by parsing the full transcript JSONL, calculating from token counts and per-model rates. The recovered cost is cached and shown with a `~` prefix (e.g., `~$8.52`) to indicate it includes an estimated portion.

**Unknown models:** If the current model isn't in the hardcoded rate table, the status line shows `⚠️ unknown model: <model_id>` on a third line so you know the rates need updating.

Zero dependencies beyond [`jq`](https://jqlang.github.io/jq/download/) and standard macOS tools. Run the skill and choose project-level or user-level installation.

## License

MIT
