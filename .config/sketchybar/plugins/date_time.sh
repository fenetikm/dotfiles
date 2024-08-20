#!/bin/sh

DATETIME=`date '+%a, %d %b. %l:%M%p' | sed -E 's/  / /g'`

sketchybar --set "$NAME" label="${DATETIME}" icon.drawing=off
