#!/bin/zsh

# Note that this assumes base index of 1.

CWD=$(pwd)
SESSION_NAME="taskwarrior"

# detach from a tmux session if in one.
tmux detach > /dev/null

# Create a new session, -d means detached itself
# Next two lines sets up the size so we can set it when detached
set -- $(stty size) # $1 = rows $2 = columns
tmux new-session -d -s $SESSION_NAME -x "$2" -y "$(($1 - 1))"

tmux new-window -t $SESSION_NAME:1 -n 'vimwiki'

## Main window.
tmux select-window -t $SESSION_NAME:1
tmux rename-window 'vimwiki'

# Split into top and bottom
tmux split-window -v -p40

# Open the things.
# Bottom.
tmux select-pane -t 2
tmux send-keys "task" C-m

# Top for vimwiki.
tmux select-pane -t 1
tmux send-keys "cd ~/vimwiki && v index.md" C-m

# Attach to it.
tmux attach -t $SESSION_NAME

# Hide status bar.
tmux set-window-option -t:1 status off
