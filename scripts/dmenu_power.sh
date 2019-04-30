#!/usr/bin/env bash
#A simple script that uses dmenu to reboot, shutdown, suspend, etc.

commands="reboot\nshutdown\nsuspend"

choice=$(echo -e $commands | dmenu -i)

case $choice in
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
