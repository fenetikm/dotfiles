#!/usr/bin/env zsh

FORCE=$1

CACHE_LOC="$HOME/.config/tmux/tree_cache.txt"
CACHE_BUILD="$HOME/.config/tmux/tree.sh"

# only build cache if it doesn't exist or older than an hour
if [[ ! -f "$CACHE_LOC" ]] || (( "FORCE" == "1" )); then
  "$CACHE_BUILD" > "$CACHE_LOC"
elif [[ $(find "$CACHE_LOC" -mtime +1h -print) ]]; then
  "$CACHE_BUILD" > "$CACHE_LOC"
fi
