#!/bin/zsh

CWD=$(pwd)
SESSION_NAME="blog"

# detach from a tmux session if in one
tmux detach > /dev/null

# Create a new session, -d means detached itself
set -- $(stty size) # $1 = rows $2 = columns
tmux new-session -d -s $SESSION_NAME -x "$2" -y "$(($1 - 1))" -n 'edit'

# Don't need the following, rename at the end
tmux new-window -t $SESSION_NAME:2 -n 'server'
tmux new-window -t $SESSION_NAME:3 -n 'admin'

## Admin Window
tmux select-window -t $SESSION_NAME:3
tmux select-pane -t 1
tmux send-keys "~blog" C-m

## Server Window
tmux select-window -t $SESSION_NAME:2
tmux select-pane -t 1
tmux send-keys "~blog" C-m
tmux send-keys 'hugo server -D -F' C-m

## Main Window
tmux select-window -t $SESSION_NAME:1
tmux select-pane -t 1
tmux rename-window 'edit'
tmux send-keys "~blog"
# load last edited markdown file in content foldeR
tumx send-keys "v `find ./content -name '*.md' -type f -exec stat -lt "%Y-%m-%d" {} \+ | cut -d' ' -f6- | sort -n | tail -1 | cut -d' ' -f2-`" C-m

# Finally attach to it
tmux attach -t $SESSION_NAME
