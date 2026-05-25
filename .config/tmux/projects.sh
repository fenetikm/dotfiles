#!/usr/bin/env zsh

# usage: /projects.sh
#
# shows a fzf picker of existing projects to select from or select "<new>" to create a new one
#
# todo:
# - different actions via diff keys?
# - when creating, pick a template?

PROJECT_LEN=28
TRIM_LEN=24

ESC_DARK_GREY="\e[38;2;87;87;94m"
ESC_RESET="\e[0m"
ELLIPSIS=…

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

# join to newline-separated string
PROJECTS=${(j:\n:)PROJECT_DIRS}

LIST=
# note: (f) splits on newlines, turn into an array
for P in "${(f)PROJECTS}"; do
  PNAME=$(echo "$P" | sed 's/.*\///')
  PNAME_LEN="${#PNAME}"
  if (( "$PNAME_LEN" > "$PROJECT_LEN" )); then
    PNAME=`echo "$PNAME" | cut -c -"$TRIM_LEN"`
    PNAME+=…
  fi
  PNAME=$(pad_string "$PROJECT_LEN" "$PNAME")
  LOC="$ESC_DARL_GREY($P)$ESC_RESET"
  LIST="$LIST${PNAME}${LOC}\n"
done

# add new project item
LIST="$LIST<new project>"

PROJECT=$(echo "$LIST" |
  fzf \
    --color=bg:#020223,bg+:#020223 \
    --no-scrollbar \
    --no-info \
    --reverse \
    --ansi \
    --no-preview \
    --no-multi)

if [[ "$PROJECT" == "<new project>" ]]; then
  NEWDIR=~/Documents/Work/internal/projects/
  read "NAME?Project name: "
  if [[ "$NAME" != "" ]]; then
    PDIR="$NEWDIR$NAME"
    if [[ -d "$PDIR" ]]; then
      echo "Error: project with that name exists."
      return 1
    else
      mkdir -p "$PDIR"
      "$HOME"/.config/tmux/sesh.sh auto "$NAME" "$PDIR"
    fi
  fi
elif [[ "$PROJECT" != "" ]]; then
  PDIR=$(echo "$PROJECT" | sed 's/.* (//')
  PDIR=$(echo "$PDIR" | sed 's/)$//')
  NAME=$(echo "$PROJECT" | sed 's/ .*$//')
  "$HOME"/.config/tmux/sesh.sh auto "$NAME" "$PDIR"
fi
