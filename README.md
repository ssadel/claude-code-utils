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

Like `/a`, but shows you the implementation plan first — what files would change, what the approach is — then waits for your approval before doing anything.

```
/dr Refactor the API routes into separate modules
```

### `/scp` — Stage, Commit, Push

Stage all changes, commit with a descriptive message, and push to the current branch. Optionally pass a commit message.

```
/scp
/scp Fix login redirect bug
```

### `/install-statusline` — Status Line

Installs a custom two-line status line that displays useful context at the bottom of your terminal:

```
📁 my-project | 🌿 main | 🤖 Opus 4.6 | 📊 ctx: 23%
💲 session: $12.40 | 📨 ctx cost: ~$0.35/msg
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
| 💲 Session | Total cost of the current session, sourced directly from Claude Code |
| 📨 Ctx cost | Approximate cost of the next message, based on the last message's actual cost |

**How ctx cost works:** Each message sends the entire conversation history as input, so cost grows as context grows. Rather than using hardcoded token rates (which vary by model, fast mode, etc.), the script tracks the delta in Claude Code's own `total_cost_usd` between messages. The last message's cost is used as an approximation for the next. This is model-agnostic and accounts for fast mode, caching, and any other pricing factors automatically.

Zero dependencies beyond [`jq`](https://jqlang.github.io/jq/download/) and standard macOS tools. Run the skill and choose project-level or user-level installation.

## License

MIT
