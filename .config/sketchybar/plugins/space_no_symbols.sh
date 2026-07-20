#!/usr/bin/env zsh

source "$HOME/.config/sketchybar/vars.sh"

if [[ "$SELECTED" == "true" ]]; then
  sketchybar \
    --set "$NAME" \
      label.color="$SELECTED_COLOUR"
else
  sketchybar \
    --set "$NAME" \
      label.color="$PASSIVE_COLOUR"
fi
