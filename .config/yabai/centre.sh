#! /usr/bin/env zsh

if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
  yabai -m window --toggle float
fi

SIZE="$2"
if [[ "$SIZE" == "" ]]; then
  SIZE=1
fi

POSITION="$1"
if [[ "$POSITION" == "" ]]; then
  POSITION=2
fi

DISPLAY=$(yabai -m query --windows --window | jq '.display')
if [[ "$DISPLAY" == 1 ]]; then
  yabai -m window --grid '12:12:1:1:10:10'

  exit 1
fi

if [[ "$POSITION" == 2 ]]; then
  if [[ "$SIZE" == 1 ]]; then
    yabai -m window --grid '12:12:3:1:6:10'
  else
    yabai -m window --grid '12:12:2:0:8:12'
  fi
elif [[ "$POSITION" == 1 ]]; then
  if [[ "$SIZE" == 1 ]]; then
    yabai -m window --grid '12:12:1:1:6:10'
  else
    yabai -m window --grid '12:12:0:0:8:12'
  fi
else
  if [[ "$SIZE" == 1 ]]; then
    yabai -m window --grid '12:12:5:1:6:10'
  else
    yabai -m window --grid '12:12:4:0:8:12'
  fi
fi
