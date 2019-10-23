#! /bin/bash

# Set keyboard layouts. localectl is provided by systemd.
localectl --no-convert set-x11-keymap us,ru,ua pc105 "" grp:alt_shift_toggle,caps:ctrl_modifier &

# Load udiskie in the background.
udiskie --smart-tray --udisks-auto &

# Load icc profile on display host:0.
#/usr/bin/xcalib -d :0 ~/.config/icc-profiles/6500.icm

redshift-gtk &> /dev/null || redshift &> /dev/null &

# Start PulseAudio server.
/usr/bin/start-pulseaidio-x11 &

# If an external screen is connected, duplicate the output
# instead of putting the screen to the right of the main display.
xrandr --output HDMI-2 --auto --pos 0x0

# Load .Xresources.
xrdb .Xresources

# Set previously used wallpaper.
~/.fehbg &

# MPD daemon start (if no other user instance exists).
pgrep mpd || mpd

# A compositor for X11
compton &

# Notification daemon
dunst &

# Hide cursor when idle.
unclutter &

# Needed for Syncthing tray icon.
syncthing-gtk &

# Start i3.
exec i3
