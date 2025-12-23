#!/usr/bin/env zsh

# $YABAI_PROCESS_ID is passed in when application_visible
# otherwise YABAI_WINDOW_ID
PID="$YABAI_PROCESS_ID"
WID="$YABAI_WINDOW_ID"

source "$HOME/.config/yabai/scripts/tools.sh"

yd "application_visible.sh"

source "$HOME/.config/yabai/scripts/hide_special.sh"

source "$HOME/.config/yabai/scripts/balance.sh"
