#!/usr/bin/env sh
# Tmux dropdown launch script.
# Takes dropdown window name as an argument.

[ -z "$1" ] && exit

dd_name=$1

# Check if tmux dropdown is already launched.
if ! pgrep -f "urxvt -name $dd_name"; then
    session_name="dropdown"
    tmux_cmd="tmux new-session -A -s $session_name"
    i3 "exec --no-startup-id urxvt -name $dd_name -e $tmux_cmd"

    # Wait until the session is ready.
    while ! tmux ls | grep $session_name | grep attached
    do
        continue
    done
fi

# Show dropdown window.
i3 "[instance=\"$dd_name\"] scratchpad show; [instance=\"$dd_name\"] move position center"
