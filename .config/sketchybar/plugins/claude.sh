#!/usr/bin/env zsh

# claude code usage, per cswap account
# usage: claude.sh [divider] [account_number]
#   e.g. claude.sh "•" 2

source "$HOME/.config/sketchybar/vars.sh"

# divider glyph to draw before the label, empty for none
DIV=$1
if [[ "$DIV" == "" ]]; then
  SHOW_DIV=off
else
  SHOW_DIV=on
fi

# which cswap account slot to report on, defaults to the active one
ACCOUNT_NUM=$2

# requires `cswap` installation
if ! command -v cswap >/dev/null 2>&1; then
  return 0
fi

# cswap serves cached usage, no need to cache it again here
USAGE=$(cswap list --json 2>/dev/null)
if [[ "$USAGE" == "" ]]; then
  return 0
fi

if [[ "$ACCOUNT_NUM" == "" ]]; then
  SELECT='.accounts[] | select(.active)'
else
  SELECT=".accounts[] | select(.number==$ACCOUNT_NUM)"
fi

# 5 hour window, fall back to the 7 day one when it isn't reported
USAGE_BUCKET='(.usage.fiveHour // .usage.sevenDay)'

AGENT_USAGE=$(jq -r "$SELECT | $USAGE_BUCKET.pct | round" <<< "$USAGE")
if [[ "$AGENT_USAGE" == "" || "$AGENT_USAGE" == "null" ]]; then
  return 0
fi

# cswap's countdown, trimmed to its largest unit e.g. 25m, 3h+, 5d+
RESET_FMT="
  $USAGE_BUCKET.countdown // \"\"
  | split(\" \")
  | if length == 0 then \"\"
    else .[0] | if endswith(\"m\") then . else . + \"+\" end
    end
"

AGENT_RESET=$(jq -r "$SELECT | $RESET_FMT" <<< "$USAGE")

# use the first letter of the org as an identifier
ACCOUNT=$(jq -r "$SELECT | .alias // .organizationName | .[0:1] | ascii_upcase" <<< "$USAGE")

COLOUR="$PASSIVE_COLOUR"
LABEL="${ACCOUNT}$AGENT_USAGE"
if (( AGENT_USAGE >= 60 )); then
  COLOUR="$WARNING_COLOUR"
fi
if (( AGENT_USAGE >= 80 )); then
  COLOUR="$ISSUE_COLOUR"
  LABEL="${ACCOUNT}$AGENT_RESET"
fi

sketchybar \
  --set "$NAME" \
    label="$LABEL" label.color="$COLOUR" \
    icon="$DIV" icon.color="$DIV_COLOUR" icon.y_offset=-1 \
    icon.padding_left=1 icon.padding_right=3 \
    icon.drawing="${SHOW_DIV}" \
    drawing=on padding_left=0 padding_right=0
