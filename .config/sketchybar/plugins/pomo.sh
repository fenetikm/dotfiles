#!/bin/zsh

source "$HOME/.config/sketchybar/vars.sh"

TIMELEFT=
COLOUR=$DEFAULT_COLOUR
if [ -f ~/.thyme-tmux ]; then
  TIMELEFT=`cat ~/.thyme-tmux | gsed 's/:[0-9][0-9]/m/' | gsed 's/\[[a-zA-Z= ]*\]//g' | gsed 's/\#//g'`
  THYME=`cat ~/.thyme-tmux`
  if [[ $THYME =~ yellow ]]; then
    COLOUR=$WARNING_COLOUR
  fi
  if [[ $THYME =~ blue ]]; then
    COLOUR=$COOL_COLOUR
  fi
fi

ICON=" "

if [[ -n "$TIMELEFT" ]]; then
  sketchybar --set "$NAME" icon="$ICON" icon.color="${COLOUR}" label="${TIMELEFT}" label.color="${COLOUR}" drawing=on \
    padding_right=0 \
    label.padding_right=8 \
    icon.padding_left=8 \
    background.shadow.drawing=on background.shadow.distance=1 \
    background.drawing=on background.color=$BG2_COLOUR \
    background.border_color=$BG2_BORDER_COLOUR background.border_width=$BG_BORDER_WIDTH \
    background.corner_radius=$BG_RADIUS background.height=$BG_HEIGHT
else
  sketchybar --set "$NAME" drawing=off
fi
