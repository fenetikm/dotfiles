#!/bin/zsh

# Note that this assumes base index of 1

# check for existence of required things
# $1 is the name of the window
# we are in the directory of the drupal project

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, requires name of window."
    exit 1
fi

CWD=$(pwd)

# detach from a tmux session if in one
tmux detach > /dev/null

# Create a new session, -d means detached itself
tmux new-session -d -s $1

tmux new-window -t $1:1 -n 'Code'

## Main Window
tmux select-window -t $1:1
tmux rename-window 'Code'

# Split into left and right
tmux split-window -h -p 33

# Open the things
# Todo.txt in top right

# Bottom right ready for taking commands / tests.
tmux select-pane -t 2
tmux send-keys "figlet -f roman Ready!" C-m

# Left for neovim.
tmux select-pane -t 1
tmux send-keys "v" C-m

# Finally attach to it
tmux attach -t $1
