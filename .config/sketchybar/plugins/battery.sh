#!/bin/sh

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

COLOUR=0xffb4b4b9
if (( "$PERCENTAGE" < 30 )); then
  COLOUR=0xffFFC552
fi
if (( "$PERCENTAGE" < 15 )); then
  COLOUR=0xffFF3600
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" label.color="${COLOUR}"
