#!/usr/bin/env bash
# Push dotfiles repo changes to origin, rebasing each branch on master.
dotfiles_push() {
    initial_dir="$PWD"
    dotfiles_dir="$HOME/.dotfiles"

    cd "$dotfiles_dir" || return 1
    git checkout master && git push &&
    git checkout arch && git rebase master && git push -f &&
    git checkout mac && git rebase master && git push -f &&
    git checkout termux && git rebase master && git push -f &&
    if [ -n "$1" ]; then
        git checkout "$1"
    else
        git checkout master
    fi
    cd "$initial_dir"
}

# Pull and rebase all the branches of the dotfiles repository.
dotfiles_pull() {
    initial_dir="$PWD"
    dotfiles_dir="$HOME/.dotfiles"

    cd "$dotfiles_dir" || return 1
    git checkout master && git pull --rebase &&
    git checkout arch && git pull --rebase &&
    git checkout mac && git pull --rebase &&
    git checkout termux && git pull --rebase &&
    if [ -n "$1" ]; then
        git checkout "$1"
    else
        git checkout master
    fi
    cd "$initial_dir"
}

tsdate() {
    timestamp=0
    if [ -n "$1" ]; then
        timestamp="$1"
    fi
    date -d @"$timestamp" -R
}

# Extract audio from a video file using ffmpeg.
get-audio() {
    if [ "$#" -lt 1 ]; then
        echo 'You need to specify a video.'
        return 1
    elif [ "$#" -gt 1 ]; then
        echo 'Too many arguments.'
        return 1
    elif [ ! -f "$1" ]; then
        echo 'File does not exist.'
        return 1
    fi

    video_path="$1"
    # Get path without extension to be later saved as audio.
    no_extension="${video_path%.*}"

    extension="$(
        ffprobe -v quiet -show_streams -print_format xml -hide_banner "$video_path" |
        xmllint --noent --xpath 'string(//stream[2]/@codec_name)' -
    )"

    ffmpeg -i "$video_path" -vn -acodec copy "$no_extension.$extension"
}

# Change working directory to the git root if the current working
# directory is inside of a git repository.
groot() {
    git status > /dev/null 2>&1 || return 1
    cd "$(git rev-parse --show-cdup)"
}

# Git stash and repeat previous command.
gshr() {
    git status > /dev/null 2>&1 || return 1
    git stash
    fc -s
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
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
