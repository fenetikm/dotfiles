#!/bin/zsh

source "$HOME/.config/sketchybar/vars.sh"

THRESHOLD=100  # GB free above which the item is hidden

# -P forces one line per filesystem, -k forces plain 1024-byte blocks:
# no column-width guessing, no unit suffix to strip.
AVAIL_KB=$(df -Pk / | awk 'NR==2 {print $4}')

# Finder counts in base-10 GB, so match it.
GB=$(( AVAIL_KB * 1024 / 1000000000 ))

COLOUR=$PASSIVE_COLOUR
(( GB < 20 )) && COLOUR=$WARNING_COLOUR
(( GB < 10 )) && COLOUR=$ISSUE_COLOUR

LABEL="${GB}G"
if (( GB < 1 )); then
  LABEL="$(( AVAIL_KB / 1000 ))M"
  COLOUR=$ISSUE_COLOUR
fi

DRAWING=on
(( GB > THRESHOLD )) && DRAWING=off

# every run writes the full state, so a hidden item can never keep a stale
# label and can always come back once free space drops below the threshold
sketchybar \
  --set "$NAME" \
    drawing="$DRAWING" icon.drawing=on \
    icon="D:" \
    icon.padding_left=0 \
    icon.font="${FONT}:${FONT_WEIGHT}:${FONT_SIZE}" icon.color="${ICON_COLOUR}" \
    label="${LABEL}" label.color="${COLOUR}" \
    label.padding_right=0 label.padding_left=0 \
    padding_right=6 padding_left=6
