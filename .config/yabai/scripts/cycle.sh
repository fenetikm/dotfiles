#!/usr/bin/env zsh

# usage:
# cycle.sh <what> <dir> <options...>
# e.g. cycle.sh fullscreen 1 full 1600,900 1200,900
# ... returns the cycled option, wraps around to first option

CYCLE_INTERVAL=2
CYCLE=$1
DIR=$2

# slice, arg 2 onwards
CYCLE_OPTIONS=("${@:3}")

# we have the path in here for when this is called via karabiner
TIMESTAMP=$(/bin/date +%s)

CYCLE_LOC="$HOME/.config/yabai/scripts/cycle_state_${CYCLE}.sh"
CYCLE_TIMESTAMP_VAR="CYCLE_${CYCLE}_TIMESTAMP"
CYCLE_OPTION_VAR="CYCLE_${CYCLE}_OPTION"

if [[ ! -e "$CYCLE_LOC" ]]; then
  eval "${CYCLE_TIMESTAMP_VAR}=\"$TIMESTAMP\""
  eval "${CYCLE_OPTION_VAR}=\"$3\""
  # store state
  echo "${CYCLE_TIMESTAMP_VAR}=$TIMESTAMP\n${CYCLE_OPTION_VAR}=$3" > "$CYCLE_LOC"

  echo "$3"

  exit 0
else
  source "$CYCLE_LOC"
fi

LAST_TIMESTAMP="${(P)${CYCLE_TIMESTAMP_VAR}}"
OPTION_COUNT="${#CYCLE_OPTIONS}"
CURRENT_OPTION="${(P)${CYCLE_OPTION_VAR}}"
NEXT_OPTION="$CURRENT_OPTION"

if (( ("$LAST_TIMESTAMP" + "$CYCLE_INTERVAL") >= "$TIMESTAMP" )); then
  # find index of current option
  OPTION_INDEX=0
  for (( i = 1; i <= "${#CYCLE_OPTIONS}"; i++ )); do
    if [[ "${CYCLE_OPTIONS[i]}" == "$CURRENT_OPTION" ]]; then
      OPTION_INDEX="$i"
    fi
  done

  NEXT_OPTION_INDEX=$(( "$OPTION_INDEX" + "$DIR" ))
  if [[ "$NEXT_OPTION_INDEX" > "${#CYCLE_OPTIONS}" && "$DIR" == 1 ]]; then
    NEXT_OPTION_INDEX=1
  fi

  if [[ "$NEXT_OPTION_INDEX" == 0 && "$DIR" == -1 ]]; then
    NEXT_OPTION_INDEX="${#CYCLE_OPTIONS}"
  fi

  NEXT_OPTION="${CYCLE_OPTIONS[$NEXT_OPTION_INDEX]}"
else
  # just return the first one if time elapsed
  NEXT_OPTION="$3"
fi

# store state
echo "${CYCLE_TIMESTAMP_VAR}=$TIMESTAMP\n${CYCLE_OPTION_VAR}=$NEXT_OPTION" > "$CYCLE_LOC"

echo "$NEXT_OPTION"
