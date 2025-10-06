#!/usr/bin/env zsh

# get the current directory `0`, `A` (absolute), `h` just the head for the dir
DIR=${0:A:h}

source "$DIR"/hugo.sh
source "$DIR"/redis.sh
source "$DIR"/tmux.sh
source "$DIR"/fzf.sh

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

# assumes running from ~z dir
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

