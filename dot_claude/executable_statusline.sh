#!/bin/sh
data=$(cat)
dir=$(printf '%s' "$data" | jq -r '.workspace.current_dir // empty')
[ -z "$dir" ] && dir=$(pwd)
dirname=$(basename "$dir")
model=$(printf '%s' "$data" | jq -r '.model.display_name // empty')
effort=$(printf '%s' "$data" | jq -r '.effort.level // empty')
[ -n "$effort" ] && model="$model $effort"

out=$(printf '[%s]' "$dirname")
[ -n "$model" ] && out=$(printf '%s [%s]' "$out" "$model")

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[1;31m'
RESET='\033[0m'

limit_color() {
  awk -v p="$1" 'BEGIN {
    if (p < 0) p = 0; if (p > 100) p = 100
    green_r=0;   green_g=200; green_b=0
    yellow_r=220; yellow_g=200; yellow_b=0
    red_r=220;   red_g=50;   red_b=50
    if (p < 50) {
      t = p / 50
      r = green_r + (yellow_r - green_r) * t
      g = green_g + (yellow_g - green_g) * t
      b = green_b + (yellow_b - green_b) * t
    } else {
      t = (p - 50) / 50
      r = yellow_r + (red_r - yellow_r) * t
      g = yellow_g + (red_g - yellow_g) * t
      b = yellow_b + (red_b - yellow_b) * t
    }
    printf "\033[38;2;%d;%d;%dm", r, g, b
  }'
}

if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
  staged=$(git -C "$dir" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  modified=$(git -C "$dir" diff --numstat 2>/dev/null | wc -l | tr -d ' ')

  git_status=""
  [ "$staged" -gt 0 ] && git_status="${GREEN}+${staged}${RESET}"
  [ "$modified" -gt 0 ] && git_status="${git_status}${YELLOW}~${modified}${RESET}"

  out=$(printf '%s | \xf0\x9f\x8c\xbf %s %b' "$out" "$branch" "$git_status")
fi

reset_epoch=$(printf '%s' "$data" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$reset_epoch" ]; then
  now_epoch=$(date +%s)
  diff=$((reset_epoch - now_epoch))
  if [ "$diff" -gt 0 ]; then
    rh=$((diff / 3600))
    rm=$(((diff % 3600) / 60))
    out=$(printf '%s (resets %dh%dm)' "$out" "$rh" "$rm")
  fi
fi

input_tokens=$(printf '%s' "$data" | jq -r '.context_window.total_input_tokens // empty')
compact_window=$(jq -r '.autoCompactWindow // empty' ~/.claude/settings.json 2>/dev/null)
[ -z "$compact_window" ] && compact_window=$(printf '%s' "$data" | jq -r '.context_window.context_window_size // empty')

if [ -n "$input_tokens" ] && [ -n "$compact_window" ] && [ "$compact_window" -gt 0 ]; then
  used=$(awk -v t="$input_tokens" -v w="$compact_window" 'BEGIN { u = (t / w) * 100; if (u < 0) u = 0; if (u > 100) u = 100; printf "%d", u }')
  filled=$((used / 10))
  empty=$((10 - filled))
  bar=$(printf '\xe2\x96\x88%.0s' $(seq 1 $filled) 2>/dev/null)
  bar="$bar$(printf '\xe2\x96\x91%.0s' $(seq 1 $empty) 2>/dev/null)"

  color=$(limit_color "$used")

  out=$(printf '%s context: [%b%s %s%%\033[0m]' "$out" "$color" "$bar" "$used")
fi

five_h=$(printf '%s' "$data" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(printf '%s' "$data" | jq -r '.rate_limits.seven_day.used_percentage // empty')

limits=""
if [ -n "$five_h" ]; then
  c=$(limit_color "$five_h")
  limits=$(printf '%b5h: %.0f%%%b' "$c" "$five_h" "$RESET")
fi
if [ -n "$week" ]; then
  c=$(limit_color "$week")
  wpart=$(printf '%b7d: %.0f%%%b' "$c" "$week" "$RESET")
  limits="${limits:+$limits }$wpart"
fi

[ -n "$limits" ] && out="$out $limits"

printf '%s' "$out"
