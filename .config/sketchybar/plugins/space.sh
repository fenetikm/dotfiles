#!/bin/sh

source "$HOME/.config/sketchybar/colours.sh"

#todo make clickable
# echo $SELECTED
if [[ "$SELECTED" == "true" ]]; then
  sketchybar --set "$NAME" icon.color=0xfff8f8ff
else
  sketchybar --set "$NAME" icon.color="$ICON_COLOUR"
fi
