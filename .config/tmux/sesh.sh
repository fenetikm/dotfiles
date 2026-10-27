#!/usr/bin/env zsh

# usage:
#
# sesh.sh [-d] <template> <session_name> <target_directory> [<args>...]
#
# - -d - create the session but don't attach / switch to it
# - <template> - "auto" (default), "none" or specific
# - <session_name>, defaults to directory name
# - <target_directory>, defaults to current directory
# - <args>, passed on to the template's .tmux.setup after the target directory
#
# see ~/.config/zsh/tmux.sh for the `tmux_setup` function

switch_to_session() {
  local TARGET="$1"
  if [[ -z "$TMUX" ]]; then
    tmux attach-session -t "$TARGET"
  else
    tmux switch-client -t "$TARGET:1"
  fi
}

DETACHED=false
if [[ "$1" == "-d" ]]; then
  DETACHED=true
  shift
fi

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
  if [[ "$DETACHED" == true ]]; then
    echo "Session $SESSION_NAME already exists."
  else
    switch_to_session $SESSION_NAME
  fi
else
  # a detached session defaults to 80x24, so get the current size to use for a new session
  SIZE=()
  if [[ -n "$TMUX" ]]; then
    SIZE=(-x "$(tmux display-message -p '#{client_width}')" -y "$(tmux display-message -p '#{client_height}')")
  fi
  tmux new-session -ds "$SESSION_NAME" -n setup -c "$DIR" "${SIZE[@]}"
  tmux select-window -t "$SESSION_NAME":setup
  # target the new session, a bare `-t 1` hits the current one when detached
  tmux select-pane -t "$SESSION_NAME":setup.1
  # ${*:3} not ${@:3}, the latter splits into separate send-keys args that get
  # typed with no spaces between them
  tmux send-keys -t "$SESSION_NAME":setup "tmux_setup $TEMPLATE $SESSION_NAME ${*:3}" C-m

  if [[ "$DETACHED" == false ]]; then
    switch_to_session "$SESSION_NAME"
  fi
fi
