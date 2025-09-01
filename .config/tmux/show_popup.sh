#!/usr/bin/env zsh

SESSION="_popup_"

if [[ "$(tmux display-message -p -F "#{session_name}")" = "$SESSION" ]]; then
    tmux detach-client
else
    tmux display-popup -d '#{pane_current_path}' -b rounded -w 70% -h 70% -s "bg=#020223" -E "tmux attach -t $SESSION || tmux new -s $SESSION"
    # tmux set-option -s -t "$SESSION" status off
    # tmux set-option -s -t "$SESSION" window-active-style "bg=#020223"
    # tmux set-option -s -t "$SESSION" pane-border-status off
fi
