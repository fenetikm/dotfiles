#!/usr/bin/env zsh

# called from karabiner, hence the `/bin/zsh`

SIZE=$(/bin/zsh "$HOME/.config/yabai/cycle.sh" fullscreen 1 full 1900,1200 1600,1200 1400,900)

/bin/zsh "$HOME/.config/yabai/resize.sh" c "$SIZE" 1
