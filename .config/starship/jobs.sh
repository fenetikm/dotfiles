#!/bin/zsh

NUM_JOBS=$(print -P "%(1j.%j.)")
OUTPUT=
case $NUM_JOBS in
  1) OUTPUT=󰎥 ;;
  2) OUTPUT=󰎨 ;;
  3) OUTPUT=󰎫 ;;
  4) OUTPUT=󰎲 ;;
  5) OUTPUT=󰎯 ;;
esac

echo "${OUTPUT}"
