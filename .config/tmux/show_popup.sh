#!/usr/bin/env zsh

session="_popup_$(tmux display -p '#S')"

if ! tmux has -t "$session" 2> /dev/null; then
  session_id="$(tmux new-session -dP -s "$session" -F '#{session_id}')"
  tmux set-option -s -t "$session_id" key-table popup
  tmux set-option -t "$session_id" window-active-style "bg=#020223"
  tmux set-option -s -t "$session_id" status off
  tmux set-option -s -t "$session_id" prefix None
  session="$session_id"
fi

exec tmux attach -t "$session" > /dev/null
