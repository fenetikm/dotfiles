#!/usr/bin/env zsh

# usage:
# - popup.sh <name|script> <arg1> <arg2>

# Percentage of the screen to take up
PERC=85
# ... but then take up more than that if less than these minimum values
MIN_WIDTH=140
MIN_HEIGHT=50

# Get full window metrics from kitty, most reliable
read -r CURRENT_WIDTH CURRENT_HEIGHT < <(
  kitten @ ls 2>/dev/null | jq -r '
    .[] | select(.is_focused) | .tabs[] | select(.is_focused)
    | .windows[] | select(.is_focused) | "\(.columns) \(.lines)"
  '
)

# Tmux fallback
if [[ -z "$CURRENT_WIDTH" || -z "$CURRENT_HEIGHT" ]]; then
  CURRENT_WIDTH=$(tmux display -p "#{client_width}")
  CURRENT_HEIGHT=$(tmux display -p "#{client_height}")
fi

# Always have at least this margin
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
    # popup currently displaying, detach and reshow
    tmux detach-client
    tmux display-popup -d '#{pane_current_path}' -b rounded -w "$WIDTH" -h "$HEIGHT" -s "bg=#020223" -E "tmux attach -t $SESSION || tmux new -s $SESSION $INIT_CMD"
  else
    # see above re options given to popup
    tmux display-popup -d '#{pane_current_path}' -b rounded -w "$WIDTH" -h "$HEIGHT" -s "bg=#020223" -E "tmux attach -t $SESSION || tmux new -s $SESSION $INIT_CMD"
  fi
else
  tmux display-popup -d rounded -w "$WIDTH" -h "$HEIGHT" -T "$2" -s "bg=#020223" -E "$1 $3"
fi
