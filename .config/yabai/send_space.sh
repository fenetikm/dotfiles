#! /usr/bin/env zsh

SPACE=$1
if [[ "$SPACE" == "" ]]; then
  exit 0
fi

FOCUS=$2

WINDOW=$(yabai -m query --windows --window | jq '.id')
if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
  yabai -m window --toggle float
fi

yabai -m window --space "$SPACE"

if [[ "$FOCUS" == "1" ]]; then
  yabai -m space --focus "$SPACE"
fi
