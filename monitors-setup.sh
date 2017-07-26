#!/bin/sh

CONNECTED_MONITORS=`xrandr | grep " connected " | wc -l`

if [ $CONNECTED_MONITORS -gt 1 ];
then
  $HOME/.screenlayout/office-large-dual.sh
else
  $HOME/.screenlayout/home-single.sh
fi

$HOME/bin/set-bg.sh
$HOME/bin/launch-polybar.sh
