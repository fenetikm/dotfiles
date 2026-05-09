#!/bin/bash

source "$HOME/.config/sketchybar/vars.sh"

# this will fail unless the assertions file exists which isn't a thing until dnd has been used once!
FOCUS=$(osascript -l JavaScript plugins/whichmode.jxa)

if [[ "$FOCUS" == "No focus" ]]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" icon="󱠨 " icon.color="$DEFAULT_COLOUR" label.drawing=off drawing=on
fi
