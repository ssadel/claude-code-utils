---
name: scp
description: "Stage all changes, commit with a descriptive message, and push to the current branch."
argument-hint: "optional commit message"
---

Stage all current changes, create a commit, and push to the current branch. If $ARGUMENTS is provided, use it as the commit message. Otherwise, generate a concise descriptive commit message based on the staged changes.

Follow the git commit instructions from the system prompt (use HEREDOC, include co-authored-by, etc). Do NOT amend existing commits — always create a new one.

$ARGUMENTS
