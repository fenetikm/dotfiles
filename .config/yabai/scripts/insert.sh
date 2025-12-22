#!/usr/bin/env zsh

echo '################'
echo 'insert'

if [[ "$1" == "" ]]; then
  echo "Missing insert position argument."

  exit 1
fi

# todo: make sure that arg is less than number of windows
# todo: make sure space is in BSP mode!

# toggle float off for current window if applicable
if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == true ]]; then
  yabai -m window --toggle float
fi

WINDOW=$(yabai -m query --windows --window | jq '.id')
WINDOWS=($(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == true and ."is-floating" == false)]' | jq 'sort_by(.frame.x)' |  jq -r '.[] .id | @sh'))
TARGET="${WINDOWS[$1]}"
WINDOW_COUNT=${#WINDOWS[@]}

# if it's the last window on the right, only swap works?!
if [[ "$WINDOW" == "${WINDOWS[$WINDOW_COUNT]}" ]]; then
  yabai -m window "$TARGET" --swap "$WINDOW"
else
  yabai -m window "$TARGET" --insert west
  yabai -m window "$TARGET" --warp "$WINDOW"
fi

source "$HOME"/.config/yabai/scripts/balance.sh
