#!/bin/bash

CONNECTED_DISPLAY=$(xrandr | cut -d' ' -f2 | grep '^connected' | wc -l)

if [ $CONNECTED_DISPLAY -eq 1 ];
  then
    feh --scale-down --bg-scale "/usr/share/backgrounds/background.png"
  else
    feh --scale-down --bg-scale "/usr/share/backgrounds/background.png"
fi
