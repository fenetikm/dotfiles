#!/usr/bin/env zsh

source "$HOME"/.config/yabai/tools.sh

yd "display_added.sh"

DISPLAY_INDEX="$YABAI_DISPLAY_INDEX"
if [[ "$DISPLAY_INDEX" == "2" ]]; then
  yabai -m space 5 --label "dev"
  sketchybar --reload
fi
