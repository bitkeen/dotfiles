#!/usr/bin/env bash

# Terminate already running bar instances.
killall -q polybar

# Wait until the process has been shut down.
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar.
echo "---" | tee -a /tmp/polybar.log
polybar main >>/tmp/polybar.log 2>&1 &

echo "Bar launched..."
