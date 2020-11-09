#!/bin/sh
# Update keyboard layout in virtual console.
set -e

dest='/usr/local/share/kbd/keymaps/personal.map'
dest_gz="${dest}.gz"

cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz "${dest_gz}"
gunzip -f "${dest_gz}"

# Make Caps-Lock a control.
sed -i 's/^keycode  58 = Caps_Lock$/keycode  58 = Control/' "${dest}"
echo "KEYMAP=${dest}" > /etc/vconsole.conf
