#!/usr/bin/env zsh

# usage: /projects.sh
#
# shows a fzf picker of existing projects to select from or select "<new>" to create a new one
#
# each line is: <display text>\t<project name>\t<project path>
# only the display text is shown by fzf, the hidden fields carry the real
# untruncated name and path, so spaces and brackets in either are harmless
#
# todo:
# - different actions via diff keys?
# - when creating, pick a template?

# project name length before truncation
NAME_CAP=28
# spaces between the name and location columns
GAP=2

ESC_DARK_GREY=$'\e[38;2;87;87;94m'
ESC_RESET=$'\e[0m'
ELLIPSIS=…
NEW_PROJECT='<new project>'
NEWDIR=~/Documents/Work/internal/projects/

# source local config first so EXTRA_PROJECTS can be set there
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# build dir list as an array; (N) glob flag silently skips missing paths
typeset -a PROJECT_DIRS
PROJECT_DIRS=(
  ~/Documents/Work/internal/projects/*(N)
  ~/Documents/Work/internal/projects/majyk/repos/*(N)
  ~/Documents/Work/internal/learning/*(N)
  ~/Documents/Work/internal/learning/boot/*(N)
  ~/Documents/Work/internal/learning/fem/*(N)
)
[[ -d ~falcon ]] && PROJECT_DIRS+=(~falcon)

for _d in "${EXTRA_PROJECTS[@]}"; do
  [[ -d "$_d" ]] && PROJECT_DIRS+=("$_d")
done

# measure the name column before rendering, so it fits what is actually shown
typeset -a NAMES LABELS
NAME_W=0

for P in "${PROJECT_DIRS[@]}"; do
  # :t is the trailing component, no need to shell out to sed
  PNAME="${P:t}"
  LABEL="$PNAME"

  if (( ${#LABEL} > NAME_CAP )); then
    LABEL="${LABEL[1,NAME_CAP - 1]}$ELLIPSIS"
  fi

  (( ${#LABEL} > NAME_W )) && NAME_W=${#LABEL}

  NAMES+=("$PNAME")
  LABELS+=("$LABEL")
done

(( NAME_W += GAP ))

# note: LINES is a special zsh parameter (terminal height), hence ROWS
typeset -a ROWS

for i in {1..${#PROJECT_DIRS}}; do
  ROWS+=("$(pad_string "$NAME_W" "$LABELS[i]" "$ESC_DARK_GREY($PROJECT_DIRS[i])$ESC_RESET")"$'\t'"$NAMES[i]"$'\t'"$PROJECT_DIRS[i]")
done

# add new project item, the only line without hidden fields
ROWS+=("$NEW_PROJECT")

SELECTED=$(print -rl -- "${ROWS[@]}" |
  fzf \
    --color=bg:#020223,bg+:#020223 \
    --no-scrollbar \
    --no-info \
    --reverse \
    --ansi \
    --no-preview \
    --no-multi \
    --delimiter=$'\t' \
    --with-nth='{1}')

# nothing picked, esc'd out
if [[ -z "$SELECTED" ]]; then
  exit 0
fi

FIELDS=("${(@ps:\t:)SELECTED}")
NAME="$FIELDS[2]"
PDIR="$FIELDS[3]"

if [[ "$FIELDS[1]" == "$NEW_PROJECT" ]]; then
  read "NAME?Project name: "

  if [[ -z "$NAME" ]]; then
    exit 0
  fi

  PDIR="$NEWDIR$NAME"

  if [[ -d "$PDIR" ]]; then
    print "Error: project with that name exists."
    exit 1
  fi

  mkdir -p "$PDIR"
fi

"$HOME"/.config/tmux/sesh.sh auto "$NAME" "$PDIR"
