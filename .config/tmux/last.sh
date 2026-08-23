#!/usr/bin/env zsh

# Remembers the previously focused pane so it can be jumped back to.
#
# wired up in ~/.tmux.conf as:
#   pane-focus-out -> last.sh out #{pane_id}
#   prefix Space   -> last.sh switch
#
# panes are tracked by pane id (%N) rather than session:window.pane -- ids are
# unique, survive renames, and can't be mangled by a name containing a space

# for holding the previous state before switching
STATE_FILE="$HOME/.config/tmux/tmp_state.zsh"

ACTION=$1
if [[ "$ACTION" == "" ]]; then
  ACTION="switch"
fi

LAST_PANE=""
[[ -r "$STATE_FILE" ]] && source "$STATE_FILE"

# session a pane lives in, empty if the pane no longer exists
pane_session() {
  tmux display-message -p -t "$1" '#{session_name}' 2>/dev/null
}

case "$ACTION" in
  out)
    LOST_PANE="$2"
    [[ -z "$LOST_PANE" ]] && exit 0

    LOST_SESSION="$(pane_session "$LOST_PANE")"

    # pane is already gone, e.g. focus-out from a pane that just exited
    [[ -z "$LOST_SESSION" ]] && exit 0

    # coming back out of a popup, the pane behind it is still the real "last"
    [[ "$LOST_SESSION" == *_popup_* ]] && exit 0

    ACTIVE="$(tmux display-message -p '#{pane_id} #{session_name}')"
    ACTIVE_PANE="${ACTIVE%% *}"
    ACTIVE_SESSION="${ACTIVE#* }"

    # still the active pane, so nothing was switched to: the terminal itself
    # lost focus (app switch). recording here would point "last" at where we
    # already are, and the next jump would silently do nothing
    [[ "$LOST_PANE" == "$ACTIVE_PANE" ]] && exit 0

    # opening a popup shouldn't overwrite the pane we want to come back to
    [[ "$ACTIVE_SESSION" == *_popup_* ]] && exit 0

    # write via a temp file, concurrent focus events can truncate otherwise
    print -r -- "LAST_PANE=$LOST_PANE" > "$STATE_FILE.$$"
    mv -f "$STATE_FILE.$$" "$STATE_FILE"
    ;;
  switch)
    if [[ -z "$LAST_PANE" ]]; then
      tmux display-message "no previous pane"
      exit 0
    fi

    if [[ -z "$(pane_session "$LAST_PANE")" ]]; then
      tmux display-message "previous pane is gone"
      exit 0
    fi

    tmux switch-client -t "$LAST_PANE"
    ;;
esac
