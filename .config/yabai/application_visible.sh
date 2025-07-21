#!/usr/bin/env zsh

# $YABAI_PROCESS_ID is passed in when application_visible
# otherwise YABAI_WINDOW_ID
PID="$YABAI_PROCESS_ID"
WID="$YABAI_WINDOW_ID"

source "$HOME/.config/yabai/tools.sh"

yd "application_visible.sh"

# hide apps that are floated but then should always hide on blur
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

source "$HOME/.config/yabai/balance.sh"
