#!/bin/zsh

source "$HOME/.config/sketchybar/vars.sh"

END_DATE=$(jq -r '.activeSessions[0] | .endDate' ~/Library/Application\ Support/Focus/default.cfg)

if [[ "$END_DATE" == "null" ]]; then
  sketchybar --set "$NAME" drawing=off
else
  PROFILE_ID=$(jq -r '.activeSessions[0] | .profileID' ~/Library/Application\ Support/Focus/default.cfg)
  echo $PROFILE_ID
  PROFILE_COLOUR=$(jq -r '.profiles | .[] | select(.uniqueID == "'"$PROFILE_ID"'") | .color' ~/Library/Application\ Support/Focus/default.cfg)
  PROFILE_NAME=$(jq -r '.profiles | .[] | select(.uniqueID == "'"$PROFILE_ID"'") | .name' ~/Library/Application\ Support/Focus/default.cfg)

  local BG_COLOUR=0xff99a4bc
  local FG_COLOUR=0xff000006
  local ICON=
  local SECONDS=$(echo "$END_DATE" | xargs -I{} bash -c 'echo $(( $(date -j -f "%Y-%m-%dT%H:%M:%S%z" "{}" +%s) - $(date +%s) ))')
  local CALC="($SECONDS) / 60"
  local MINS=$(echo $CALC | bc)
  local HRS=$(echo "($MINS) / 60" | bc)
  local TEXT="$MINS"m
  if [[ "$HRS" > 0 ]]; then
    TEXT="$HRS"h"$TEXT"
  fi
  TEXT="$TEXT $PROFILE_NAME"

  sketchybar --set "$NAME" icon="$ICON" icon.color="${FG_COLOUR}" label="${TEXT}" label.color="${FG_COLOUR}" drawing=on \
    padding_right=7 \
    label.padding_right=8 \
    icon.padding_left=8 \
    background.shadow.drawing=on background.shadow.distance=1 \
    background.drawing=on background.color=$BG_COLOUR \
    background.corner_radius=$BG_RADIUS background.height=$BG_HEIGHT
fi


