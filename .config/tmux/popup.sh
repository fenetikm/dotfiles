#!/usr/bin/env zsh

# what we want:
# - ephemeral vs persistent
# - pass in a name and type
# - sensible defaults
# - closes on quit
#
# also:
# - need to put some kind of identifier in popup sessions for styling and autokilling

NAME=$1
if [[ "$1" == "" ]]; then
  NAME=$(echo $RANDOM)
fi

SESSION="$NAME"_popup_

TYPE=$2
if [[ "$2" == "" ]]; then
  TYPE="ephemeral"
fi

if [[ "$TYPE" == "persistent" ]]; then
  # detach / hide if already visible
  if [[ "$(tmux display-message -p -F "#{session_name}")" = "$SESSION" ]]; then
    tmux detach-client
  else
    # see .tmux.conf.popup for options set on the popup
    # set via the `after-new-session` hook
    tmux display-popup -d '#{pane_current_path}' -b rounded -w 70% -h 70% -s "bg=#020223" -E "tmux attach -t $SESSION || tmux new -s $SESSION"
  fi
else
fi
