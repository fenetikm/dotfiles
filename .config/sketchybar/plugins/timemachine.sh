#!/bin/zsh

source "$HOME/.config/sketchybar/vars.sh"

THRESHOLD=6

LASTBACKUP=`/usr/libexec/PlistBuddy -c "Print Destinations:0:SnapshotDates" /Library/Preferences/com.apple.TimeMachine.plist | tail -n 2 | head -n 1 | awk '{$1=$1};1'`

if [[ "$LASTBACKUP" == "" ]]; then
  sketchybar --set "$NAME" drawing=off

  return
fi

# convert to seconds, get diff in days
LASTBACKUP=`date -j -f "%a %b %d %H:%M:%S %Z %Y" "$LASTBACKUP" +"%s"`
NOW=`date -j +"%s"`
DIFF=`echo $(( ($NOW - $LASTBACKUP)/ (60*60*24) ))`

if (( "$DIFF" <= "$THRESHOLD" )); then
  sketchybar --set "$NAME" drawing=off
fi

COLOUR=$DEFAULT_COLOUR
if (( "$DIFF" > "$THRESHOLD" )); then
  COLOUR=$WARNING_COLOUR
fi
if (( "$DIFF" > 13 )); then
  COLOUR=$ISSUE_COLOUR
fi

DIFF="$DIFF"d

sketchybar --set "$NAME" label="B:${DIFF}" label.color="${COLOUR}" icon.drawing=off padding_right=7
