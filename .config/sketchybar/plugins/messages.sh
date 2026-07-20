#!/bin/sh

source "$HOME/.config/sketchybar/vars.sh"

# from https://github.com/Pe8er/dotfiles/blob/master/config.symlink/sketchybar/plugins/messages.sh
MESSAGES=$(sqlite3 ~/Library/Messages/chat.db "SELECT COUNT(guid) FROM message WHERE NOT(is_read) AND NOT(is_from_me) AND text !=''")

if (( "$MESSAGES" > 0 )); then
  # sketchybar --set "$NAME" icon="${ICON}" label="${MESSAGES}" drawing=on icon.drawing=on
  sketchybar \
    --set "$NAME" \
      label="${MESSAGES}" \
      drawing=on \
      icon.drawing=on \
      icon="M:" \
      icon.font="${FONT}:${FONT_WEIGHT}:${FONT_SIZE}" icon.color="${ICON_COLOUR}"
else
  sketchybar \
    --set "$NAME" \
      drawing=off icon.drawing=off
fi
