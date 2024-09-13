#! /usr/bin/env zsh

# resizing of floats
# sizes:
# - 13 = 1/3
# - 12 = 1/2
# - 23 = 2/3
# - 23s = smaller 2/3
# positions:
# - 1,2,3 (thirds)
# - a, b (halves)
# also a way of centering

if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
  yabai -m window --toggle float
fi

POSITION="$1"
if [[ "$POSITION" == "" ]]; then
  POSITION=1
fi

SIZE="$2"
if [[ "$SIZE" == "" ]]; then
  SIZE=1
fi

DISPLAY_IDX=$(yabai -m query --windows --window | jq '.display')
if [[ "$DISPLAY_IDX" == 1 ]]; then
  yabai -m window --grid '12:12:1:1:10:10'

  exit 1
fi

# DISPLAY_WIDTH=$(yabai -m query --displays --display | jq '.frame.w | floor')
# if [[ "$DISPLAY_WIDTH" != "3840"]]; then
# fi

# fixme: detect other display sizes
# fixme: when it is two thirds then gap issue
# todo: clean up the below
# external display from here on
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
