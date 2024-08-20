#!/bin/bash

source "$HOME/.config/sketchybar/colours.sh"

FOCUS=$(osascript -l JavaScript plugins/whichmode.jxa)

if [ "$FOCUS" == "No focus" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" icon="󱠨 " icon.color=$SPECIAL1_COLOUR label.drawing=off
fi
