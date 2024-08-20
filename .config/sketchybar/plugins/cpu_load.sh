#!/bin/bash

source "$HOME/.config/sketchybar/colours.sh"

PERC=$(/usr/bin/top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1)
PERC=$(echo "$PERC" | sed -E 's/([0-9])([0-9])\%/\1%/')
ICON=
COLOUR=$DEFAULT_COLOUR

sketchybar --set "$NAME" icon="$ICON" icon.color="${COLOUR}" label="CPU:${PERC}" icon.drawing=off
