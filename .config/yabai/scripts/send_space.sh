#!/usr/bin/env zsh

# usage:
# send_space <SPACE> <FOCUS?> <FORCE_FLOAT?>

source "$HOME/.config/yabai/scripts/tools.sh"

yd "send_space.sh"

SPACE="$1"
if [[ "$SPACE" == "" ]]; then
  exit 0
fi

FOCUS="$2"
if [[ "$FOCUS" == "" ]]; then
  FOCUS=1
fi

FORCE_FLOAT="$3"
if [[ "$FORCE_FLOAT" == "" ]]; then
  FORCE_FLOAT=0
fi

if [[ "$FORCE_FLOAT" == "1" ]]; then
  if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
    yabai -m window --toggle float
  fi
fi

yabai -m window --space "$SPACE"

if [[ "$FOCUS" == "1" ]]; then
  yabai -m space --focus "$SPACE"
fi
