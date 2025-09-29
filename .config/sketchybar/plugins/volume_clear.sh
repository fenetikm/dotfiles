#!/usr/bin/env zsh

sleep 2
VOL_LOC="$HOME/.config/sketchybar/plugins/vol_state.sh"
source "$VOL_LOC"
TIMESTAMP=$(/bin/date +%s)
if (( ("$VOL_TIME" + "2") <= "$TIMESTAMP" )); then
  # sketchybar --set "volume" drawing=off
  echo "Time's up!"
fi
