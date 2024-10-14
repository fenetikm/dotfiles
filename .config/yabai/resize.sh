#! /usr/bin/env zsh

# args: position size float
# sizes $1:
# - x = leave as is
# - 13 = 1/3
# - 12 = 1/2
# - 23 = 2/3
# - 23s = smaller 2/3
# positions $2:
# - 1,2,3 (thirds)
# - a, b (halves)
# - c (centre)
# - x (leave as is)
#
# todo: allow resizing of non-floated windows

WID=$(yabai -m query --windows --window | jq '.id')
echo "$WID" >> "/tmp/yabai_michael.out.log"

DO_FLOAT="$3"
if [[ "$DO_FLOAT" == "" ]]; then
  DO_FLOAT=1
fi

if [[ $(yabai -m query --windows --window "$WID" | jq -re '."is-floating"') == false && "$DO_FLOAT" == 1 ]]; then
  yabai -m window "$WID" --toggle float
fi

# todo: optimise into less yabai calls
DISPLAY_WIDTH=$(yabai -m query --displays --display | jq '.frame.w | floor')
DISPLAY_HEIGHT=$(yabai -m query --displays --display | jq '.frame.h | floor')
DISPLAY_X=$(yabai -m query --displays --display | jq '.frame.x | floor')
DISPLAY_IDX=$(yabai -m query --windows --window "$WID" | jq '.display')
WINDOW_WIDTH=$(yabai -m query --windows --window "$WID" | jq '.frame.w | floor')
WINDOW_HEIGHT=$(yabai -m query --windows --window "$WID" | jq '.frame.h | floor')

echo "$1" >> "/tmp/yabai_michael.out.log"
echo "$2" >> "/tmp/yabai_michael.out.log"
echo "$3" >> "/tmp/yabai_michael.out.log"

POSITION="$1"
if [[ "$POSITION" == "" ]]; then
  POSITION=1
fi

if [[ "$POSITION" == "c" ]]; then
  if [[ "$DISPLAY_IDX" == 2 ]]; then
    NEW_X=$(( 0 - "$DISPLAY_WIDTH" + (("$DISPLAY_WIDTH" - "$WINDOW_WIDTH") / 2) ))
    NEW_Y=$(( ("$DISPLAY_HEIGHT" - "$WINDOW_HEIGHT") / 2 ))

    yabai -m window "$WID" --move abs:$NEW_X:$NEW_Y
  fi
  if [[ "$DISPLAY_IDX" == "1" ]];
    NEW_X=$(( ("$DISPLAY_WIDTH" - "$WINDOW_WIDTH") / 2 ))
    NEW_Y=$(( ("$DISPLAY_HEIGHT" - "$WINDOW_HEIGHT") / 2 ))

    yabai -m window "$WID" --move abs:$NEW_X:$NEW_Y
  fi

  exit 1
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
