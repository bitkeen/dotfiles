#!/bin/sh
# Run a screen locking program, but first stop audio playback,
# and switch the keyboard layout to English.

# Switch keyboard layout to US so that it's easier to enter
# the password to unlock the screen.
[ "$(command -v xkb-switch)" ] && xkb-switch -s us

# Pause mpd through mpc if it exists.
[ "$(command -v mpc)" ] && mpc pause

# Lock the screen.
xsecurelock
