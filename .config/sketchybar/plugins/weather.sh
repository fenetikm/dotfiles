#!/bin/bash

source "$HOME/.config/sketchybar/vars.sh"

# https://api.weather.bom.gov.au/v1/locations/r1f8sw/observations for mount lofty!
# also http://www.bom.gov.au/fwo/IDS60801/IDS60801.95678.json for the last many
# only refresh weather file if older than an hour
if [[ ! -f "plugins/weather.json" ]]; then
  curl -L -s -o plugins/weather.json https://api.weather.bom.gov.au/v1/locations/r1f8sw/observations
elif [[ $(find "plugins/weather.json" -mtime +1h -print) ]]; then
  curl -L -s -o plugins/weather.json https://api.weather.bom.gov.au/v1/locations/r1f8sw/observations
fi

TEMP=$(cat plugins/weather.json | jq '.data.temp')
RAIN=$(cat plugins/weather.json | jq '.data.rain_since_9am')
WIND=$(cat plugins/weather.json | jq '.data.wind.speed_kilometre')
ICON=
COLOUR=$WARM_COLOUR
# bc to handle floats e.g. 0.2
if (( $(echo "$RAIN > 0" | bc -l) )); then
  ICON=
  COLOUR=$COOL_COLOUR
fi
if (( $(echo "$RAIN > 10" | bc -l) )); then
  ICON=
  COLOUR=$COOL_COLOUR
fi
TIME=`date '+%H'`
# remove leading zeroes
TIME=`echo $TIME | sed -E 's/([0])([1-9])/\2/'`
if (( "$TIME" > 19 || "$TIME" < 5 )); then
  ICON=
  COLOUR=$DEFAULT_COLOUR
fi

# round the temp to an int
TEMP=$(printf "%.0f\n" "$TEMP")

# sketchybar --set "$NAME" label="${TEMP}°" icon="$ICON" icon.color="${COLOUR}" icon.padding_right=2 icon.padding_left=6 label.padding_left=0 \
#   icon.font="Hack Nerd Font:Bold:15.0" padding_left=2
#
sketchybar --set "$NAME" label="W:${TEMP}°" label.padding_left=0 \
  icon.font="Hack Nerd Font:Bold:15.0" padding_left=0
