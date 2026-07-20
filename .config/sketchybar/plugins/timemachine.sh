#!/bin/zsh

source "$HOME/.config/sketchybar/vars.sh"

THRESHOLD=6

PLIST_OUTPUT=$(/usr/libexec/PlistBuddy -c "Print Destinations:0:SnapshotDates" /Library/Preferences/com.apple.TimeMachine.plist 2>&1)

if [[ "$PLIST_OUTPUT" == *'Print: Entry, "Destinations:0:SnapshotDates", Does Not Exist'* ]]; then
  LASTBACKUP="error"
else
  LASTBACKUP=$(printf '%s\n' "$PLIST_OUTPUT" | tail -n 2 | head -n 1 | awk '{$1=$1};1')
fi

# LASTBACKUP=`/usr/libexec/PlistBuddy -c "Print Destinations:0:SnapshotDates" /Library/Preferences/com.apple.TimeMachine.plist | tail -n 2 | head -n 1 | awk '{$1=$1};1'`

if [[ "$LASTBACKUP" == "" ]]; then
  sketchybar --set "$NAME" drawing=off

  return
fi

if [[ "$LASTBACKUP" == "error" ]]; then
  DIFF="!!"
  COLOUR=$ISSUE_COLOUR
else
  # convert to seconds, get diff in days
  LASTBACKUP=`date -j -f "%a %b %d %H:%M:%S %Z %Y" "$LASTBACKUP" +"%s"`
  NOW=`date -j +"%s"`
  DIFF=`echo $(( ($NOW - $LASTBACKUP)/ (60*60*24) ))`

  if (( "$DIFF" <= "$THRESHOLD" )); then
    sketchybar --set "$NAME" drawing=off
  fi

  COLOUR=$PASSIVE_COLOUR
  if (( "$DIFF" > "$THRESHOLD" )); then
    COLOUR=$WARNING_COLOUR
  fi
  if (( "$DIFF" > 13 )); then
    COLOUR=$ISSUE_COLOUR
  fi

  DIFF="$DIFF"d
fi


sketchybar \
  --set "$NAME" \
    icon.drawing=on \
    icon="B:" \
    icon.font="${FONT}:${FONT_WEIGHT}:${FONT_SIZE}" icon.color="${ICON_COLOUR}" \
    label="${DIFF}" \
    label.color="${COLOUR}" \
    padding_right=6
