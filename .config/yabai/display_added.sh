#! /usr/bin/env zsh

echo '################'
echo 'display added'

DISPLAY_INDEX="$YABAI_DISPLAY_INDEX"
echo 'display index'
echo "$DISPLAY_INDEX"
if [[ "$DISPLAY_INDEX" == "2" ]]; then
  yabai -m space 5 --label "dev"
  sketchybar --reload
fi
