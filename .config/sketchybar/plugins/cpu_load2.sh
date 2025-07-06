#!/bin/bash

source "$HOME/.config/sketchybar/vars.sh"

PERC=$(python3 plugins/cpu.py)

COLOUR=$DEFAULT_COLOUR

echo $PERC
ROUNDED_PERC=$(echo "$PERC" | sed -E 's/(.*)(\.[0-9])/\1/')
echo $ROUNDED_PERC

if (( $ROUNDED_PERC > 12 )); then
  COLOUR=$WARNING_COLOUR
fi
if (( $ROUNDED_PERC > 20 )); then
  COLOUR=$ISSUE_COLOUR
fi

# sketchybar --set "$NAME" label.color="${COLOUR}" label="C:${PERC}"
