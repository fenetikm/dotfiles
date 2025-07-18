#!/usr/bin/env zsh

FORCE=$1

CACHE_LOC="$HOME/.config/tmux/tmp_tree_cache.txt"
CACHE_BUILD="$HOME/.config/tmux/tree.sh"

# only build cache if it doesn't exist or older than an hour
# note: "FORCE" has no $, doesn't work inside arithmetic context
if [[ ! -f "$CACHE_LOC" ]] || (( "FORCE" == "1" )); then
  "$CACHE_BUILD" > "$CACHE_LOC"
elif [[ $(find "$CACHE_LOC" -mtime +1h -print) ]]; then
  "$CACHE_BUILD" > "$CACHE_LOC"
fi
