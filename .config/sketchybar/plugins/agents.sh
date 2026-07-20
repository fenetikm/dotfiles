#!/usr/bin/env zsh

# todo: want it to be in a group and then:
# <icon> xx yy zz
# ... since everything is ending up in pills, do that to everything? remove the top background? yeah!

source "$HOME/.config/sketchybar/vars.sh"

AGENT_NAME=$1
if [[ "$1" == "" ]]; then
  return 0
fi

SHOW_DIV=$2
if [[ "$2" == "" ]]; then
  SHOW_DIV=off
else
  SHOW_DIV=on
fi

# requires `codexbar` installation
if ! command -v codexbar >/dev/null 2>&1; then
  return 0
fi

# 5 min cache
if [[ ! -f "plugins/agent_usage.json" ]]; then
  echo $(codexbar usage --format json) > plugins/agent_usage.json
elif [[ $(find "plugins/agent_usage.json" -mmin +5 -print) ]]; then
  echo $(codexbar usage --format json) > plugins/agent_usage.json
fi
USAGE=$(cat plugins/agent_usage.json)

# check .usage.primary key, somestimes doesn't exist, fallback to .usage.secondary
USAGE_BUCKET='.usage.primary // .usage.secondary'

AGENT_USAGE=$(jq -r ".[] | select(.provider==\"$AGENT_NAME\") | ($USAGE_BUCKET).usedPercent | round" <<< "$USAGE")

# format to human readable time offset e.g. 1h20m, 5m, 2d+ for 1 day or more etc.
RESET_FMT='(.usage.primary // .usage.secondary) as $u | ([(($u.resetsAt | fromdateiso8601) - now) / 60 | floor, 0] | max) as $m | if $m >= 1440 then "\($m / 1440 | floor)d+" else ($m / 60 | floor) as $h | if $h == 0 then "\($m)m" else "\($h)h\($m % 60)m" end end'

AGENT_RESET=$(jq -r ".[] | select(.provider==\"$AGENT_NAME\") | $RESET_FMT" <<< "$USAGE")

COLOUR="$PASSIVE_COLOUR"
LABEL="$AGENT_USAGE"
if (( AGENT_USAGE >= 60 )); then
  COLOUR="$WARNING_COLOUR"
fi
if (( AGENT_USAGE >= 80 )); then
  COLOUR="$ISSUE_COLOUR"
  LABEL="$AGENT_RESET"
fi

sketchybar \
  --set "$NAME" \
  label="$LABEL" label.color="$COLOUR" \
  icon="•" icon.color="$DIV_COLOUR" icon.y_offset=-1 icon.padding_left=0 \
  icon.drawing="${SHOW_DIV}" \
  drawing=on padding_left=0 padding_right=0
