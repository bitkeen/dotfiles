#!/usr/bin/env bash
# Open an existing tmux session in a new terminal window.

sessions="$(tmux ls | awk -F ':' '{print $1}')"

choice=$(echo "$sessions" | dmenu -i)

i3 "exec --no-startup-id urxvt -e bash -i -c 'tmux attach -t $choice'"
