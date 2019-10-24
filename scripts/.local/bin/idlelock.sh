#!/bin/sh

xidlehook \
  --not-when-audio \
  --timer normal 150 \
    'notify-send "Screen will be locked in 30s."' \
    '' \
  --timer normal 180 \
    'xsecurelock' \
    '' \
