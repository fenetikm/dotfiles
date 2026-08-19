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

# nothing worth reporting, take the item out of the bar entirely
hide() {
  sketchybar --set "$NAME" drawing=off
  return 0
}

# requires `cswap` installation
if ! command -v cswap >/dev/null 2>&1; then
  hide
  return 0
fi

# cswap serves cached usage, no need to cache it again here
USAGE=$(cswap list --json 2>/dev/null)
if [[ "$USAGE" == "" ]]; then
  hide
  return 0
fi

if [[ "$ACCOUNT_NUM" == "" ]]; then
  SELECT='.accounts[] | select(.active)'
else
  SELECT=".accounts[] | select(.number==$ACCOUNT_NUM)"
fi

# 5 hour window, falling back to the 7 day one when it isn't reported
BUCKET='(.fiveHour // .sevenDay)'

# cswap's countdown, trimmed to its largest unit e.g. 25m, 3h+, 5d+
RESET_FMT="
  (.countdown // \"\")
  | split(\" \")
  | if length == 0 then \"\"
    else .[0] | if endswith(\"m\") then . else . + \"+\" end
    end
"

# one pass over the json: identifier, live usage, last known usage, status
#   cswap nulls .usage for everything from a locked keychain to a logged out
#   account, so carry .lastGoodUsage too and let the status decide which to use
FIELDS="
  $SELECT
  | (.usage // {} | $BUCKET) as \$live
  | (.lastGoodUsage // {} | $BUCKET) as \$last
  | (
      ((.alias // .organizationName // \"\") | .[0:1] | ascii_upcase),
      (if (\$live.pct | type) == \"number\" then \$live.pct | round | tostring else \"\" end),
      (\$live | $RESET_FMT),
      (if (\$last.pct | type) == \"number\" then \$last.pct | round | tostring else \"\" end),
      (\$last | $RESET_FMT),
      (.usageStatus // \"unavailable\")
    )
"

# one field per line, blanks and all, so the status has to come last: it is the
# only field that is never empty, and a trailing blank line wouldn't survive
FIELD=("${(@f)$(jq -r "$FIELDS" <<< "$USAGE" 2>/dev/null)}")
ACCOUNT=$FIELD[1]
AGENT_USAGE=$FIELD[2]
AGENT_RESET=$FIELD[3]
LAST_USAGE=$FIELD[4]
LAST_RESET=$FIELD[5]
STATUS=$FIELD[6]

# no such account slot in cswap
if [[ "$STATUS" == "" ]]; then
  hide
  return 0
fi

# these clear on their own, so keep showing the last known figure meanwhile
case "$STATUS" in
  token_expired|keychain_unavailable|unavailable)
    if [[ "$AGENT_USAGE" == "" ]]; then
      AGENT_USAGE="$LAST_USAGE"
      AGENT_RESET="$LAST_RESET"
    fi
    ;;
esac

if [[ "$AGENT_USAGE" == "" ]]; then
  # no figure to show, the question mark says enough on its own
  LABEL="${ACCOUNT}?"
  COLOUR="$PASSIVE_COLOUR"
else
  COLOUR="$PASSIVE_COLOUR"
  LABEL="${ACCOUNT}$AGENT_USAGE"
  if (( AGENT_USAGE >= 60 )); then
    COLOUR="$WARNING_COLOUR"
  fi
  if (( AGENT_USAGE >= 80 )); then
    COLOUR="$ISSUE_COLOUR"
    LABEL="${ACCOUNT}$AGENT_RESET"
  fi
fi

sketchybar \
  --set "$NAME" \
    label="$LABEL" label.color="$COLOUR" \
    icon="$DIV" icon.color="$DIV_COLOUR" icon.y_offset=-1 \
    icon.padding_left=1 icon.padding_right=3 \
    icon.drawing="${SHOW_DIV}" \
    drawing=on padding_left=0 padding_right=0
