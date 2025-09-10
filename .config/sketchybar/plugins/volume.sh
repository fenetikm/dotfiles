#!/bin/zsh

# todo: show when it changes, then hide after a second
# ...do this with a sleep / wait?
# ... create semaphore?

# $INFO has the volume percentage
if [[ "$SENDER" = "volume_change" ]]; then
  VOLUME="$INFO"

  sketchybar --set "$NAME" label="V:$VOLUME" icon.drawing=off padding_right=4

fi
