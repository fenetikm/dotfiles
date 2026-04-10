#!/bin/sh

source "$HOME/.config/sketchybar/vars.sh"

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
  sketchybar --set "$NAME" icon.color="$SELECTED_COLOUR" icon="$SPACE_ICON"
else
  sketchybar --set "$NAME" icon.color="$ICON_COLOUR" icon="$SPACE_ICON"
fi
