#!/usr/bin/env zsh

# usage:
# - preview.sh <absolute-path>
# view a file in a viewer chosen by its extension
# called from the `prefix + R` binding, via popup.sh

FILE="$1"

# no FILE means the pane wasn't nvim, or the buffer is unnamed
# pause so the message is readable before the popup closes
if [[ ! -f "$FILE" ]]; then
  print "preview: no FILE to preview"
  read -k1
  exit 1
fi

# `:l` lowercases, so .MD matches too
case "${FILE:l}" in
  *.md|*.markdown)
    glow -t "$FILE"
    ;;
  # paging is required, a popup closes the moment its command exits
  *)               bat --paging=always "$FILE" ;;
esac
