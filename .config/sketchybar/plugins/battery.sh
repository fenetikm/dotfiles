#!/bin/zsh

source "$HOME/.config/sketchybar/vars.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

LABEL="B:"

if [[ "$CHARGING" != "" ]]; then
  LABEL="P:"
fi
LABEL="$LABEL$PERCENTAGE"

COLOUR=$DEFAULT_COLOUR
if (( "$PERCENTAGE" < 40 )); then
  COLOUR=$WARNING_COLOUR
fi
if (( "$PERCENTAGE" < 15 )); then
  COLOUR=$ISSUE_COLOUR
fi

sketchybar --set "$NAME" label="${LABEL}" label.color="${COLOUR}"
