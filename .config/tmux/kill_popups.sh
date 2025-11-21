#!/usr/bin/env zsh
# kill popup sessions if they are the only ones left

SESSIONS=$(tmux list-sessions -F '#{session_name}')
SESH_LINES=(${(f)SESSIONS})
SESH_COUNT=0
POP_COUNT=0
for SESH in "${SESH_LINES[@]}"; do
  if [[ "$SESH" =~ "_popup_" ]]; then
    POP_COUNT=$((POP_COUNT + 1))
  fi
  SESH_COUNT=$((SESH_COUNT + 1))
done

if [[ "$SESH_COUNT" == "$POP_COUNT" ]]; then
  for SESH in "${SESH_LINES[@]}"; do
    tmux kill-session -t "$SESH"
  done
fi
