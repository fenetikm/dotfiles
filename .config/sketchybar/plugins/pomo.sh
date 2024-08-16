#!/bin/sh

# Todo:
# - check if thyme running
# - change tomato icon to something else when on break?
# - colours:
# - yellow for warning
# - bright blue for break

TIMELEFT=
COLOUR='0xffffffff'
if [ -f ~/.thyme-tmux ]; then
  TIMELEFT=`cat ~/.thyme-tmux | gsed 's/:[0-9][0-9]/m/' | gsed 's/\[[a-zA-Z= ]*\]//g' | gsed 's/\#//g'`
  THYME=`cat ~/.thyme-tmux`
  if [[ $THYME =~ yellow ]]; then
    COLOUR='0xffffc552'
  fi
fi

ICON=" "
# The item invoking this script (name $NAME) will get its icon and label

if [[ -n "$TIMELEFT" ]]; then
  sketchybar --set "$NAME" icon="$ICON" icon.color="${COLOUR}" label="${TIMELEFT}" label.color="${COLOUR}" drawing=on \
    label.padding_right=8 \
    icon.padding_left=8 \
    background.drawing=on background.color=0xff2f2f3a \
    background.corner_radius=4 background.height=20 background.y_offset=0
else
  sketchybar --set "$NAME" drawing=off
fi
