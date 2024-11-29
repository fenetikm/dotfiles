#! /usr/bin/env zsh

# args: position size float
# sizes:
# - x = leave as is
# - 13 = 1/3
# - 12 = 1/2
# - 23 = 2/3
# - 23s = smaller 2/3, lol what is this for?
# - wwww,hhhh = specific size
# positions:
# - 1,2,3 (thirds)
# - a, b (halves)
# - c (centre)
# - x (leave as is)
# float:
# - 1 = turn on float
#
# todo: allow resizing of non-floated windows
# - refactor into separate methods?

GAP=20
BAR_HEIGHT=32
PADDING=20
W=$(yabai -m query --windows --window)
D=$(yabai -m query --displays --display)
WID=$(echo "$W" | jq '.id')
DISPLAY_WIDTH=$(echo "$D" | jq '.frame.w | floor')
DISPLAY_HEIGHT=$(echo "$D" | jq '.frame.h | floor')
DISPLAY_X=$(echo "$D" | jq '.frame.x | floor')
DISPLAY_IDX=$(echo "$W" | jq '.display')
WINDOW_WIDTH=$(echo "$W" | jq '.frame.w | floor')
WINDOW_HEIGHT=$(echo "$W" | jq '.frame.h | floor')

POSITION="$1"
if [[ "$POSITION" == "" ]]; then
  POSITION=1
fi

SIZE="$2"
if [[ "$SIZE" == "" ]]; then
  SIZE=1
fi

DO_FLOAT="$3"
if [[ "$DO_FLOAT" == "" ]]; then
  DO_FLOAT=0
fi

if [[ $(echo "$W" | jq -re '."is-floating"') == false && "$DO_FLOAT" == 1 ]]; then
  yabai -m window "$WID" --toggle float
fi

resize_window() {
  if [[ "$1" == "x" ]]; then
    # do nothing
  elif [[ "$1" =~ ".,." ]]; then
    WINDOW_WIDTH=$(echo "$1" | cut -d "," -f 1)
    WINDOW_HEIGHT=$(echo "$1" | cut -d "," -f 2)

    yabai -m window "$WID" --resize abs:"$WINDOW_WIDTH":"$WINDOW_HEIGHT"
  elif [[ "$1" == "12" ]]; then
    WINDOW_WIDTH=$(( ("$WINDOW_WIDTH" - "$GAP") / 2))
    yabai -m window --grid '1:2:0:0:1:1'
  elif [[ "$1" == "13" ]]; then
    WINDOW_WIDTH=$(( ("$WINDOW_WIDTH" - ("$GAP" * 2)) / 3))
    yabai -m window --grid '12:12:0:0:3:12'
  elif [[ "$1" == "23" ]]; then
    # fixme: account for gap
    WINDOW_WIDTH=$(( "$WINDOW_WIDTH" / 3 * 2))
    yabai -m window --grid '12:12:0:0:9:12'
  fi
}

position_window() {
  # Current assumption here is that display 2 is on the left of display 1
  DISPLAY_X_OFFSET=0
  if [[ "$DISPLAY_IDX" == 2 ]]; then
    DISPLAY_X_OFFSET=$((0 - "$DISPLAY_WIDTH"))
  fi
  # centre window
  if [[ "$1" == "c" ]]; then
    echo 'centre'
    NEW_X=$(( "$DISPLAY_X_OFFSET" + ((("$DISPLAY_WIDTH" - (2 * "$PADDING")) - "$WINDOW_WIDTH") / 2) ))
    NEW_Y=$(( "$BAR_HEIGHT" + "$PADDING" + ((("$DISPLAY_HEIGHT" - "$BAR_HEIGHT" - (2 * "$PADDING"))  - "$WINDOW_HEIGHT") / 2) ))

    yabai -m window "$WID" --move abs:$NEW_X:$NEW_Y
  elif [[ "$1" == "1" || "$1" == "2" || "$1" == "3" ]]; then
    echo 'thirds'
    POS=$(( "$1" - 1))
    yabai -m window --grid '1:3:'"$POS"'0:1:1'
  elif [[ "$1" == "a" || "$1" == "b" ]]; then
    echo 'halves'
    POS=$(( "$1" - 1))
    yabai -m window --grid '1:3:'"$POS"'0:1:1'
  fi

  exit 1
}

resize_window "$2"
position_window "$1"

# DISPLAY_IDX=$(yabai -m query --windows --window | jq '.display')
# if [[ "$DISPLAY_IDX" == 1 ]]; then
#   yabai -m window --grid '12:12:1:1:10:10'
#
#   exit 1
# fi

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
