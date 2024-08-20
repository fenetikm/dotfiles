#!/bin/bash

PERC=$(/usr/bin/top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1)
ICON=
COLOUR=0xff99A4BC

sketchybar --set "$NAME" icon="$ICON" icon.color="${COLOUR}" label="${PERC}"
