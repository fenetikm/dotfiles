#! /usr/bin/env zsh

# args: position size float
# sizes:
# - x = leave as is
# - 13 = 1/3
# - 12 = 1/2
# - 23 = 2/3
# - 23s = smaller 2/3, lol what is this for? can't remember!
# - wwww,hhhh = specific size
# - full = full-size, but below the bar
# - fullwindow = full, over the bar
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

source "$HOME"/.config/yabai/tools.sh

yd "RESIZE.SH"
# yd "$1" "position"
# yd "$2" "size"

GAP=20
BAR_HEIGHT=32
PADDING=20
W=$(yabai -m query --windows --window)
D=$(yabai -m query --displays --display)
WID=$(echo "$W" | jq '.id')
APP=$(echo "$W" | jq '.app')
DISPLAY_WIDTH=$(echo "$D" | jq '.frame.w | floor')
DISPLAY_HEIGHT=$(echo "$D" | jq '.frame.h | floor')
DISPLAY_X=$(echo "$D" | jq '.frame.x | floor')
DISPLAY_IDX=$(echo "$W" | jq '.display')
WINDOW_WIDTH=$(echo "$W" | jq '.frame.w | floor')
WINDOW_HEIGHT=$(echo "$W" | jq '.frame.h | floor')
VIEWABLE_WIDTH=$(( "$DISPLAY_WIDTH" - "$PADDING" - "$PADDING" ))
VIEWABLE_HEIGHT=$(( "$DISPLAY_HEIGHT" - "$BAR_HEIGHT" - "$PADDING" - "$PADDING" ))

WINDOW_RATIO=$(echo 'scale=4;'"$WINDOW_WIDTH"/"$WINDOW_HEIGHT"'' | bc)
VIEWABLE_RATIO=$(echo 'scale=4;'"$VIEWABLE_WIDTH"/"$VIEWABLE_HEIGHT"'' | bc)
DISPLAY_RATIO=$(echo 'scale=4;'"$DISPLAY_WIDTH"/"$DISPLAY_HEIGHT"'' | bc)

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
    # specific size
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
    # fixme: account for gap so this lines up with thirds
    WINDOW_WIDTH=$(( "$WINDOW_WIDTH" / 3 * 2))
    yabai -m window --grid '12:12:0:0:9:12'
  elif [[ "$1" == "full" ]]; then
    # todo: handling when video is larger than screen
    if [[ "$APP" == '"VLC"' ]]; then
      # do I even need to care about the chrome?
      CHROME=64
      VIDEO_WIDTH="$WINDOW_WIDTH"
      VIDEO_HEIGHT=$(( "$WINDOW_HEIGHT" - "$CHROME" ))
      VIDEO_RATIO=$(echo 'scale=4;'"$VIDEO_WIDTH"/"$VIDEO_HEIGHT"'' | bc)
      if (( $(echo "$VIDEO_RATIO < $VIEWABLE_RATIO" | bc) )); then
        WINDOW_WIDTH=$(echo '(('"$VIEWABLE_HEIGHT"' - '"$CHROME"')*'"$VIDEO_RATIO"' + 0.5)/1' | bc)
        WINDOW_HEIGHT="$VIEWABLE_HEIGHT"
      else
        WINDOW_WIDTH="$VIEWABLE_WIDTH"
        WINDOW_HEIGHT=$(echo '(('"$VIEWABLE_WIDTH"')/'"$VIDEO_RATIO"' - '"$CHROME"' - 0.5)/1' | bc)
      fi
      yabai -m window "$WID" --resize abs:"$WINDOW_WIDTH":"$WINDOW_HEIGHT"
    else
      WINDOW_WIDTH="$VIEWABLE_WIDTH"
      WINDOW_HEIGHT="$VIEWABLE_HEIGHT"

      yabai -m window --grid '1:1:0:0:1:1'
    fi
  elif [[ "$1" == "fullwindow" ]]; then
    yabai -m window --toggle windowed-fullscreen

    # early exit, doesn't need to position
    exit 1
  fi
}

position_window() {
  # Current assumption here is that display 2 is on the left of display 1
  DISPLAY_X_OFFSET=0
  if [[ "$DISPLAY_IDX" == 2 ]]; then
    DISPLAY_X_OFFSET=$((0 - "$DISPLAY_WIDTH"))
  fi
  if [[ "$1" == "c" ]]; then # centre window
    # don't have to worry about padding since abs?
    NEW_X=$(( "$DISPLAY_X_OFFSET" + (("$DISPLAY_WIDTH" - "$WINDOW_WIDTH") / 2) ))
    NEW_Y=$(( "$BAR_HEIGHT + "$PADDING" + (("$VIEWABLE_HEIGHT" - "$WINDOW_HEIGHT") / 2) ))

    yabai -m window "$WID" --move abs:$NEW_X:$NEW_Y
  elif [[ "$1" == "1" || "$1" == "2" || "$1" == "3" ]]; then
    POS=$(( "$1" - 1))
    yabai -m window --grid '1:3:'"$POS"'0:1:1'
  elif [[ "$1" == "a" || "$1" == "b" ]]; then
    POS=$(( "$1" - 1))
    yabai -m window --grid '1:3:'"$POS"'0:1:1'
  fi

  exit 1
}

resize_window "$2"
position_window "$1"
