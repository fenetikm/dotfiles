#! /usr/bin/env zsh

# find the kitty window
# place it far right
KITTY=$(yabai -m query --windows | jq -r '.[] | select(."app" == "kitty")')
if [[ "$KITTY" == "" ]]; then
  exit 1
fi

DISPLAY=$(echo "$KITTY" | jq '."display"')
if [[ "$DISPLAY" != 2 ]]; then
  exit 1
fi
KITTY_ID=$(echo "$KITTY" | jq '.id')

# find right most window (has greatest x) to swap with
WINDOWS=($(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == true and ."is-floating" == false)]' | jq 'sort_by(.frame.x) | reverse' |  jq -r '.[] .id | @sh'))

# don't swap with self
if [[ "$KITTY_ID" != "$WINDOWS[1]" ]]; then
  yabai -m window "$KITTY_ID" --swap "$WINDOWS[1]"
fi

# hide floating window apps?
HAS_FLOATING=$(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == true and ."is-floating" == true)]')
if [[ "$HAS_FLOATING" != "[]" ]]; then
  FLOATING_PIDS=($(echo "$HAS_FLOATING" | jq -r '.[] .pid | @sh'))
  for p in "${FLOATING_PIDS[@]}"
  do
    hs -c "hs.application.applicationForPID($p):hide()"
  done
fi

source "$HOME"/.config/yabai/balance.sh

yabai -m window "$KITTY_ID" --focus
