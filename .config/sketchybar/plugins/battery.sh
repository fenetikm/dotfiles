#!/bin/zsh

source "$HOME/.config/sketchybar/vars.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [[ "$PERCENTAGE" == "" ]]; then
  exit 0
fi

if [[ "$PERCENTAGE" == "100" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0;
fi

ICON="E:"

if [[ "$CHARGING" != "" ]]; then
  ICON="E:"
fi
LABEL="$PERCENTAGE"

COLOUR=$PASSIVE_COLOUR
if (( "$PERCENTAGE" < 40 )); then
  COLOUR=$WARNING_COLOUR
fi
if (( "$PERCENTAGE" < 15 )); then
  COLOUR=$ISSUE_COLOUR
fi

sketchybar \
  --set "$NAME" \
    label="${LABEL}" label.color="${COLOUR}" drawing=on \
    label.padding_right=0 \
    icon.drawing=on \
    icon="${ICON}" \
    icon.padding_left=0 \
    icon.font="${FONT}:${FONT_WEIGHT}:${FONT_SIZE}" icon.color="${ICON_COLOUR}" \
    padding_right=6 padding_left=6
