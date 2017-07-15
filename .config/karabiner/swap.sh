#!/bin/bash
#
swap_config() {
  if cmp ~/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json.external >/dev/null 2>&1
  then
    cp ~/.config/karabiner/karabiner.json.local ~/.config/karabiner/karabiner.json
    echo 'karabiner set to local config'
  else
    cp ~/.config/karabiner/karabiner.json.external ~/.config/karabiner/karabiner.json
    echo 'karabiner set to external config'
  fi
}

swap_config
