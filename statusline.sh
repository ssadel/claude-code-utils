#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name' | sed 's/^Claude //')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

dir=$(basename "$cwd")

if [ -n "$branch" ] && [ ${#branch} -gt 15 ]; then
  branch="$(echo "$branch" | cut -c1-15)..."
fi
if [ ${#dir} -gt 15 ]; then
  dir="$(echo "$dir" | cut -c1-15)..."
fi

parts="📁 $dir"
[ -n "$branch" ] && parts="$parts | 🌿 $branch"
parts="$parts | 🤖 $model"
[ -n "$used" ] && parts="$parts | 📊 ctx: $(printf '%.0f' "$used")%"

printf "%s" "$parts"
