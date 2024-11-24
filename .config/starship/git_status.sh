#!/bin/zsh

RESET='\033[0m'
GREEN='\033[33;32m'
YELLOW='\033[33;33m'
GRAY='\033[38;2;112;112;130m'
WHITE='\033[38;2;249;249;255m'
DIRTY_INDICATOR="${YELLOW}* ${RESET}"
UNTRACKED_INDICATOR="${GRAY}+ ${RESET}"
AHEAD_INDICATOR="${WHITE}↑ ${RESET}"
BEHIND_INDICATOR="${WHITE}↓ ${RESET}"
DIVERGE_INDICATOR="${WHITE}󰤻 ${RESET}"
OK_INDICATOR="${GREEN}󰸞 ${RESET}"
STATUS=

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  exit 1
fi

INDEX=$(git status --porcelain -b 2> /dev/null)

UNTRACKED=
DIRTY=
AHEAD=
BEHIND=
# only split on new lines, not spaces
IFS=$'\n'
for line in $(echo "${INDEX}")
do
  # untracked
  if [[ "$line" =~ "^\?\?" ]]; then
    UNTRACKED=Y
  fi
  # staged
  if [[ "$line" =~ "^A[ MDAU] " || "$line" =~ "^M[ MD] " || "$line" =~ "^UA" ]]; then
    DIRTY=Y
  fi
  # modified
  if [[ "$line" =~ "^[ MARC]M " ]]; then
    DIRTY=Y
  fi
  # renamed
  if [[ "$line" =~ "^R[ MD] " ]]; then
    DIRTY=Y
  fi
  # deleted
  if [[ "$line" =~ "^[MARCDU ]D " || "$line" =~ "^D[ UM]" ]]; then
    DIRTY=Y
  fi
  # unmerged
  if [[ "$line" =~ "^U[UDA] " || "$line" =~ "^AA " || "$line" =~ "^DD " || "$line" =~ "^[DA]U " ]]; then
    DIRTY=Y
  fi
  # ahead
  if [[ "$line" =~ "^## [^ ]+ .*ahead" ]]; then
    AHEAD="${AHEAD_INDICATOR}"
  fi
  # behind
  if [[ "$line" =~ "^## [^ ]+ .*behind" ]]; then
    BEHIND="${BEHIND_INDICATOR}"
  fi
done

if [[ "${UNTRACKED}" == "Y" ]]; then
  STATUS="${UNTRACKED_INDICATOR}"
fi

# override untracked with dirty
if [[ "${DIRTY}" == "Y" ]]; then
  STATUS="${DIRTY_INDICATOR}"
fi

if [[ "${AHEAD}" != "" && "${BEHIND}" != "" ]]; then
  STATUS="${STATUS}${DIVERGE_INDICATOR}"
else
  STATUS="${STATUS}${AHEAD}${BEHIND}"
fi

if [[ "$STATUS" == "" ]]; then
  echo "${OK_INDICATOR}"
else
  echo "${STATUS}"
fi
