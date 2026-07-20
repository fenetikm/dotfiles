#!/bin/zsh

# todo: update to use finder style disk script

source "$HOME/.config/sketchybar/vars.sh"

THRESHOLD=100

SPACE=$(df -h --si "/" | tail -n 1 | cut -w -f4)
NUM=$(echo $SPACE | sed -E 's/G//')
COLOUR=$PASSIVE_COLOUR
if (( "$NUM" < 20 )); then
  COLOUR=$WARNING_COLOUR
fi
if (( "$NUM" < 10 )); then
  COLOUR=$ISSUE_COLOUR
fi
if [[ "$NUM" =~ "M$" ]]; then
  COLOUR=$ISSUE_COLOUR
fi

if (( "$NUM" > "$THRESHOLD" )); then
  sketchybar \
    --set "$NAME" \
      drawing=off icon.drawing=off
else
  sketchybar \
    --set "$NAME" \
      icon="D:" \
      icon.padding_left=0 \
      icon.font="${FONT}:${FONT_WEIGHT}:${FONT_SIZE}" icon.color="${ICON_COLOUR}" \
      label="${SPACE}" label.color="${COLOUR}" \
      label.padding_right=0 label.padding_left=0 \
      padding_right=6 padding_left=6
fi
