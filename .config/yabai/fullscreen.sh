#!/usr/bin/env zsh

SIZE=$(/bin/zsh "$HOME/.config/yabai/cycle.sh" fullscreen full 1600,1200 1400,900)

/bin/zsh "$HOME/.config/yabai/resize.sh" c "$SIZE" 1
