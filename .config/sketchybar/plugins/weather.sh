#!/bin/bash

# https://api.weather.bom.gov.au/v1/locations/r1f8sw/observations for mount lofty!
# also http://www.bom.gov.au/fwo/IDS60801/IDS60801.95678.json for the last many
# only refresh weather file if older than an hour
if [[ $(find "plugins/weather.json" -mtime +1h -print) ]]; then
  curl -L -s -o plugins/weather.json https://api.weather.bom.gov.au/v1/locations/r1f8sw/observations
fi

TEMP=$(cat plugins/weather.json | jq '.data.temp')
RAIN=$(cat plugins/weather.json | jq '.data.rain_since_9am')
WIND=$(cat plugins/weather.json | jq '.data.wind.speed_kilometre')
ICON=
COLOUR=0xffCFC1B2
if (( "$RAIN" > 0)); then
  ICON=
  COLOUR=0xff99A4BC
fi
if (( "$RAIN" > 10)); then
  ICON=
  COLOUR=0xff99A4BC
fi
TIME=`date '+%H'`
if (( "$TIME" > 19 || "$TIME < 5" )); then
  ICON=
  COLOUR=0xffb4b4b9
fi

sketchybar --set "$NAME" label="${TEMP}°" icon="$ICON" icon.color="${COLOUR}" icon.padding_right=0 label.padding_left=0
