#!/usr/bin/env zsh

# todo:
# - MAX_WIN is not calculated, just hardcoded

# maximum window title length
MAX_WIN=16
OUTPUT=
ESC_LOC="\e[38;2;87;87;94m"
ESC_RESET="\e[0m"

pad() {
  local STR=$2
  local STR_LEN="${#STR}"
  local WIDTH=$1
  local PAD=$((WIDTH - STR_LEN))
  local PAD_STR=
  for i in {1.."$PAD"}; do
    PAD_STR="${PAD_STR} "
  done

  echo "$2 $PAD_STR $3"
}

SESSIONS=$(tmux list-sessions -F '#{session_name}')
SESH_LINES=(${(f)SESSIONS})

# get longest named session
SESH_LEN=0
for SESH in "${SESH_LINES[@]}"; do
  if [[ "${#SESH}" > "$SESH_LEN" ]]; then
    SESH_LEN="${#SESH}"
  fi
done

for SESH in "${SESH_LINES[@]}"; do
  WINDOWS=$(tmux list-windows -t "$SESH" -F '#{window_name} (#{session_name}:#{window_name})')
  WINDOWS_LINES=(${(f)WINDOWS})
  FIRST=1
  for WIN_LINE in "${WINDOWS_LINES[@]}"; do
    LOC=$(echo "$WIN_LINE" | sed -E 's/([^ ]*)([ ]+)\((.*)\)/\3/')
    WIN_NAME=$(echo "$WIN_LINE" | sed -E 's/([^ ]*)([ ]+)\((.*)\)/\1/')
    WIN_PAD=$(pad "$MAX_WIN" "$WIN_NAME" "$ESC_LOC($LOC)$ESC_RESET")
    SESH_PAD=$(pad $(("$SESH_LEN" + 3)))
    if [[ "$FIRST" == 1 ]]; then
      FIRST=0
      SESH_PAD=$(pad $(("$SESH_LEN" + 3)) "[$SESH]")
    fi
    OUTPUT="$OUTPUT$SESH_PAD$WIN_PAD\n"
  done
done

echo $OUTPUT
