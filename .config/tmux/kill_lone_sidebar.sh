#!/usr/bin/env zsh

# close any window where the agent sidebar is the only pane left

# wait a little bit for the pane to actually disappear
sleep 0.1

# go through all windows and the count of panes to check against
WINDOWS=$(tmux list-windows -a -F '#{window_id} #{window_panes}')
for LINE in ${(f)WINDOWS}; do
  # %% - strip from the end
  WINDOW=${LINE%% *}
  # ## - strip from the start
  COUNT=${LINE##* }
  [[ "$COUNT" == 1 ]] || continue

  CMD=$(tmux list-panes -t "$WINDOW" -F '#{pane_current_command}' 2>/dev/null)
  if [[ "$CMD" == tmux-agent-side* ]]; then
    tmux kill-window -t "$WINDOW"
  fi
done
