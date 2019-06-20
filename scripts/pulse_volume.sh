#!/bin/sh
# A wrapper for pactl.
# Its purpose is to always unmute on volume increase.

print_error() {
  echo "The script can only accept one argument and it should be one of the"\
       "following: increase, decrease, mute." >&2
}

if [ "$#" -ne 1 ]; then
    print_error
    exit 1
fi

key="$1"
case $key in
    increase)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        # Always unmute on volume increase.
        pactl set-sink-mute @DEFAULT_SINK@ 0
        ;;
    decrease)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    *)
        print_error
        exit 1
        ;;
esac
