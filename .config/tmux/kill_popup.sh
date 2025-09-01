#!/usr/bin/env zsh

SESSIONS=$(tmux list-sessions -F '#{session_name}')
SESH_LINES=(${(f)SESSIONS})
SESH_COUNT=0
FOUND=0
for SESH in "${SESH_LINES[@]}"; do
  if [[ "$SESH" == "_popup_" ]]; then
    FOUND=1
  fi
  SESH_COUNT=$((SESH_COUNT + 1))
done

if [[ "$SESH_COUNT" == 1 && "$FOUND" == 1 ]]; then
  tmux kill-session -t "_popup_"
fi
