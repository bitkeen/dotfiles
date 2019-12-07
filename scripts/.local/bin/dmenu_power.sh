#!/bin/sh
# Use dmenu to reboot, shutdown, suspend, etc.
# Pass arguments to dmenu.

commands="lock\nreboot\nshutdown\nsuspend"

choice=$(printf "%b" "$commands" | dmenu_configured "$@")

case "$choice" in
    "lock")
        screen_lock.sh
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
