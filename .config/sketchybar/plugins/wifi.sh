#!/usr/bin/env zsh

source "$HOME/.config/sketchybar/vars.sh"

# CURRENT_WIFI="$(wdutil info)"
SSID="$(networksetup -getairportnetwork en0 | sed -E 's/Current Wi-Fi Network: //')"
# CURR_TX="$(echo "$CURRENT_WIFI" | grep "Tx Rate" | sed -E 's/.*Tx Rate.*: //')"

if [[ "$SSID" = "" ]]; then
  sketchybar \
    --set "$NAME" \
      label="W!!" \
      label.color="$ISSUE_COLOUR" \
      icon.drawing=off
else
  sketchybar \
    --set "$NAME" \
      drawing=off icon.drawing=off
fi
