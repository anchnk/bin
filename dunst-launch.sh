#!/usr/bin/env bash

# Terminate already running dunst instances
killall -q dunst

# Wait until processes have been shut down
while pgrep -x dunst > /dev/nll; do sleep 1; done

# Launch dunst in background
dunst &
