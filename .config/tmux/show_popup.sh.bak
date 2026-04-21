#!/usr/bin/env zsh

SESSION="_popup_"

# detach / hide if already visible
if [[ "$(tmux display-message -p -F "#{session_name}")" = "$SESSION" ]]; then
  tmux detach-client
else
  # see .tmux.conf.popup for options set on the popup
  tmux display-popup -d '#{pane_current_path}' -b rounded -w 70% -h 70% -s "bg=#020223" -E "tmux attach -t $SESSION || tmux new -s $SESSION"
fi
