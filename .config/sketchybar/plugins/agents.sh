#!/usr/bin/env zsh

source "$HOME/.config/sketchybar/vars.sh"

# requires `codexbar` installation
if ! command -v codexbar >/dev/null 2>&1; then
  sketchybar --set agent_claude drawing=off \
             --set agent_codex  drawing=off \
             --set agent_cursor drawing=off
  return 0 2>/dev/null || exit 0
fi

USAGE=$(codexbar usage --format json)

# check primary usage, and if it doesn't exist, fall back to secondary
USAGE_BUCKET='.usage.primary // .usage.secondary'

CLAUDE=$(jq -r ".[] | select(.provider==\"claude\") | ($USAGE_BUCKET).usedPercent | round" <<< "$USAGE")
CODEX=$(jq -r ".[]  | select(.provider==\"codex\")  | ($USAGE_BUCKET).usedPercent | round" <<< "$USAGE")
CURSOR=$(jq -r ".[] | select(.provider==\"cursor\") | ($USAGE_BUCKET).usedPercent | round" <<< "$USAGE")

# format to human readable time offset e.g. 1h20m, 5m etc.
RESET_FMT='(.usage.primary // .usage.secondary) as $u | ([(($u.resetsAt | fromdateiso8601) - now) / 60 | floor, 0] | max) as $m | if $m >= 1440 then "\($m / 1440 | floor)d\($m % 1440 / 60 | floor)h" else ($m / 60 | floor) as $h | if $h == 0 then "\($m)m" else "\($h)h\($m % 60)m" end end'

CLAUDE_RESET=$(jq -r ".[] | select(.provider==\"claude\") | $RESET_FMT" <<< "$USAGE")
CODEX_RESET=$(jq -r ".[]  | select(.provider==\"codex\")  | $RESET_FMT" <<< "$USAGE")
CURSOR_RESET=$(jq -r ".[] | select(.provider==\"cursor\") | $RESET_FMT" <<< "$USAGE")

# only show when usage is over 30; default gray, yellow at >=60, red at >=80
item_args() {
  local ITEM=$1 PREFIX=$2 PCT=$3 RESET=$4
  if (( PCT <= 30 )); then
    echo "--set $ITEM drawing=off"
    return
  fi

  local LABEL="${PREFIX}:${PCT}%"
  local COLOUR="$PASSIVE_COLOUR"
  (( PCT >= 60 )) && COLOUR="$WARNING_COLOUR"

  # when % greater than 80, show the time to reset
  if (( PCT >= 80 )); then
    COLOUR="$ISSUE_COLOUR"
    LABEL="${PREFIX}:${RESET}"
  fi
  echo "--set ${ITEM} label=${LABEL} label.color=${COLOUR} icon.drawing=off drawing=on"
}

sketchybar $(item_args agent_claude C "$CLAUDE" "$CLAUDE_RESET") \
           $(item_args agent_codex  X "$CODEX"  "$CODEX_RESET") \
           $(item_args agent_cursor R "$CURSOR" "$CURSOR_RESET")
