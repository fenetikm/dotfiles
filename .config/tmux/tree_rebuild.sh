#!/usr/bin/env zsh

# rebuild the tree for picking
# usage: tree_rebuild <force_rebuild>
# - if <force_rebuild> isn't set, will only rebuild after the TTL

FORCE=$1
# minutes til rebuild
TTL=5

CACHE_LOC="$HOME/.config/tmux/tmp_tree_cache.txt"
CACHE_BUILD="$HOME/.config/tmux/tree.sh"

# only build cache if it doesn't exist or older than TTL
# note: "FORCE" has no $, doesn't work inside arithmetic context
if [[ ! -f "$CACHE_LOC" ]] || (( "FORCE" == "1" )); then
  "$CACHE_BUILD" > "$CACHE_LOC"
elif [[ $(find "$CACHE_LOC" -mmin +"$TTL"m 2>/dev/null) ]]; then
  "$CACHE_BUILD" > "$CACHE_LOC"
fi
