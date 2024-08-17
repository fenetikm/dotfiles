#!/bin/sh

# from https://github.com/Pe8er/dotfiles/blob/master/config.symlink/sketchybar/plugins/messages.sh
# sqlite3 ~/Library/Messages/chat.db "SELECT COUNT(guid) FROM message WHERE NOT(is_read) AND NOT(is_from_me) AND text !=''"
