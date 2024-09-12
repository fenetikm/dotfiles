#!/bin/sh

source "$HOME/.config/sketchybar/vars.sh"

# from https://github.com/Pe8er/dotfiles/blob/master/config.symlink/sketchybar/plugins/messages.sh
MESSAGES=$(sqlite3 ~/Library/Messages/chat.db "SELECT COUNT(guid) FROM message WHERE NOT(is_read) AND NOT(is_from_me) AND text !=''")

if (( "$MESSAGES" > 0 )); then
  sketchybar --set "$NAME" label="M:${MESSAGES}" drawing=on icon.drawing=off
else
  sketchybar --set "$NAME" drawing=off icon.drawing=off
fi
