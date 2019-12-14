#!/usr/bin/env bash

# Terminate already running bar instances.
killall -q polybar

# Wait until the process has been shut down.
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# See
# https://github.com/polybar/polybar/issues/763#issuecomment-331604987
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload main &
done
