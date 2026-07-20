#!/usr/bin/env zsh

source "$HOME/.config/sketchybar/vars.sh"

# with day
# DATETIME=`date '+%a, %d %b. %l:%M%p' | sed -E 's/  / /g'`

# without
DATETIME=`date '+%d %b. %l:%M%p' | sed -E 's/  / /g'`

sketchybar \
  --set "$NAME" \
    label="${DATETIME}" \
    label.padding_right=10 label.padding_left=10 \
    icon.drawing=off \
    background.drawing=on background.color=$BG1_COLOUR \
    background.shadow.drawing=on background.shadow.distance=1 \
    background.border_color=$BG1_BORDER_COLOUR background.border_width=$BG_BORDER_WIDTH \
    background.corner_radius=$BG_RADIUS background.height=$BG_HEIGHT
