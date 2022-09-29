#!/bin/zsh

CWD=$(pwd)
SESSION_NAME="pc"

# detach from a tmux session if in one
tmux detach > /dev/null

# Create a new session, -d means detached itself
set -- $(stty size) # $1 = rows $2 = columns
tmux new-session -d -s $SESSION_NAME -x "$2" -y "$(($1 - 1))" -n 'code'

# Don't need the following, rename at the end
# tmux new-window -t $SESSION_NAME:1 -n 'code'
# tmux new-window -t $SESSION_NAME:2 -n 'test'
tmux new-window -t $SESSION_NAME:2 -n 'php'
# tmux new-window -t $SESSION_NAME:4 -n 'sql'
tmux new-window -t $SESSION_NAME:3 -n 'aptible'
tmux new-window -t $SESSION_NAME:4 -n 'nv'
tmux new-window -t $SESSION_NAME:5 -n 'hammer'

## Test Window
# tmux select-window -t $SESSION_NAME:2
# tmux split-window -h -l70
# tmux split-window -v -l60%

# tmux select-pane -t 1
# tmux send-keys "~pct" C-m
# tmux send-keys "v" C-m
# tmux select-pane -t 2
# tmux send-keys "~pct" C-m
# tmux send-keys "/usr/local/bin/chromedriver --url-base=/wd/hub" C-m
# tmux select-pane -t 3
# tmux send-keys "~pct" C-m

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

## SQL Window
# tmux select-window -t $SESSION_NAME:4
# tmux split-window -h -l30%

# tmux select-pane -t 1
# tmux send-keys "~pcp" C-m
# tmux send-keys "v queries.sql" C-m
# tmux select-pane -t 2
# tmux send-keys "~pcp" C-m
# tmux send-keys "mycli -d pcp" C-m
# tmux select-pane -t 1

## Aptible
tmux select-window -t $SESSION_NAME:3
tmux send-keys "~pcp" C-m

## Neovim Window
tmux select-window -t $SESSION_NAME:4
tmux send-keys "~nv" C-m

## Hammerspoon config
tmux select-window -t $SESSION_NAME:5
tmux send-keys "~" C-m
tmux send-keys "vl eh" C-m

## Main Window
tmux select-window -t $SESSION_NAME:1
tmux rename-window 'code'
tmux split-window -h -l70

tmux select-pane -t 2
tmux send-keys "~pcp" C-m
tmux send-keys "figlet -f roman Ready! | lolcat -t" C-m
tmux select-pane -t 1
tmux send-keys "~pcp" C-m
tmux send-keys "v" C-m

# Finally attach to it
tmux attach -t $SESSION_NAME
