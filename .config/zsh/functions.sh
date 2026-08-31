#!/usr/bin/env zsh

# get the current directory `0`, `A` (absolute), `h` just the head for the dir
DIR=${0:A:h}

source "$DIR"/hugo.sh
source "$DIR"/redis.sh
source "$DIR"/tmux.sh
source "$DIR"/fzf.sh
source "$DIR"/sbx.sh
source "$DIR"/agents.sh
source "$DIR"/gh.sh

print_red() {
  print -P "%F{red}$*%f"
}

print_green() {
  print -P "%F{green}$*%f"
}

# pad_string <width> <string> [suffix]
# pads <string> with spaces to exactly <width> characters, then appends [suffix]
# a string already at or over <width> is returned untouched, never truncated
pad_string() {
  local WIDTH=$1
  local STR=$2
  local SUFFIX=$3

  printf '%-*s%s\n' "$WIDTH" "$STR" "$SUFFIX"
}

file_paste() {
  SOURCE_FILE=$(pbpaste)
  DEST_FILE="$1"

  cp "$SOURCE_FILE" "$DEST_FILE"
}

# add in a secret for dot file mgmt
secret_add() {
  local FILE=$(realpath $1)
  local FILEPATH="${FILE/"$HOME"\//}"
  echo "$FILEPATH filter=crypt diff=crypt merge=crypt" >> ~/.gitattributes
  yadm add "$1"
  yadm add ~/.gitattributes
  yadm commit -m "Added encrypted file"
}

diary() {
  local TODAY=$(date +"%Y-%m-%d")
  local FILE_PATH="$TODAY".md
  local ENTRY_DIR=$(echo ~z)
  local FULL_PATH="$ENTRY_DIR/80-Diary/$FILE_PATH"

  if [[ ! -f "$FULL_PATH" ]]; then
    echo "# $TODAY\n" > "$FULL_PATH"
  fi

  # Put cursor on the last line
  nvim -c "lua vim.api.nvim_win_set_cursor(0, {#vim.api.nvim_buf_get_lines(0, 0, -1, false),1})" "$FULL_PATH"
}

lpass_export() {
  LPASS=`lpass status`
  if [[ "$LPASS" != *"Logged in"* ]]; then
    lpass login michael@theoryz.com.au
  fi
  KEYS=`lpass show --notes keys`
  while read -r key; do
      export "$key"
  done <<< "$KEYS"
}

# yazi alias
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# this fn handles the socket changing on waking from sleep
get_kitty_socket() {
  SOCKET=(/tmp/kitty-*(N[1]))
  echo "unix:$SOCKET"
}

# function to toggle fg/bg on control z
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
