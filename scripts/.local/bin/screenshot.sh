#!/bin/sh
# A wrapper for the maim screenshot utility.

image="$(xdg-user-dir PICTURES)screenshots/screenshot-$(date +%Y%m%dT%H%M%S).png"
maim "$@" |
    tee "$image" |
    xclip -selection clipboard -t image/png &&
    notify-send -i "$(readlink -f "$image")" "Screenshot captured"
