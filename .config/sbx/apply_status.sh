#!/usr/bin/env zsh

WINDOW_ID=$1

# socat hands us the raw HTTP request on stdin. Skip the request line and
# headers (terminated by a blank CRLF line), then read the body.
while IFS= read -r line; do
  line=${line%$'\r'}
  [[ -z $line ]] && break
done

IFS= read -r msg
msg=${msg%$'\r'}
msg=${msg//#/}

"$HOME/.config/tmux/window_status.sh" "$msg"
