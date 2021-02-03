#!/bin/bash

# Set keyboard layouts. localectl is provided by systemd.
localectl --no-convert set-x11-keymap us,ru,ua pc105 "" grp:alt_shift_toggle,caps:ctrl_modifier &

# Load udiskie in the background.
udiskie --smart-tray &

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
picom &

# Notification daemon
dunst &

# Hide cursor when idle.
unclutter &

# Syncthing GUI + tray, also starts syncthing daemon.
XDG_CURRENT_DESKTOP='i3' syncthing-gtk --minimized &

nm-applet &

blueman-applet &

idlelock &

# Bind keys.
sxhkd &

# Set key repeat rate.
xset r rate 250 50 &

# Disable bell.
xset -b

# Start the gnome-keyring-daemon.
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Start i3.
exec i3
