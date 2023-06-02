#!/bin/zsh

CWD=$(pwd)
BLOG_SESSION_NAME="blog"

# Create a new session, -d means detached itself
set -- $(stty size) # $1 = rows $2 = columns
tmux new-session -d -s $BLOG_SESSION_NAME -x "$2" -y "$(($1 - 1))" -n 'edit'

tmux new-window -t $BLOG_SESSION_NAME:2 -n 'server'
tmux new-window -t $BLOG_SESSION_NAME:3 -n 'admin'

## Main Window
tmux select-window -t $BLOG_SESSION_NAME:1
tmux rename-window 'edit'
tmux send-keys "~blog" C-m
# load last edited markdown file in content folder
tmux send-keys "hl" C-m

## Server Window
tmux select-window -t $BLOG_SESSION_NAME:2
tmux select-pane -t 1
tmux send-keys "~blog" C-m
tmux send-keys 'hugo server -D -F' C-m

## Admin Window
tmux select-window -t $BLOG_SESSION_NAME:3
tmux split-window -h -l50%
tmux select-pane -t 2
tmux send-keys "~blog" C-m
tmux send-keys "v ./themes/falcon/assets/sass/main.scss" C-m
tmux select-pane -t 1
tmux send-keys "~blog" C-m
tmux send-keys "v" C-m

# switch back to first window
tmux select-window -t $BLOG_SESSION_NAME:1

# Finally attach to it
tmux attach -t $BLOG_SESSION_NAME
