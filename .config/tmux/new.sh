#!/bin/zsh

# Note that this assumes base index of 1

# check for existence of required things
# $1 is the name of the window

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, requires name of session."
    exit 1
fi

CWD=$(pwd)
SESSION_NAME="$1"

# detach from a tmux session if in one
tmux detach > /dev/null

# Create a new session, -d means detached itself
set -- $(stty size) # $1 = rows $2 = columns
tmux new-session -d -s $SESSION_NAME

tmux new-window -t $SESSION_NAME:1 -n 'zsh'

## Main Window
tmux select-window -t $SESSION_NAME:1
tmux rename-window 'zsh'

tmux send-keys "figlet -f roman Ready!" C-m

# Finally attach to it
tmux attach -t $SESSION_NAME
