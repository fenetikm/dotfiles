#!/usr/bin/env zsh

# builds the session/window list consumed by tree_picker.sh
# each line is: <display text>\t<session id>\t<window id>
# only the display text is shown by fzf, the ids are the switch target

# window title length before truncation
WIN_CAP=30
# spaces between columns
GAP=3
# colour of the tmux location
ESC_LOC=$'\e[38;2;87;87;94m'
ESC_RESET=$'\e[0m'

typeset -a SESH_COL WIN_NAMES LOCS SESH_IDS WIN_IDS

SESH_W=0
WIN_W=0
LAST_SESH=

# ids rather than names as the target, they never contain spaces
# window_name last, it is the only field that could hold a tab
# $'..' so the \t become real tabs before tmux sees the format
WINDOWS=$(tmux list-windows -a -F $'#{session_name}\t#{session_id}\t#{window_id}\t#{window_index}\t#{window_name}')

if [[ -z "$WINDOWS" ]]; then
  exit 0
fi

# print -r rather than echo, echo would expand a backslash in a window name
print -r -- "$WINDOWS" | while IFS=$'\t' read -r SESH SESH_ID WIN_ID WIN_IDX WIN_NAME; do
  # ignore _popup_
  # filtered here so hidden rows can't widen the columns
  if [[ "$SESH" == *_popup_* ]]; then
    continue
  fi

  if (( ${#WIN_NAME} > WIN_CAP )); then
    WIN_NAME="${WIN_NAME[1,WIN_CAP - 1]}…"
  fi

  # only the first window of a session is labelled
  if [[ "$SESH" == "$LAST_SESH" ]]; then
    SESH_COL+=("")
  else
    SESH_COL+=("[$SESH]")
    LAST_SESH="$SESH"
    (( ${#SESH} + 2 > SESH_W )) && SESH_W=$(( ${#SESH} + 2 ))
  fi

  (( ${#WIN_NAME} > WIN_W )) && WIN_W=${#WIN_NAME}

  WIN_NAMES+=("$WIN_NAME")
  LOCS+=("$SESH:$WIN_IDX")
  SESH_IDS+=("$SESH_ID")
  WIN_IDS+=("$WIN_ID")
done

if (( ${#WIN_IDS} == 0 )); then
  exit 0
fi

(( SESH_W += GAP ))
(( WIN_W += GAP ))

# the colour escapes go after the padded fields, printf pads by character
# count and would otherwise measure the escape bytes as visible width
for i in {1..${#WIN_IDS}}; do
  printf '%-*s%-*s%s(%s)%s\t%s\t%s\n' \
    "$SESH_W" "$SESH_COL[i]" \
    "$WIN_W" "$WIN_NAMES[i]" \
    "$ESC_LOC" "$LOCS[i]" "$ESC_RESET" \
    "$SESH_IDS[i]" "$WIN_IDS[i]"
done
