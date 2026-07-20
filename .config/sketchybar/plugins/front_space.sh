#!/usr/bin/env zsh

source "$HOME/.config/sketchybar/vars.sh"

SPACE_INFO=$(yabai -m query --spaces --space)
if [[ "$SPACE_INFO" == *"could not retrieve"* ]]; then
  SPACE=
else
  SPACE=$(echo "$SPACE_INFO" | jq -r '.label')
  SPACE="${(C)SPACE}"
fi

sketchybar \
  --set "$NAME" \
    icon.drawing=off \
    label="${SPACE}" \
    label.color="$PASSIVE_COLOUR" \
    padding_left=6 padding_right=1
