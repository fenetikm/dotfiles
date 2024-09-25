#! /usr/bin/env zsh

echo '################'
echo 'balance'

WINDOWS=($(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == true and ."is-floating" == false)]' | jq 'sort_by(.frame.x)' | jq -r '.[] .id | @sh'))
WINDOW_COUNT=${#WINDOWS}
DISPLAY=$(yabai -m query --displays --space | jq '.index')

DISPLAY_WIDTH=$(yabai -m query --displays --space | jq '.frame.w')
# this should really work out the ratio instead of only looking at the width
IS_ULTRAWIDE=$(echo "$DISPLAY_WIDTH > 3000" | bc -l)

if [[ "$WINDOW_COUNT" == 2 && "$DISPLAY" == 2 && "$IS_ULTRAWIDE" == 1 ]]; then
  yabai -m window "$WINDOWS[1]" --ratio "abs:0.333334"
elif [[ "$IS_ULTRAWIDE" == 0 ]]; then
  yabai -m space --balance
elif [[ "$WINDOW_COUNT" > 2 && "$DISPLAY" == 2 ]]; then
  yabai -m space --balance
elif [[ "$DISPLAY" != 2 ]]; then
  yabai -m space --balance
fi

# todo: do the padding thing if only one window on display 2
