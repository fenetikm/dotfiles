#!/bin/bash

source "$HOME/.config/sketchybar/colours.sh"

LASTBACKUP=`/usr/libexec/PlistBuddy -c "Print Destinations:0:SnapshotDates" /Library/Preferences/com.apple.TimeMachine.plist | tail -n 2 | head -n 1 | awk '{$1=$1};1'`

# convert to seconds, get diff
LASTBACKUP=`date -j -f "%a %b %d %H:%M:%S %Z %Y" "$LASTBACKUP" +"%s"`
NOW=`date -j +"%s"`
DIFF=`echo $(( ($NOW - $LASTBACKUP)/ (60*60*24) ))`

COLOUR=$DEFAULT_COLOUR
if (( $DIFF > 6 )); then
  COLOUR=$WARNING_COLOUR
fi
if (( $DIFF > 13 )); then
  COLOUR=$ISSUE_COLOUR
fi

sketchybar --set "$NAME" label="TM:${DIFF}d" label.color="${COLOUR}" icon.drawing=off
