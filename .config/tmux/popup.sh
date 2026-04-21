#!/usr/bin/env zsh

# usage:
# - popup.sh <name|script> <arg1> <arg2>

# "smart" sizing
PERC=85
MIN_WIDTH=140
MIN_HEIGHT=50
CURRENT_WIDTH=$(tmux display -p "#{client_width}")
CURRENT_HEIGHT=$(tmux display -p "#{client_height}")
MARGIN=6
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

# "persist" for sessions that are created once, then attach/detach from
if [[ "$1" == "persist" ]]; then
  SESSION="$2"_popup_
  INIT_CMD="$3"
  if [[ "$(tmux display-message -p -F "#{session_name}")" = "$SESSION" ]]; then
    tmux detach-client
  elif [[ "$(tmux display-message -p -F "#{session_name}")" = *_popup_* ]]; then
    tmux detach-client
    # is this still needed?! eh, this still doesn't work
    sleep 0.3
    # note: in this context, CURRENT_WIDTH/HEIGHT will be of the popup that we are replacing
    tmux display-popup -d '#{pane_current_path}' -b rounded -w "$CURRENT_WIDTH" -h "$CURRENT_HEIGHT" -s "bg=#020223" -E "tmux attach -t $SESSION || tmux new -s $SESSION $INIT_CMD"
  else
    # see above re options given to popup
    tmux display-popup -d '#{pane_current_path}' -b rounded -w "$WIDTH" -h "$HEIGHT" -s "bg=#020223" -E "tmux attach -t $SESSION || tmux new -s $SESSION $INIT_CMD"
  fi
else
  tmux display-popup -d rounded -w "$WIDTH" -h "$HEIGHT" -T "$2" -s "bg=#020223" -E "$1 $3"
fi
