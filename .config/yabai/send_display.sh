#! /usr/bin/env zsh

WINDOW=$(yabai -m query --windows --window | jq '.id')
if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
  yabai -m window --toggle float
fi
DISPLAY=$(yabai -m query --windows --window | jq '.display')

if [[ "$1" == '' ]]; then
  if [[ "$DISPLAY" == 2 ]]; then
    yabai -m window --display 1
  else
    yabai -m window --display 2
  fi
else
  yabai -m window --display "$1"
fi

yabai -m window --focus $WINDOW

source "HOME"/.config/yabai/centre.sh
