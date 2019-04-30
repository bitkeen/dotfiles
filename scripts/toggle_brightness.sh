#!/usr/bin/env sh
# Toggle screen brightness level from 0% to 70% using light.

if [ $(light) == 0.00 ]; then
    light -S 70
else
    light -S 0
fi
