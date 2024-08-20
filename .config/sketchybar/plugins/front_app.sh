#!/bin/sh

source "$HOME/.config/sketchybar/colours.sh"

# todo: icons for some apps

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="< $INFO >" label.color=$DEFAULT_COLOUR
fi
