#! /usr/bin/env zsh

WINDOW=$(yabai -m query --windows --window)
WID=$(echo "$WINDOW" | jq '."id"')
# if [[ $(echo "$WINDOW" | jq -re 'select(."is-floating" == true') ]]; then
#   echo 'floating' >> /tmp/yabai_michael.out.log
# fi
# yabai -m window "$WID" --toggle shadow
yabai -m window "$WID" --toggle float

source "$HOME"/.config/yabai/balance.sh
