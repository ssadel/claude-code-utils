---
name: install-statusline
description: "Install the Claude Code status line. Shows directory, git branch, model, and context window usage at the bottom of your terminal."
argument-hint: "Install the status line (project or user level)"
---

You are installing the Claude Code status line for the user.

## Steps

1. **Ask the user** whether they want to install the status line at:
   - **Project level** — installs into the current project's `.claude/` directory (shared with collaborators via git)
   - **User level** — installs into `~/.claude/` (applies to all projects, personal only)

2. **Copy the script:**
   - **Project level:** Copy the contents of the `statusline.sh` file from this repository into `.claude/statusline.sh` in the current working directory. Create the `.claude/` directory if it doesn't exist. Make it executable.
   - **User level:** Copy the contents of the `statusline.sh` file from this repository into `~/.claude/statusline.sh`. Make it executable.

3. **Update settings.json:**
   - **Project level:** Add or update `.claude/settings.json` in the current working directory with:
     ```json
     {
       "statusLine": {
         "type": "command",
         "command": "bash .claude/statusline.sh"
       }
     }
     ```
   - **User level:** Add or update `~/.claude/settings.json` with:
     ```json
     {
       "statusLine": {
         "type": "command",
         "command": "bash ~/.claude/statusline.sh"
       }
     }
     ```
   - If the settings file already exists, merge the `statusLine` key into the existing JSON — do NOT overwrite other settings.

4. **Confirm** to the user that the status line has been installed and tell them to restart Claude Code to see it.

## Important
- Requires `jq` to be installed. If `jq` is not available, warn the user.
- Do NOT modify any other settings besides `statusLine`.

$ARGUMENTS
