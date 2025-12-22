#!/usr/bin/env zsh

source "$HOME/.config/yabai/scripts/tools.sh"

yd "move.sh"

FLOAT_ACROSS=0

D=$(yabai -m query --displays --display)
DC=$(yabai -m query --displays | jq 'length')
W=$(yabai -m query --windows --window)
W_ID=$(echo "$W" | jq '.id')
D_INDEX=$(echo "$D" | jq '.index')
IS_FLOATING=0
DIR=$1
if [[ $(echo "$W" | jq -re '."is-floating"') == true ]]; then
  IS_FLOATING=1
fi

# only one display, just swap
if [[ "$DC" == 1 ]]; then
  yabai -m window --swap "$DIR"

  exit 0
fi

# handle floating windows
if [[ "$IS_FLOATING" == 1 ]]; then
  if [[ "$D_INDEX" == 2 && "$DIR" == "east" ]]; then
    yabai -m window "$W_ID" --display 1
    yabai -m window "$W_ID" --focus

    exit 0
  elif [[ "$D_INDEX" == 1 && "$DIR" == "west" ]]; then
    yabai -m window "$W_ID" --display 2
    yabai -m window "$W_ID" --focus

    exit 0
  fi

  exit 0
fi

# todo: generalise
# handle non floating windows
# handle sending to display if east or west most
if [[ "$DIR" == "east" ]]; then
  EAST_WINDOW_ID=$(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == true and ."is-floating" == false)] | sort_by(.frame.x) | reverse | .[0] .id')

  if [[ "$EAST_WINDOW_ID" == "$W_ID" && "$D_INDEX" == 2 ]]; then
    if [[ "$FLOAT_ACROSS" == "1" ]]; then
      yabai -m window "$W_ID" --toggle float
    fi
    yabai -m window "$W_ID" --display 1
    yabai -m window "$W_ID" --focus

    source "$HOME"/.config/yabai/scripts/scripts/balance.sh

    exit 0
  fi
else
  WEST_WINDOW_ID=$(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == true and ."is-floating" == false)] | sort_by(.frame.x) | .[0] .id')

  if [[ "$WEST_WINDOW_ID" == "$W_ID" && "$D_INDEX" == 1 ]]; then
    if [[ "$FLOAT_ACROSS" == "1" ]]; then
      yabai -m window "$W_ID" --toggle float
    fi
    yabai -m window "$W_ID" --display 2
    yabai -m window "$W_ID" --focus

    source "$HOME"/.config/yabai/scripts/balance.sh

    exit 0
  fi
fi

# nothing special to do, swap
yabai -m window --swap "$DIR"
