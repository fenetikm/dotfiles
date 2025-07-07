#!/usr/bin/env zsh

# called from karabiner, hence the full paths

SIZE=$(/bin/zsh "$HOME/.config/yabai/cycle.sh" fullscreen 1 full 1600,1200 1400,900)

/bin/zsh "$HOME/.config/yabai/resize.sh" c "$SIZE" 1
