#! /usr/bin/env zsh

echo '################'
echo 'window focused'

# if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
  # not floating
# fi

wid="${YABAI_WINDOW_ID}"
WINDOW=$(yabai -m query --windows --window "$wid")
# echo "$WINDOW"
echo $(echo "$WINDOW" | jq '.id')
# echo $wid
# echo $(yabai -m query --windows --window "$wid" | jq '.title')

display=$(yabai -m query --displays --space | jq '.index')
SPACE=$(yabai -m query --spaces --space)
if [[ $(echo "$SPACE" | jq -re '."type" == "stack"') == true ]]; then
  if [[ $(echo "$SPACE" | jq -re '."first-window" == '"$wid") == true ]]; then
    # get all other windows
    WINDOWS=($(echo "$SPACE" | jq '."windows" | @sh'))
    # echo "$wid"
    for w in "${WINDOWS[@]}"
    do
      if [[ "$w" == "$wid" ]]; then
        echo $w
      fi
    done
  fi
fi

# todo
# check which display we are on, exit if display 1
# don't include floating windows
# and not hidden
# and not stacked
# if two windows, default to 1 / 23
# if one window, then add in lots of padding

# window=$(yabai -m query --windows --window "${wid}")
# echo $window
# space=$(cat $window | jq '.space')
# echo $space
# display=$(yabai -m query --windows --window "${wid}" | jq '.display')
# windows=$(yabai -m query --displays --display $display | jq -)

# yabai -m query --windows --window "${wid}" | jq -re '."display" == "2"' \
    # && yabai -m space $(yabai -m query --windows --window "$wid" | jq '.space') --balance
