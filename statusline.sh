#!/bin/sh

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name' | sed 's/^Claude //')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
session_id=$(echo "$input" | jq -r '.session_id // empty')
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

dir=$(basename "$cwd")

if [ -n "$branch" ] && [ ${#branch} -gt 15 ]; then
  branch="$(echo "$branch" | cut -c1-15)..."
fi
if [ ${#dir} -gt 15 ]; then
  dir="$(echo "$dir" | cut -c1-15)..."
fi

# ── Line 1: Info ──
line1="📁 $dir"
[ -n "$branch" ] && line1="$line1 | 🌿 $branch"
line1="$line1 | 🤖 $model"
[ -n "$used" ] && line1="$line1 | 📊 ctx: $(printf '%.0f' "$used")%"

# ── Line 2: Costs ──

# Session cost (from Claude Code directly)
cost_fmt="?"
if [ -n "$session_cost" ]; then
  cost_fmt=$(awk "BEGIN { printf \"%.2f\", $session_cost }")
fi

# Ctx cost (delta between current and previous session total)
# Cache stores: line 1 = previous total, line 2 = last non-zero delta
# Only updates when cost actually changes (new message), so re-renders during typing keep the last value
ctx_cost=""
if [ -n "$session_cost" ] && [ -n "$session_id" ]; then
  cache_file="/tmp/cc-sl-prev-cost-$session_id"
  prev_cost=""
  last_delta=""
  if [ -f "$cache_file" ]; then
    prev_cost=$(sed -n '1p' "$cache_file")
    last_delta=$(sed -n '2p' "$cache_file")
  fi

  if [ -n "$prev_cost" ]; then
    delta=$(awk "BEGIN { v = $session_cost - $prev_cost; if (v < 0) v = 0; printf \"%.2f\", v }")
    if [ "$delta" != "0.00" ]; then
      ctx_cost="$delta"
      printf '%s\n%s\n' "$session_cost" "$delta" > "$cache_file" 2>/dev/null
    else
      ctx_cost="$last_delta"
    fi
  else
    printf '%s\n\n' "$session_cost" > "$cache_file" 2>/dev/null
  fi
fi

line2="💲 session: \$$cost_fmt"
if [ -n "$ctx_cost" ]; then
  line2="$line2 | 📨 ctx cost: ~\$$ctx_cost/msg"
fi

printf "%s\n%s" "$line1" "$line2"
