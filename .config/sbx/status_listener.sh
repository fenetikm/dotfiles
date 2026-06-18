#!/usr/bin/env zsh

TM_PORT=$1
TM_WINDOW_ID=$2
exec socat TCP-LISTEN:"$TM_PORT",reuseaddr,fork \
  EXEC:"$HOME/.config/sbx/apply_status.sh $TM_WINDOW_ID"
