#!/usr/bin/env zsh

# usage:
# - $1: session name, defaults to directory name
# - $2: target directory, defaults to current directory

# todo:
# - test if no tmux running at all

switch_to_session() {
    if [[ -z "$TMUX" ]]; then
        tmux attach-session -t $1
    else
        tmux switch-client -t $1
    fi
}

SESSION_NAME=$1
if [[ "$SESSION_NAME" == "" ]]; then
  SESSION_NAME=$(basename $(pwd) | tr ".,: " "____")
fi

DIR=$2
if [[ "$DIR" == "" ]]; then
  DIR=$(pwd)
fi

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  switch_to_session $SESSION_NAME
else
  tmux new-session -ds "$SESSION_NAME" -n setup -c "$DIR"
  tmux select-window -t "$SESSION_NAME":setup
  tmux select-pane -t 1
  tmux send-keys -t "$SESSION_NAME":setup "tmux-setup $SESSION_NAME" C-m
  switch_to_session "$SESSION_NAME"
fi
