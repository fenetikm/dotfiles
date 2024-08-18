#!/bin/bash

PERC=$(/usr/bin/top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1)
ICON=
COLOUR=0xffb4b4b9

sketchybar --set "$NAME" icon="$ICON" icon.color="${COLOUR}" label="CPU ${PERC}" icon.drawing=off
