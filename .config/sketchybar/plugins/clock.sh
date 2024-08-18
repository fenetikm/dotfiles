#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# sketchybar --set "$NAME" label="$(date '+%l:%M%p')" icon.drawing=off label.padding_left=0
DATETIME=`date '+%a, %d %b. %l:%M%p' | sed -E 's/  / /g'`
sketchybar --set "$NAME" label="${DATETIME}" icon.drawing=off
