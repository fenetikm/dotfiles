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
SESSION_NAME="$1"

# detach from a tmux session if in one
tmux detach > /dev/null

# Create a new session, -d means detached itself
set -- $(stty size) # $1 = rows $2 = columns
tmux new-session -d -s $SESSION_NAME -x "$2" -y "$(($1 - 1))"

tmux new-window -t $SESSION_NAME:1 -n 'code'
tmux new-window -t $SESSION_NAME:2 -n 'logs'
tmux new-window -t $SESSION_NAME:3 -n 'zsh'

## Logs window
tmux select-window -t $SESSION_NAME:2

# Start up the logs listener
tmux send-keys "vbin/tail -f /var/log/apache2/error.log | clog drupal" C-m

## Zsh window
tmux select-window -t $SESSION_NAME:3
tmux rename-window 'Zsh'

## Main Window
tmux select-window -t $SESSION_NAME:1
tmux rename-window 'code'

# Split into left and right
tmux split-window -h -p30

# Right ready for taking commands / tests.
tmux select-pane -t 2
tmux send-keys "figlet -f roman Ready! | lolcat -t" C-m

# Left for neovim.
tmux select-pane -t 1
tmux send-keys "v" C-m

# Finally attach to it
tmux attach -t $SESSION_NAME
