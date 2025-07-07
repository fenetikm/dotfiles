#!/usr/bin/env zsh

# what we want:
# - if split and can go left or right, swap
# - if can't go left / right, but there is a display, float on to the next display
#
# usage:
# move.sh <dir>

# check for more than one display
# D=$(yabai -m query --displays --display)
