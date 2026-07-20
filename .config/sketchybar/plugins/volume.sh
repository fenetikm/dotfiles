#!/usr/bin/env zsh

source "$HOME/.config/sketchybar/vars.sh"

# $INFO has the volume percentage
if [[ "$SENDER" = "volume_change" ]]; then
  VOLUME="$INFO"

  VOL_LOC="$HOME/.config/sketchybar/plugins/vol_state.sh"
  TIMESTAMP=$(/bin/date +%s)
  echo "VOL_TIME=$TIMESTAMP" > "$VOL_LOC"

  sketchybar \
    --set "$NAME" \
      icon="V:" \
      icon.drawing=on \
      icon.font="${FONT}:${FONT_WEIGHT}:${FONT_SIZE}" icon.color="${ICON_COLOUR}" \
      icon.padding_left=0 \
      label="${VOLUME}" \
      label.padding_left=0 \
      padding_right=6 padding_left=6
fi
