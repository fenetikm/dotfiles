#!/usr/bin/env zsh

# usage:
#
# sesh.sh <template> <session_name> <target_directory>
#
# - <template> - auto (default) or specific
# - <session_name>, defaults to directory name
# - <target_directory>, defaults to current directory

switch_to_session() {
    if [[ -z "$TMUX" ]]; then
        tmux attach-session -t $1
    else
        tmux switch-client -t $1
    fi
}

TEMPLATE=$1
if [[ "$TEMPLATE" == "" ]]; then
  TEMPLATE="auto"
fi

SESSION_NAME=$2
if [[ "$SESSION_NAME" == "" ]]; then
  # special case if we are in the home directory
  if [[ "$HOME" == $(pwd) ]]; then
    SESSION_NAME="z"
  else
    SESSION_NAME=$(basename $(pwd) | tr ".,: " "____")
  fi
fi

DIR=$3
if [[ "$DIR" == "" ]]; then
  DIR=$(pwd)
fi

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  switch_to_session $SESSION_NAME
else
  tmux new-session -ds "$SESSION_NAME" -n setup -c "$DIR"
  tmux select-window -t "$SESSION_NAME":setup
  tmux select-pane -t 1
  tmux send-keys -t "$SESSION_NAME":setup "tmux_setup $TEMPLATE $SESSION_NAME" C-m

  switch_to_session "$SESSION_NAME"
fi
