#!/bin/sh

source "$HOME/.config/sketchybar/colours.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=" "
  ;;
  [6-8][0-9]) ICON=" "
  ;;
  [3-5][0-9]) ICON=" "
  ;;
  [1-2][0-9]) ICON=" "
  ;;
  *) ICON=" "
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="󰚥"
fi

COLOUR=$DEFAULT_COLOUR
if (( "$PERCENTAGE" < 30 )); then
  COLOUR=$WARNING_COLOUR
fi
if (( "$PERCENTAGE" < 15 )); then
  COLOUR=$ISSUE_COLOUR
fi

LABEL_DRAWING=on
if [ "$PERCENTAGE" == "100" ]; then
  LABEL_DRAWING=off
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" label.color="${COLOUR}" label.drawing="${LABEL_DRAWING}"
