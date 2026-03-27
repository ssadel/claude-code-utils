#!/bin/sh

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name' | sed 's/^Claude //')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // "0"')
session_id=$(echo "$input" | jq -r '.session_id // empty')
model_id=$(echo "$input" | jq -r '.model.id // empty')
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')
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

# ── Line 2: Session cost ──

# Rates per million tokens, selected by model ID
# Used only for transcript parsing on resume (when total_cost_usd resets to 0)
unknown_model=""
rate_input=0
rate_cache_write=0
rate_cache_read=0
rate_output=0

case "$model_id" in
  *opus-4-6*)
    rate_input=5
    rate_cache_write=6.25
    rate_cache_read=0.50
    rate_output=25
    ;;
  *sonnet-4-6*)
    rate_input=3
    rate_cache_write=3.75
    rate_cache_read=0.30
    rate_output=15
    ;;
  *haiku-4-5*)
    rate_input=0.80
    rate_cache_write=1
    rate_cache_read=0.08
    rate_output=4
    ;;
  *)
    unknown_model="$model_id"
    ;;
esac

# Check for cached base cost from a previous resume
cost_prefix="$"
base_cost=0
if [ -n "$session_id" ]; then
  cache_file="/tmp/cc-sl-base-cost-$session_id"

  if [ -f "$cache_file" ]; then
    base_cost=$(cat "$cache_file")
    cost_prefix="~$"
  fi

  # If total_cost_usd is 0 and no cached base, this might be a resume
  # Parse the full transcript to recover pre-resume cost
  is_zero=$(awk "BEGIN { print ($session_cost == 0) ? 1 : 0 }")
  if [ "$is_zero" = "1" ] && [ ! -f "$cache_file" ] && [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
    if [ -z "$unknown_model" ]; then
      base_cost=$(jq -rs \
        --argjson ri "$rate_input" \
        --argjson rcw "$rate_cache_write" \
        --argjson rcr "$rate_cache_read" \
        --argjson ro "$rate_output" '
        [.[] | select(.type == "assistant" and .message.usage != null) | .message.usage] |
        reduce .[] as $u (0;
          . + (($u.input_tokens // 0) * $ri)
            + (($u.cache_creation_input_tokens // 0) * $rcw)
            + (($u.cache_read_input_tokens // 0) * $rcr)
            + (($u.output_tokens // 0) * $ro)
        ) / 1000000
      ' "$transcript_path" 2>/dev/null)

      if [ -n "$base_cost" ] && [ "$base_cost" != "0" ] && [ "$base_cost" != "null" ]; then
        printf '%s' "$base_cost" > "$cache_file" 2>/dev/null
        cost_prefix="~$"
      else
        base_cost=0
      fi
    else
      cost_prefix="~$"
    fi
  fi
fi

total_cost=$(awk "BEGIN { printf \"%.2f\", ${base_cost:-0} + ${session_cost:-0} }")

line2="💲 session: ${cost_prefix}${total_cost}"

if [ -n "$unknown_model" ]; then
  printf "%s\n%s\n⚠️ unknown model: %s" "$line1" "$line2" "$unknown_model"
else
  printf "%s\n%s" "$line1" "$line2"
fi
