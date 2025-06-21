#!/usr/bin/env zsh

# either focus based or use a stack somehow

ACTION=$1
if [[ "$ACTION" == "" ]]; then
  ACTION="store"
fi

LAST_LOC=`tmux showenv -g TMUX_CURRENT_LOC | sed -E 's/^(.*=)(.*)$/\\2/'`
CURRENT_LOC=$(tmux display-message -p '#{session_name}:#{window_name}:#{pane_index}')

# hs -c "hs.alert.show('$LAST_LOC')"
# hs -c "hs.alert.show('$CURRENT_LOC')"

case "$ACTION" in
  out)
    tmux setenv -g TMUX_CURRENT_LOC $(tmux display-message -p '#{session_name}:#{window_name}:#{pane_index}')
    ;;
  in)
    # tmux setenv -g TMUX_CURRENT_LOC $(tmux display-message -p '#{session_name}:#{window_name}:#{pane_index}')
    ;;
  switch)
    # tmux switch-client -t "$LAST_LOC"
    ;;
esac
