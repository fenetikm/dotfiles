#!/bin/sh

source "$HOME/.config/sketchybar/vars.sh"

#todo make clickable
SPACE_ICON=
if [[ "$SELECTED" == "true" ]]; then
  case "$NAME" in
    space.1) SPACE_ICON="󰋜 " ;;
    space.2) SPACE_ICON="󰇮 " ;;
    space.3) SPACE_ICON="󰭹 " ;;
    space.4) SPACE_ICON="󰆼 " ;;
    space.5) SPACE_ICON="󰧚 " ;;
    space.6) SPACE_ICON="󰈈 " ;;
  esac
else
  case "$NAME" in
    space.1) SPACE_ICON=" " ;;
    space.2) SPACE_ICON=" " ;;
    space.3) SPACE_ICON="󰻞 " ;;
    space.4) SPACE_ICON="󱘲 " ;;
    space.5) SPACE_ICON="󰧛 " ;;
    space.6) SPACE_ICON="󰛐 " ;;
  esac
fi

if [[ "$SELECTED" == "true" ]]; then
  sketchybar --set "$NAME" label.color="$SELECTED_COLOUR"
else
  sketchybar --set "$NAME" label.color="$PASSIVE_COLOUR"
fi
