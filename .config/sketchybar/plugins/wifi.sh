#!/bin/bash

source "$HOME/.config/sketchybar/vars.sh"

# CURRENT_WIFI="$(wdutil info)"
SSID="$(networksetup -getairportnetwork en0 | sed -E 's/Current Wi-Fi Network: //')"
# CURR_TX="$(echo "$CURRENT_WIFI" | grep "Tx Rate" | sed -E 's/.*Tx Rate.*: //')"

if [[ "$SSID" = "" ]]; then
  sketchybar --set wifi label="W!!" label.color="$ISSUE_COLOUR" icon.drawing=off
else
  sketchybar --set wifi label="W:ON" label.color="$DEFAULT_COLOUR" icon.drawing=off drawing=off
fi
