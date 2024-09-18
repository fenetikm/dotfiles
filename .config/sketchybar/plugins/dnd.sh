#!/bin/bash

source "$HOME/.config/sketchybar/vars.sh"

FOCUS=$(osascript -l JavaScript plugins/whichmode.jxa)

if [ "$FOCUS" == "No focus" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" icon="󱠨 " icon.color="$SELECTED_COLOUR" label.drawing=off
fi
