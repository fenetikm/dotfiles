#!/usr/bin/env zsh

hugo-migrate-images() {
  local CONV="$1"
  if [[ "$CONV" == "" ]]; then
    CONV=$(find content \( -path '**/posts/**' -or -path '**/til/**' -or -path '**/devlog/**' \) -not -name 'index.md' -name '*.md' | fzf --no-multi --preview 'bat --color=always --line-range :500 {}' | gsed -E 's/\.md//g')
  fi
  # it will be empty if it was cancelled
  if [[ "$CONV" != "" ]]; then
    mkdir "$CONV"
    cp "$CONV.md" "$CONV.bak"
    mv "$CONV.md" "$CONV/index.md"
    mkdir "$CONV/images"
    echo "Migrated $CONV to support images."
  fi
}

redis_keys() {
  local SEARCH="dev_*"
  if [[ ! -z "$1" ]]; then
    SEARCH=$1
  fi
  redis-cli --raw KEYS "$SEARCH"
}

# todo: fix unserialize when not needed e.g. dev_ua_...
redis_picker() {
  local SEARCH="dev_*"
  if [[ ! -z "$1" ]]; then
    SEARCH=$1
  fi
  redis_keys "$SEARCH" |
      fzf \
        --with-shell 'zsh -c' \
        --preview 'echo {} | sed "s/^/GET /" | redis-cli --json | php -r "print_r(unserialize(json_decode(file_get_contents(\"php://stdin\"))));"' \
        --bind 'ctrl-d:execute-silent(echo {} | sed "s/^/DEL /" | redis-cli)' \
        --bind 'ctrl-d:+reload(redis_keys "'"$SEARCH"'")' \
        --bind 'enter:execute(echo {} | sed "s/^/GET /" | redis-cli --json | php -r "print_r(unserialize(json_decode(file_get_contents(\"php://stdin\"))));" | nvim -c "set nofoldenable")'
}

file_paste() {
  SOURCE_FILE=$(pbpaste)
  DEST_FILE="$1"

  cp "$SOURCE_FILE" "$DEST_FILE"
}
