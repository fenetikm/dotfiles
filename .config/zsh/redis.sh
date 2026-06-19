#!/usr/bin/env zsh

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
alias rp='redis_picker'
