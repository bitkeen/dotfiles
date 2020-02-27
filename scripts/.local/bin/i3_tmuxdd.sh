#!/usr/bin/env sh
# Tmux dropdown launch script.
#
# Arguments:
# $1 - terminal window name
# $2 - tmux session to attach to

[ -z "$1" ] && exit 1
[ -z "$2" ] && exit 1

dd_name=$1
session_name=$2

# Check if tmux dropdown is already launched.
if ! pgrep -f "urxvt -name $dd_name"; then
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
