#!/bin/sh
# A wrapper for the maim screenshot utility.

screenshots_dir="$(xdg-user-dir PICTURES)screenshots"

if [ ! -d "$screenshots_dir" ]; then
    notify-send \
        --app-name='screenshot' \
        'Error capturing screenshot' \
        'Screenshots dir does not exist'
    exit 1
fi

filepath="$screenshots_dir/screenshot-$(date +%Y%m%dT%H%M%S).png"

maim "$@" |
    tee "$filepath" |
    xclip -selection clipboard -t image/png &&
    notify-send \
        --app-name='screenshot' \
        -i "$(readlink -f "$image")" 'Screenshot captured'
