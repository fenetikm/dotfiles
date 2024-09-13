#!/bin/sh

source "$HOME/.config/sketchybar/vars.sh"

# from https://github.com/Pe8er/dotfiles/blob/master/config.symlink/sketchybar/plugins/messages.sh
MESSAGES=$(sqlite3 ~/Library/Messages/chat.db "SELECT COUNT(guid) FROM message WHERE NOT(is_read) AND NOT(is_from_me) AND text !=''")
ICON="󰍥 "

if (( "$MESSAGES" > 0 )); then
  sketchybar --set "$NAME" icon="${ICON}" label="${MESSAGES}" drawing=on icon.drawing=on
else
  sketchybar --set "$NAME" drawing=off icon.drawing=off
fi
