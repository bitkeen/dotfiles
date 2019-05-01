#!/usr/bin/env python
# Clickable date blocklet for i3blocks.
# Example:
# [date]
# command=date.py '%a, %d.%m'
# instance=urxvt -e calcurse
# interval=5
from argparse import ArgumentParser
from time import strftime
import os
import subprocess as sp

def get_args():
    """Set up argument parser. The positional argument is date
    format.
    """
    parser = ArgumentParser('Clickable date blocklet for i3blocks.')
    parser.add_argument('format', type=str,
                        help='date format')
    return parser.parse_args()

if __name__ == '__main__':
    instance = os.environ.get('BLOCK_INSTANCE')
    button = os.environ.get('BLOCK_BUTTON')

    args = get_args()
    print(strftime(args.format))

    if button == '1' and instance:
        sp.call(instance.split())
