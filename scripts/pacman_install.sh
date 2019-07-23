#!/bin/sh
# Install packages from a text file with pacman.
# Each package has to be on a separate line.
# Comments are allowed and should start with #.

[ "$#" -ne 1 ] && echo 'Wrong # of arguments.' && exit 1
filename="$1"

# Delete the comments first.
sed -e "/^#/d" -e "s/ \?\#.*//" "$filename" |
    pacman -S --needed -
