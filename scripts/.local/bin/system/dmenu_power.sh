#!/bin/sh
# Use dmenu to reboot, shutdown, suspend, etc.
# Pass arguments to dmenu.

commands="lock\nreboot\nshutdown\nsuspend"

choice=$(printf "%b" "$commands" | dmenu -i "$@")

case "$choice" in
    "lock")
        ~/.local/bin/system/screen_lock.sh
        ;;
    "reboot")
        reboot
        ;;
    "shutdown") 
        poweroff
        ;;
    "suspend") 
        systemctl suspend
        ;;
esac
