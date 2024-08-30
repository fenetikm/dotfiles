#! /usr/bin/env zsh

ACTION=$(yabai -m config mouse_drop_action)
if [[ "$ACTION" == 'swap' ]]; then
  yabai -m config mouse_drop_action stack
  hs -c "hs.alert.show('mouse drop set to: stack')"
else
  yabai -m config mouse_drop_action swap
  hs -c "hs.alert.show('mouse drop set to: swap')"
fi
