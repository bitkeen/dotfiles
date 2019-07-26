#!/usr/bin/env python
# Keyboard layout block for i3blocks based on xkb-switch utility.
# Example usage:
# keyboard_layout.py --colors white blue yellow
import os
from argparse import ArgumentParser
from subprocess import call, check_output

def get_args():
    """Set up argument parser. The single optional argument is an
    array of colors that the layouts will be displayed in. If it's
    omitted, all layouts will be displayed in white.
    Return parsed arguments.
    """
    parser = ArgumentParser('Keyboard layout block for i3blocks.')
    parser.add_argument('-c', '--colors', type=str, nargs='*',
                        help='colors that the layouts will be displayed in')
    return parser.parse_args()


def get_current_layout():
    """Return keyboard layout obtained from the xkb-switch utility."""
    layout = check_output(['xkb-switch'], universal_newlines=True)
    # remove the newline symbol, convert to upper case
    return layout.strip().upper()


def get_all_layouts():
    """Return a list of all layouts from xkb-switch utility."""
    layouts = check_output(['xkb-switch', '-l'], universal_newlines=True)
    return [lt.upper() for lt in layouts.split()]


def main():
    # Switch to the next layout on left mouse button click.
    if os.environ.get('BLOCK_BUTTON') == '1':
        call(['xkb-switch', '-n'])

    args = get_args()
    colors = args.colors if args.colors else []

    current_lt = get_current_layout()
    layouts = get_all_layouts()

    while len(colors) < len(layouts):
        colors.append('white')
    dict_colors = {l: c for l, c in zip(layouts, colors)}

    markup = "<span color='{}'>{}</span>"
    block_text = markup.format(dict_colors[current_lt], current_lt)
    print(block_text)


if __name__ == '__main__':
    main()
