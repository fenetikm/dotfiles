#!/usr/bin/env zsh

# called from karabiner, hence the full paths
DIR="$1"

LAYOUT=$(/bin/zsh "$HOME/.config/yabai/scripts/cycle.sh" layout "$DIR" 13 12 23 14)

/bin/zsh "$HOME/.config/yabai/scripts/resize.sh" x "$LAYOUT" 0 1
