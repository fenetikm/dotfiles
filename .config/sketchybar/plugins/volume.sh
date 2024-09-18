#!/bin/zsh

# $INFO has the volume percentage
if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  sketchybar --set "$NAME" label="V:$VOLUME" icon.drawing=off
fi
