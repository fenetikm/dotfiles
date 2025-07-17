#!/usr/bin/env zsh

# todo:
# - show a sensible message when it does exist

# for holding the previous state before switching
STATE_FILE="$HOME/.config/tmux/tmp_state.zsh"


ACTION=$1
if [[ "$ACTION" == "" ]]; then
  ACTION="switch"
fi

if [[ "$ACTION" == "in" ]]; then
  exit 0
fi

CURRENT_LOC="$2":"$3"."$4"
source "$STATE_FILE"

# can match if focus happened some external way
if [[ "$CURRENT_LOC" == "$LAST_LOC" ]]; then
  exit 0
fi

case "$ACTION" in
  out)
    echo "LAST_LOC=$CURRENT_LOC" > "$STATE_FILE"
    ;;
  in)
    # not used
    ;;
  switch)
    tmux switch-client -t "$LAST_LOC"
    ;;
esac
