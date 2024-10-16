#!/bin/bash

source "$HOME/.config/sketchybar/vars.sh"

FOCUS=$(osascript -l JavaScript plugins/whichmode.jxa)

if [ "$FOCUS" == "No focus" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" icon="󱠨 " icon.color="$DEFAULT_COLOUR" label.drawing=off drawing=on
fi
