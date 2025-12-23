#!/usr/bin/env zsh

source "$HOME/.config/yabai/scripts/tools.sh"

yd "hide special"

# $YABAI_PROCESS_ID is passed in when application_visible
# otherwise YABAI_WINDOW_ID
PID="$YABAI_PROCESS_ID"
WID="$YABAI_WINDOW_ID"

yd "PID: $PID"
yd "WID: $WID"

# apps that should hide when losing focus
APPS=$(
cat <<EOF
Transmission
EOF
)
SPACE_ID=$(yabai -m query --spaces --space | jq -r '.index')

for APP in "${APPS[@]}"
do
  WINDOW_ID=$(yabai -m query --windows --space "$SPACE_ID" | jq -r '.[] | select(.title == "'"$APP"'") | .id')
  # don't hide if made visible
  if [[ "$WINDOW_ID" != "" && "$WINDOW_ID" != "$WID" ]]; then
    # todo: use smart minimise instead?
    yabai -m window "$WINDOW_ID" --minimize
  fi
done
