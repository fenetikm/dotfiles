#!/bin/sh

source "$HOME/.config/sketchybar/vars.sh"

#todo make clickable
# echo $SELECTED
if [[ "$SELECTED" == "true" ]]; then
  sketchybar --set "$NAME" icon.color="$SELECTED_COLOUR"
else
  sketchybar --set "$NAME" icon.color="$ICON_COLOUR"
fi
