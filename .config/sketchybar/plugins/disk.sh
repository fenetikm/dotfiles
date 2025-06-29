#!/bin/zsh

# todo: update to use finder style disk script

source "$HOME/.config/sketchybar/vars.sh"

THRESHOLD=100

SPACE=$(df -h --si "/" | tail -n 1 | cut -w -f4)
NUM=$(echo $SPACE | sed -E 's/G//')
ICON=
COLOUR=$DEFAULT_COLOUR
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
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" icon="$ICON" label="D:${SPACE}" label.color="${COLOUR}" icon.drawing=off
fi
