#!/usr/bin/env zsh

# jump_waiting.sh — switch to the next/prev tmux window with @window_status "waiting"
#
# Searches all sessions whose names match a glob pattern, collects windows
# with @window_status == "waiting", and switches to the one before/after the
# current position (wrapping around).
#
# Usage:
#   jump_waiting.sh [session-pattern] [next|prev]
#
# Arguments:
#   session-pattern   Glob prefix to match session names (default: "*" = all)
#                     e.g. "S:" matches S:work, S:personal, S:anything
#   direction         "next" (default) or "prev"
#
# Examples:
#   jump_waiting.sh                    # next waiting window across all sessions
#   jump_waiting.sh "" prev            # previous waiting window across all sessions
#   jump_waiting.sh "S:"               # next in "S:*" sessions only
#   jump_waiting.sh "S:" prev          # previous in "S:*" sessions only

SESSION_PATTERN=${1:-"*"}
DIRECTION=${2:-"next"}

# creates indexed array
typeset -a waiting_targets   # "session:window_index" strings, in traversal order

NOAGENTS="<no waiting agents>"

# Collect waiting windows
sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

while IFS= read -r session; do
  # Always skip tmux popup sessions
  [[ "$session" == *_popup_* ]] && continue

  # Filter by prefix pattern; "*" or "" means all sessions
  if [[ "$SESSION_PATTERN" != "*" && -n "$SESSION_PATTERN" ]]; then
    [[ "$session" != ${SESSION_PATTERN}* ]] && continue
  fi

  windows=$(tmux list-windows -t "$session" -F "#{window_index}	#{@window_status}" 2>/dev/null)

  while IFS=$'\t' read -r win_idx win_status; do
    [[ "$win_status" == "waiting" ]] || continue
    waiting_targets+=("${session}:${win_idx}")
  done <<< "$windows"

done <<< "$sessions"

if (( ${#waiting_targets[@]} == 0 )); then
  exit 1
fi

# Find next/prev target relative to current position
current_session=$(tmux display-message -p "#{session_name}" 2>/dev/null)
current_window=$(tmux display-message -p "#{window_index}" 2>/dev/null)
current_target="${current_session}:${current_window}"

jump_target=""

if [[ "$DIRECTION" == "prev" ]]; then
  # Iterate forward, tracking the last target seen before current.
  # If current isn't in the list or is the first entry, wrap to the last.
  last_seen=""
  for target in "${waiting_targets[@]}"; do
    [[ "$target" == "$current_target" ]] && break
    last_seen="$target"
  done
  [[ -z "$last_seen" ]] && last_seen="${waiting_targets[-1]}"
  jump_target="$last_seen"
else
  # next: find first target after current; wrap to first if at end or not found
  found_current=0
  for target in "${waiting_targets[@]}"; do
    if (( found_current )); then
      jump_target="$target"
      break
    fi
    [[ "$target" == "$current_target" ]] && found_current=1
  done
  [[ -z "$jump_target" ]] && jump_target="${waiting_targets[1]}"
fi

tmux switch-client -t "$jump_target"
