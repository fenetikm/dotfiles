#!/usr/bin/env zsh

WIDTH=1600
if [[ ! -z "$1" ]]; then
  WIDTH=$1
fi

HEIGHT=1200
if [[ ! -z "$2" ]]; then
  HEIGHT=$2
fi

/bin/zsh "$HOME/.config/yabai/send_space.sh" 6 1
/bin/zsh "$HOME/.config/yabai/resize.sh" c "$WIDTH","$HEIGHT" 1
