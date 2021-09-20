#!/bin/sh

# Set keyboard layouts. localectl is provided by systemd.
localectl --no-convert set-x11-keymap us,ru,ua pc105 "" grp:alt_shift_toggle,caps:ctrl_modifier &

# Load udiskie in the background.
udiskie --smart-tray &

redshift-gtk >/dev/null 2>&1 || redshift >/dev/null 2>&1 &

# Load .Xresources.
xrdb .Xresources

# Set previously used wallpaper.
~/.fehbg &

# A compositor for X11
picom &

# Notification daemon
dunst &

# Hide cursor when idle.
unclutter &

nm-applet &

blueman-applet &

# Bind keys.
sxhkd &

# Disable paste through middle mouse button.
xmousepasteblock &

# Set key repeat rate.
xset r rate 250 50 &

# Disable bell.
xset -b &

# Disable touchpad on X1 Carbon.
touchpad='SYNA8004:00 06CB:CD8B Touchpad'
xinput list |
    grep "$touchpad" >/dev/null &&
    xinput --disable "$touchpad" &

# Start the gnome-keyring-daemon.
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Start i3.
exec i3
