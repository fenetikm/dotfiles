#!/bin/zsh

source "$HOME/.config/sketchybar/vars.sh"

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

sketchybar --set "$NAME" icon="$ICON" label="D:${SPACE}" label.color="${COLOUR}" icon.drawing=off
