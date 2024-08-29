#! /usr/bin/env zsh

if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
  yabai -m window --toggle float
fi

DISPLAY=$(yabai -m query --windows --window | jq '.display')
if [[ "$DISPLAY" == 1 ]]; then
  yabai -m window --grid '12:12:1:1:10:10'
else
  POSITION="$1"
  if [[ "$POSITION" == "" ]]; then
    POSITION=2
  fi
  if [[ "$POSITION" == 2 ]]; then
    yabai -m window --grid '12:12:3:1:6:10'
  elif [[ "$POSITION" == 1 ]]; then
    yabai -m window --grid '12:12:1:1:6:10'
  else
    yabai -m window --grid '12:12:5:1:6:10'
  fi
fi
