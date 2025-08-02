#!/usr/bin/env zsh

source "$HOME/.config/sketchybar/vars.sh"

SPACE_INFO=$(yabai -m query --spaces --display 2 | jq -re '.[] | select(."is-visible" == true)')
if [[ "$SPACE_INFO" == *"could not retrieve"* ]]; then
  SPACE=
else
  SPACE=$(echo "$SPACE_INFO" | jq -r '.label')
  # uppercase first letter
  SPACE="${(C)SPACE}"
fi

sketchybar \
  --set "$NAME" label="${SPACE}" label.color="$PASSIVE_COLOUR" \
    icon.drawing=off padding_left=6 padding_right=1
