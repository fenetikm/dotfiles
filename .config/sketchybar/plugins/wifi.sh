#!/bin/bash

# todo:
# - show stuff on popup

# CURRENT_WIFI="$(wdutil info)"
SSID="$(networksetup -getairportnetwork en0 | sed -E 's/Current Wi-Fi Network: //')"
# CURR_TX="$(echo "$CURRENT_WIFI" | grep "Tx Rate" | sed -E 's/.*Tx Rate.*: //')"

if [ "$SSID" = "" ]; then
  sketchybar --set wifi icon=󰖪 label.drawing=off
else
  sketchybar --set wifi icon=󰖩 label.drawing=off
fi
