#!/usr/bin/env sh
# Open an existing tmux session in a new terminal window.
# Pass arguments to dmenu.

sessions="$(tmux ls | awk -F ':' '{print $1}')"

choice=$(echo "$sessions" | dmenu_configured -p 'tmux attach -t ' "$@")

if [ -n "$choice" ]; then
    i3 "exec --no-startup-id urxvt -e bash -i -c 'tmux attach -t $choice'"
fi
