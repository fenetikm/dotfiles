#!/usr/bin/env zsh

MODE=$(yabai -m query --spaces --space | jq -r '.type')
SPACE_INDEX=$(yabai -m query --spaces --space | jq -r '.index')

if [[ "$MODE" == "bsp" ]]; then
  yabai -m space --layout stack
else
  yabai -m space --layout bsp
  /bin/zsh "$HOME/.config/yabai/scripts/reset_opacity.sh" "$SPACE_INDEX"
fi
