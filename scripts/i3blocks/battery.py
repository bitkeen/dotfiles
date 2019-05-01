#!/usr/bin/env python
# Battery status block for i3blocks.
# Based on the default battery block, which is written in Perl.
#
# The default block has a problem with displaying information for the main
# battery when a wireless mouse or keyboard is connected. The problem stems
# from "acpi" output which displays battery information for wireless peripherals
# and can change the battery indices. So setting a BLOCK_INSTANCE variable for
# battery number was not reliable.
#
# Example usage:
# [battery]
# command=python ~/.config/i3/i3blocks/battery.py
# interval=30
from collections import Counter
import os
import re
import subprocess


def print_full_text(status, percent):
    '''Change label depending on status and charge percent values.'''
    format_string = ''
    if status == 'Discharging':
        if percent <= 10:
            format_string = ' {}%\n'
        elif percent <= 25:
            format_string = ' {}%\n'
        elif percent <= 50:
            format_string = ' {}%\n'
        elif percent <= 75:
            format_string = ' {}%\n'
        else:
            format_string = ' {}%\n'
    elif status == 'Charging':
        format_string = ' {}%\n'
    print(format_string.format(percent))
    print_color(status, percent)


def print_color(status, percent):
    '''Change color and urgent flag depending on status and charge percent
    values.
    '''
    if status == 'Discharging':
        if percent <= 10:
            print('#FF0000\n')
        elif percent <= 25:
            print('#FFAA00\n')
        elif percent <= 50:
            print('#FFEE00\n')

        if percent < 5:
            # Urgent flag.
            exit(33)
    exit(0)


def find_battery(acpi):
    '''Find the laptop's main battery. It should have two lines in the output
    of "acpi -V": one with charge status, the other one with battery capacity.
    Other batteries only have one line of output.
    '''
    bat_pattern = '(Battery \d):'
    bat_counter = Counter(re.findall(bat_pattern, acpi))
    battery = max(bat_counter.keys(), key=lambda key: bat_counter[key])
    return battery


if __name__ == '__main__':
    # Get acpi output.
    acpi = subprocess.check_output(['acpi' , '-V']).decode('utf-8')
    # Find laptop's battery.
    battery = find_battery(acpi)
    pattern = battery + ': ([\w\s]+), (\d+)'
    # Get battery status and percent values from acpi output.
    (status, percent) = re.search(pattern, acpi).groups()

    print_full_text(status, int(percent))
