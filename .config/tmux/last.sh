#!/usr/bin/env zsh

# for holding the previous state before switching
STATE_FILE="$HOME/.config/tmux/tmp_state.zsh"

# either focus based or use a stack somehow

ACTION=$1
if [[ "$ACTION" == "" ]]; then
  ACTION="switch"
fi

if [[ "$ACTION" == "in" ]]; then
  exit 0
fi

CURRENT_LOC="$2":"$3"."$4"
source "$STATE_FILE"

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
