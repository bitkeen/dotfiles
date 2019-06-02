#!/usr/bin/env bash
if [ "$(command -v xkb-switch)" ]; then
    # Switch keyboard layout to US so that it's easier to enter
    # the password to unlock the screen.
    xkb-switch -s us
fi

if [ "$(command -v mpc)" ]; then
    # Pause mpd through mpc if it exists.
    mpc pause
fi

# Lock screen.
i3lock -u -i "$HOME/Pictures/system/lock-screen.png"
