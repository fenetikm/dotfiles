#!/usr/bin/env zsh

hs -c "hs.alert.show('Restarting yabai..')"
yabai --restart-service
hs -c "hs.alert.show('Restarted.')"
