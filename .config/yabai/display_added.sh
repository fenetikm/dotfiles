#! /usr/bin/env zsh

echo '################'
echo 'display added'

DISPLAY_ID="$YABAI_DISPLAY_INDEX"
if [[ "$YABAI_DISPLAY_INDEX" =="2" ]]; then
  yabai -m space 4 --label "dev"
  sketchybar --reload
fi
