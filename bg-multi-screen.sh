#!/bin/sh

CONNECTED_MONITORS=`xrandr | grep " connected " | wc -l`

if [ $CONNECTED_MONITORS -eq 1 ]
  then
    feh --scale-down --bg-scale "/usr/share/backgrounds/background.png"
  else
    feh --scale-down --bg-scale "/usr/share/backgrounds/background.png"
fi
