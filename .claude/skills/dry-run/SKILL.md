---
name: dr
description: "Preview exactly what would happen before it happens. Code changes are made in an isolated worktree; external actions show the exact content that would be sent."
argument-hint: "Describe what you want done — see the exact result before it's applied"
---

The user wants to see the REAL output before anything is applied. Do not describe what you would do — show exactly what would happen.

Determine whether the task involves **code changes**, **external actions**, or both, and follow the appropriate mode.

## Code changes

1. **Spawn an agent in a worktree** using `isolation: "worktree"`. Give the agent the user's full request and instruct it to make all the code changes.
2. **Show the diff** — once the agent finishes, present the complete `git diff` from the worktree so the user can see every line that changed.
3. **Wait for approval** — do NOT apply anything to the real codebase until the user explicitly approves.
4. **If approved**, apply the same changes to the real working directory.
5. **If rejected or adjusted**, discard the worktree and follow the user's feedback.

## External actions (tickets, comments, API calls, etc.)

1. **Do the research** — read whatever context is needed to produce the real output.
2. **Show the exact content** — present the full payload as it would be sent: ticket title and body, comment text, API parameters, etc. No summaries or placeholders.
3. **Wait for approval** — do NOT execute until the user explicitly approves.
4. **If approved**, execute the action exactly as previewed.
5. **If rejected or adjusted**, revise based on the user's feedback.

## Rules

- Never summarize or truncate the preview. Show everything.
- Never execute actions or apply changes until the user approves.
- If the task involves both code and external actions, preview both before applying either.

$ARGUMENTS
