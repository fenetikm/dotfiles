#!/usr/bin/env zsh
# Called with the event name as $1
# Claude Code also passes JSON context via stdin

EVENT="$1"

# Only act if we're inside tmux
[[ -z "$TMUX" ]] && exit 0

case "$EVENT" in
  PreToolUse)
    tmux rename-window '⚙️ working'
    ;;
  Notification)
    tmux rename-window '💬 waiting'
    # Optional: ring the terminal bell so your OS notifies you
    printf '\a'
    ;;
  Stop)
    tmux rename-window '✅ done'
    # Optional: reset to a plain name after 10s
    (sleep 10 && tmux rename-window 'claude') &
    ;;
esac
