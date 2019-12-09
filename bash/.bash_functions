#!/usr/bin/env bash
u() {
    # Go up $1 directories.
    # If $1 is omitted or is not an integer, go up 1 directory.
    dir=''
    if echo "$1" | grep -Eq '^[0-9]+$'; then
        for i in $(seq "$1")
        do
            dir="$dir../"
        done
    else
        dir='..'
    fi
    cd "$dir"
}

# Change working directory to the git root if the current working
# directory is inside of a git repository.
groot() {
    git status > /dev/null 2>&1 || return 1
    cd "$(git rev-parse --show-toplevel)"
}

# Run git stash and repeat the previous command.
gshr() {
    git status > /dev/null 2>&1 || return 1
    git stash
    fc -s
}

# Run git stash, repeat the previous command and pop from the stash.
gshrp() {
    git status > /dev/null 2>&1 || return 1
    git stash
    fc -s
    git stash pop
}

ww() {
    # Open index file of the $1 wiki (the first one if $1 is omitted).
    vim -c "execute \"normal $1\<Plug>VimwikiIndex\""
}

# Open a directory from special files containing a list of shortcuts.
fzg() {
    cd "$(fzf_shortcuts ~/.config/shortcuts ~/.config/shortcuts.local)" ||
        return 1
}

fzd() {
    fzf_dbs ~/.config/db_connections.local
}

# Automatically change the directory in bash after closing ranger.
# Source:
# https://github.com/ranger/ranger/blob/master/examples/bash_automatic_cd.sh
# The same script can be found locally:
# /usr/share/doc/ranger/examples/bash_automatic_cd.sh
#
# This is a function for automatically changing the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.
ranger-cd() {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# Get a list of all mounted partitions, pipe it to fzf and open the
# resulting directory in ranger.
rpart() {
    ranger "$(lsblk -l | grep -P -o "/.*" | fzf --height=20% --reverse)"
}
