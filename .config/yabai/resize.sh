#! /usr/bin/env zsh

# args: position size float layout space
# sizes:
# - x = leave as is
# - 13 = 1/3
# - 12 = 1/2
# - 23 = 2/3
# - 23s = smaller 2/3, lol what is this for? can't remember!
# - wwww,hhhh = specific size
# - full = full-size, but below the bar
# - fullwindow = full, over the bar
# - equal = make all equal (call balance?)
# positions:
# - 1,2,3 (thirds)
# - a, b (halves)
# - c (centre)
# - x (leave as is)
# float:
# - 1 = turn on float
# layout:
# - 1 = affect layout instead of the window, extract into different thing? probs, looks simple
# space:
# - # = number of the space, 0 = don't move to space
#
# todo: allow resizing of non-floated windows
# - refactor into separate methods?

source "$HOME"/.config/yabai/tools.sh

yd "RESIZE.SH"

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

DO_LAYOUT="$4"
if [[ "$DO_LAYOUT" == "" ]]; then
  DO_LAYOUT=0
fi

SPACE="$5"
if [[ "$SPACE" == "" ]]; then
  SPACE=0
fi

yd "$POSITION" "position"
yd "$SIZE" "size"
yd "$DO_FLOAT" "float"
yd "$DO_LAYOUT" "layout"
yd "$SPACE" "space"

if [[ $(echo "$W" | jq -re '."is-floating"') == false && "$DO_FLOAT" == 1 ]]; then
  yabai -m window "$WID" --toggle float
fi

send_space() {
  if [[ "$SPACE" == "0" ]]; then
    return;
  fi

  # todo: handle space that doesn't exist, create?
  yabai -m window "$WID" --space "$SPACE" --focus
}

resize_layout() {
  local WINDOW_COUNT=$(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == true and ."is-floating" == false)] | length')
  yd "$WINDOW_COUNT" "window count"

  if [[ "$WINDOW_COUNT" != 2 ]]; then
    exit 0 # nothing to do, doesn't make sense
  fi

  if [[ "$SIZE" == "x" ]]; then
    exit 0
  elif [[ "$SIZE" == "13" ]]; then
    yabai -m window "$WID" --ratio "abs:0.333334"
  elif [[ "$SIZE" == "12" ]]; then
    yabai -m window "$WID" --ratio "abs:0.5"
  elif [[ "$SIZE" == "23" ]]; then
    yabai -m window "$WID" --ratio "abs:0.666667"
  fi
}

resize_window() {
  if [[ "$SIZE" == "x" ]]; then
    # do nothing
  elif [[ "$SIZE" =~ ".,." ]]; then
    # specific size
    WINDOW_WIDTH=$(echo "$SIZE" | cut -d "," -f 1)
    WINDOW_HEIGHT=$(echo "$SIZE" | cut -d "," -f 2)

    yabai -m window "$WID" --resize abs:"$WINDOW_WIDTH":"$WINDOW_HEIGHT"
  elif [[ "$SIZE" == "12" ]]; then
    WINDOW_WIDTH=$(( ("$WINDOW_WIDTH" - "$GAP") / 2))
    yabai -m window --grid '1:2:0:0:1:1'
  elif [[ "$SIZE" == "13" ]]; then
    WINDOW_WIDTH=$(( ("$WINDOW_WIDTH" - ("$GAP" * 2)) / 3))
    yabai -m window --grid '12:12:0:0:3:12'
  elif [[ "$SIZE" == "23" ]]; then
    # fixme: account for gap so this lines up with thirds
    WINDOW_WIDTH=$(( "$WINDOW_WIDTH" / 3 * 2))
    yabai -m window --grid '12:12:0:0:9:12'
  elif [[ "$SIZE" == "full" ]]; then
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
  elif [[ "$SIZE" == "fullwindow" ]]; then
    yabai -m window --toggle windowed-fullscreen
  fi
}

# only useful for floated windows
position_window() {
  # Current assumption here is that display 2 is on the left of display 1
  DISPLAY_X_OFFSET=0
  if [[ "$DISPLAY_IDX" == 2 ]]; then
    DISPLAY_X_OFFSET=$((0 - "$DISPLAY_WIDTH"))
  fi
  if [[ "$POSITION" == "c" ]]; then # centre window
    # don't have to worry about padding since abs?
    NEW_X=$(( "$DISPLAY_X_OFFSET" + (("$DISPLAY_WIDTH" - "$WINDOW_WIDTH") / 2) ))
    NEW_Y=$(( "$BAR_HEIGHT" + "$PADDING" + (("$VIEWABLE_HEIGHT" - "$WINDOW_HEIGHT") / 2) ))

    yabai -m window "$WID" --move abs:$NEW_X:$NEW_Y
  elif [[ "$POSITION" == "1" || "$POSITION" == "2" || "$POSITION" == "3" ]]; then
    POS=$(( "$POSITION" - 1 ))
    yabai -m window --grid '1:3:'"$POS"'0:1:1'
  elif [[ "$POSITION" == "a" || "$POSITION" == "b" ]]; then
    POS=$(( "$POSITION" - 1 ))
    yabai -m window --grid '1:3:'"$POS"'0:1:1'
  fi
}

if [[ "$DO_LAYOUT" == 1 ]]; then
  resize_layout
else
  resize_window
  position_window
  send_space
fi
