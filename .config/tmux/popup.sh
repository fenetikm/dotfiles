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

# "smart" sizing
PERC=70
MIN_WIDTH=130
MIN_HEIGHT=50
CURRENT_WIDTH=$(tmux display -p "#{window_width}")
CURRENT_HEIGHT=$(tmux display -p "#{window_height}")
MARGIN=10
WIDTH=$(( CURRENT_WIDTH * PERC / 100 ))
if (( WIDTH < MIN_WIDTH )); then
  if (( MIN_WIDTH + MARGIN > CURRENT_WIDTH )); then
    WIDTH=$(( CURRENT_WIDTH - MARGIN ))
  else
    WIDTH=$(( MIN_WIDTH ))
  fi
fi
HEIGHT=$(( CURRENT_HEIGHT * PERC / 100 ))
if (( HEIGHT < MIN_HEIGHT )); then
  if (( MIN_HEIGHT + MARGIN > CURRENT_HEIGHT )); then
    HEIGHT=$(( CURRENT_HEIGHT - MARGIN ))
  else
    HEIGHT=$(( MIN_HEIGHT ))
  fi
fi

if [[ "$TYPE" == "persistent" ]]; then
  # detach / hide if already visible
  if [[ "$(tmux display-message -p -F "#{session_name}")" = "$SESSION" ]]; then
    tmux detach-client
  else
    # see .tmux.conf.popup for options set on the popup
    # set via the `after-new-session` hook
    tmux display-popup -d '#{pane_current_path}' -b rounded -w "$WIDTH" -h "$HEIGHT" -s "bg=#020223" -E "tmux attach -t $SESSION || tmux new -s $SESSION"
  fi
else
fi
