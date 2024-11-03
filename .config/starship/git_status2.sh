#!/bin/zsh

# todo: replace all the grep stuff with zsh script

RESET='\033[0m'
GREEN='\033[33;32m'
YELLOW='\033[33;33m'
ORANGE='\033[33;33m'
WHITE='\033[38;2;249;249;255m'
DIRTY_INDICATOR="${YELLOW}* ${RESET}"
UNTRACKED_INDICATOR="${ORANGE}+ ${RESET}"
AHEAD_INDICATOR="${WHITE}󰶣 ${RESET}"
BEHIND_INDICATOR="${WHITE}󰶡 ${RESET}"
DIVERGE_INDICATOR="${WHITE}󰤻 ${RESET}"
OK_INDICATOR="${GREEN}󰸞 ${RESET}"
STATUS=

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  exit 1
fi

# The below is mostly from: https://github.com/starship/starship/discussions/1252#discussioncomment-58920
INDEX=$(git status --porcelain -b 2> /dev/null)
echo $INDEX

UNTRACKED=
DIRTY=
for line in $(echo "${INDEX}")
do
  if [[ "$line" =~ "^\?\?" ]]; then
    UNTRACKED=Y
  fi
  if [[ "$line" =~ "^A[ MDAU]" ]]; then
    DIRTY=Y
  fi
  # modified
  if [[ "$line" =~ "^[ MARC]M" ]]; then
    echo 'hey'
    DIRTY=Y
  fi
done
echo $DIRTY
