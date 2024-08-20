#!/bin/sh

source "$HOME/.config/sketchybar/colours.sh"

# Todo:
# - bright blue for break
# - make it simpler / smaller, put furthest right?

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
    label.padding_right=8 \
    icon.padding_left=8 \
    background.shadow.drawing=on background.shadow.distance=1 \
    background.drawing=on background.color=$BG1_COLOUR \
    background.border_color=$BG1_BORDER_COLOUR background.border_width=1 \
    background.corner_radius=6 background.height=22 background.y_offset=0
else
  sketchybar --set "$NAME" drawing=off
fi
