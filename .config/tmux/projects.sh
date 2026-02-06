#!/usr/bin/env zsh

PROJECT_LEN=28
TRIM_LEN=24

ESC_DARK_GREY="\e[38;2;87;87;94m"
ESC_RESET="\e[0m"
ELLIPSIS=…

# get all the dirs
PROJECTS=$(ls -d -1 ~/Documents/Work/internal/projects/*)
M=$(ls -d -1 ~/Documents/Work/internal/projects/majyk/repos/*)
LEARNING1=$(ls -d -1 ~/Documents/Work/internal/learning/*)
LEARNING2=$(ls -d -1 ~/Documents/Work/internal/learning/boot/*)
LEARNING3=$(ls -d -1 ~/Documents/Work/internal/learning/fem/*)
PROJECTS="$PROJECTS"$'\n'"$M"$'\n'"$LEARNING1"$'\n'"$LEARNING2"$'\n'"$LEARNING3"


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
LIST="$LIST<new>"

PROJECT=$(echo "$LIST" |
  fzf --color=bg:#020223,bg+:#020223 --no-scrollbar --no-info --reverse --ansi --no-preview --no-multi)

if [[ "$PROJECT" == "<new>" ]]; then
  NEWDIR=~/Documents/Work/internal/projects
  read "NAME?$NEWDIR"
  if [[ "$NAME" != "" ]]; then
    "$HOME"/.config/tmux/sesh.sh auto "$NAME" "$NEWDIR"
  fi
elif [[ "$PROJECT" != "" ]]; then
  PDIR=$(echo "$PROJECT" | sed 's/.* (//')
  PDIR=$(echo "$PDIR" | sed 's/)$//')
  NAME=$(echo "$PROJECT" | sed 's/ .*$//')
  "$HOME"/.config/tmux/sesh.sh auto "$NAME" "$PDIR"
fi
