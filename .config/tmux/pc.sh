#!/usr/bin/env zsh

SESSION_NAME=$(tmux display-message -p '#S')
tmux rename-session -t $SESSION_NAME pcp
SESSION_NAME=pcp

tmux new-window -t $SESSION_NAME:2 -n 'php'
tmux new-window -t $SESSION_NAME:3 -n 'aptible'

## PHP Window
tmux select-window -t $SESSION_NAME:2
tmux split-window -h -l70

tmux select-pane -t 1
tmux send-keys "~pcp" C-m
tmux send-keys "vl ep" C-m
tmux select-pane -t 2
tmux send-keys "~pcp" C-m
tmux send-keys "php -a" C-m
tmux select-pane -t 1

## Aptible
tmux select-window -t $SESSION_NAME:3
tmux send-keys "~pcp" C-m

## Main Window
tmux select-window -t $SESSION_NAME:1
tmux rename-window 'code'
tmux split-window -h -l70

tmux select-pane -t 2
tmux send-keys "~pcp" C-m
tmux send-keys "clear" C-m
tmux select-pane -t 1
tmux send-keys "~pcp" C-m
tmux send-keys "v" C-m
