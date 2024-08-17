#!/bin/bash

FOCUS=$(osascript -l JavaScript plugins/whichmode.jxa)

if [ "$FOCUS" == "No focus" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" icon="󱠨 " icon.color=0xff5521D9 label.drawing=off
fi
