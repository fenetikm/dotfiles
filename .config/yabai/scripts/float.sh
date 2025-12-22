#!/usr/bin/env zsh

source "$HOME/.config/yabai/tools.sh"

yd "float.SH"

WINDOW=$(yabai -m query --windows --window)
WID=$(echo "$WINDOW" | jq '."id"')

yabai -m window "$WID" --toggle float

source "$HOME/.config/yabai/balance.sh"
