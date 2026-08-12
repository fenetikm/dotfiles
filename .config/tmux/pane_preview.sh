#!/usr/bin/env zsh

# pane_preview.sh — print a pane's most recent output, for an fzf --preview
#
#   pane_preview.sh <target>
#
# the target is anything capture-pane accepts, a pane id from the agent
# picker or a window id from the tree picker, in which case the window's
# active pane is captured
#
# fzf renders a preview from the top, but the interesting part of a pane is
# the newest output at the bottom, so the capture is tailed to the height of
# the preview window
# -e keeps the pane's colours, fzf renders escapes in the preview

# fzf exports the preview size, the fallback is only for running by hand
LINES_WANTED=${FZF_PREVIEW_LINES:-40}

typeset -a lines

# the command substitution drops trailing newlines, which is what trims the
# blank rows under a pane whose output doesn't reach the bottom
lines=("${(@f)$(tmux capture-pane -p -e -t "$1" 2>/dev/null)}")

# each captured line re-states its own colours, so cutting off the top
# doesn't strand the remaining lines mid-escape
(( ${#lines} > LINES_WANTED )) && lines=("${(@)lines[-LINES_WANTED,-1]}")

print -rl -- "${lines[@]}"
