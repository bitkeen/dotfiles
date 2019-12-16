#!/bin/sh
# Use dmenu to reboot, shutdown, suspend, etc.
# Pass arguments to dmenu.

commands="lock\nreboot\nshutdown\nsuspend\nexit i3\ncancel"

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
    "cancel")
        exit
        ;;
    "exit i3")
        i3-msg exit
        ;;
esac
