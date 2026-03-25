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

Installs a custom status line that displays useful context at the bottom of your terminal:

```
📁 my-project | 🌿 main | 🤖 Opus 4.6 | 📊 ctx: 23%
```

| Field | Description |
|-------|-------------|
| 📁 Directory | Current working directory (truncated to 15 chars) |
| 🌿 Branch | Current git branch (truncated to 15 chars) |
| 🤖 Model | Active Claude model |
| 📊 Context | Context window usage percentage |

Requires [`jq`](https://jqlang.github.io/jq/download/). Run the skill and choose project-level or user-level installation.

## License

MIT
