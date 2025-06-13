#!/usr/bin/env zsh

# `ma` - creates session using current

# $# is the arg count
if [[ $# -eq 1 ]]; then
  selected=$1
else
  # todo here: fallback to some usual directories

    # selected=$(find ~/work/builds ~/projects ~/ ~/work ~/personal ~/personal/yt -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)

# todo:
# - check for running tmux

TMUX_RUNNING=$(pgrep tmux)
echo $TMUX_RUNNING

# prime stuff:
# if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
#     tmux new-session -s $selected_name -c $selected
#     exit 0
# fi
#
# if ! tmux has-session -t=$selected_name 2> /dev/null; then
#     tmux new-session -ds $selected_name -c $selected
# fi
#
# tmux switch-client -t $selected_name

# check for tmux setup file

# what do commands do:
# - `new-session` create a new session
# .. -c start directory, -s session-name, -n window-name, -d detached <shell-command>
# .. -A makes new-session behave like attach-session
#
# - `attach-session` attach to a session by name
# - `switch-client` detach and attach to session
# .. -t target-session
# - `has-session` reports error if session does not exist, otherwise exit 0
# .. -t target-session
