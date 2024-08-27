#! /usr/bin/env zsh

if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
  yabai -m window --toggle float
fi

DISPLAY=$(yabai -m query --windows --window | jq '.display')
if [[ "$DISPLAY" == 1 ]]; then
  yabai -m window --grid '12:12:1:1:10:10'
else
  yabai -m window --grid '12:12:3:1:6:10'
fi
