#!/bin/bash

source "$HOME/.config/sketchybar/vars.sh"

# todo: replace with glances
PERC=$(/usr/bin/top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1)
PERC=$(echo "$PERC" | sed -E 's/([0-9])([0-9])\%/\1%/')

COLOUR=$DEFAULT_COLOUR

ROUNDED_PERC=$(echo "$PERC" | sed -E 's/(.*)(\.[0-9]\%)/\1/')
if (( $ROUNDED_PERC > 12 )); then
  COLOUR=$WARNING_COLOUR
fi
if (( $ROUNDED_PERC > 20 )); then
  COLOUR=$ISSUE_COLOUR
fi

sketchybar --set "$NAME" label.color="${COLOUR}" label="C:${PERC}"
