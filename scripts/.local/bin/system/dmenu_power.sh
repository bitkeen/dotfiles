#!/usr/bin/env sh
# Use dmenu to reboot, shutdown, suspend, etc.
# Pass arguments to dmenu.

commands="reboot\nshutdown\nsuspend"

choice=$(printf "%b" "$commands" | dmenu -i "$@")

case "$choice" in
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
