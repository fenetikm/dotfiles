#!/usr/bin/env zsh

# $INFO has the volume percentage
if [[ "$SENDER" = "volume_change" ]]; then
  VOLUME="$INFO"

  VOL_LOC="$HOME/.config/sketchybar/plugins/vol_state.sh"
  TIMESTAMP=$(/bin/date +%s)
  echo "VOL_TIME=$TIMESTAMP" > "$VOL_LOC"

  sketchybar --set "$NAME" label="V:$VOLUME" icon.drawing=off padding_right=4

  # "$HOME/.config/sketchybar/plugins/volume_clear.sh &"
fi
