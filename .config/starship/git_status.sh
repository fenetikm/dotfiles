#!/bin/zsh

RESET='\033[0m'
GREEN='\033[33;32m'
YELLOW='\033[33;33m'
WHITE='\033[38;2;249;249;255m'
DIRTY_INDICATOR="${YELLOW}* ${RESET}"
UNTRACKED_INDICATOR="${YELLOW}+ ${RESET}"
REMOVED_INDICATOR="${YELLOW}󰅖 ${RESET}"
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

DIRTY=

# Check for untracked files
UNTRACKED=
if $(echo "$INDEX" | grep -E '^\?\? ' &> /dev/null); then
  UNTRACKED=Y
fi

# Check for staged files
if $(echo "$INDEX" | grep '^A[ MDAU] ' &> /dev/null); then
  DIRTY=Y
elif $(echo "$INDEX" | grep '^M[ MD] ' &> /dev/null); then
  DIRTY=Y
elif $(echo "$INDEX" | grep '^UA' &> /dev/null); then
  DIRTY=Y
fi

# Check for modified files
if $(echo "$INDEX" | grep '^[ MARC]M ' &> /dev/null); then
  DIRTY=Y
fi

# Check for renamed files
if $(echo "$INDEX" | grep '^R[ MD] ' &> /dev/null); then
  DIRTY=Y
fi

# Check for deleted files
if $(echo "$INDEX" | grep '^[MARCDU ]D ' &> /dev/null); then
  DIRTY=Y
elif $(echo "$INDEX" | grep '^D[ UM] ' &> /dev/null); then
  DIRTY=Y
fi

# Check for unmerged files
if $(echo "$INDEX" | grep '^U[UDA] ' &> /dev/null); then
  DIRTY=Y
elif $(echo "$INDEX" | grep '^AA ' &> /dev/null); then
  DIRTY=Y
elif $(echo "$INDEX" | grep '^DD ' &> /dev/null); then
  DIRTY=Y
elif $(echo "$INDEX" | grep '^[DA]U ' &> /dev/null); then
  DIRTY=Y
fi

if [[ "${UNTRACKED}" == "Y" ]]; then
  STATUS="${UNTRACKED_INDICATOR}"
fi

# override untracked with dirty
if [[ "${DIRTY}" == "Y" ]]; then
  STATUS="${DIRTY_INDICATOR}"
fi

AHEAD=
if $(echo "$INDEX" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
  AHEAD="${AHEAD_INDICATOR}"
fi

BEHIND=
if $(echo "$INDEX" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
  BEHIND="${BEHIND_INDICATOR}"
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
