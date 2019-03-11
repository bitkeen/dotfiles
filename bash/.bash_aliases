#!/bin/sh
# Reload .Xresources.
alias xup="xrdb ~/.Xresources"
# Reload .bashrc.
alias bup='source ~/.bashrc'
# Reload .tmux.conf.
alias tup='tmux source-file ~/.tmux.conf'
# Reload Readline's .inputrc.
alias rup='bind -f ~/.inputrc'

alias ls='ls -p'
alias ll='ls -AlF'

# Prompt before overwriting.
alias mv='mv -i'

# Highlight matches, ignore case distinctions.
# Output line numbers with -n.
# Ignore binary files with -I.
alias grep='grep -n --color=auto --ignore-case -I'
alias gr='grep'

# Git.
alias g='git'

# dotfiles push
# Push dotfiles repo changes to origin, rebasing each branch on master.
function dps {
    initial_dir=$PWD
    dotfiles_dir="$HOME/.dotfiles"

    cd $dotfiles_dir
    git checkout master && git push &&
    git checkout arch && git rebase master && git push -f &&
    git checkout mac && git rebase master && git push -f &&
    git checkout termux && git rebase master && git push -f &&
    if [ -n "$1" ]; then
        git checkout $1
    else
        git checkout master
    fi
    cd $initial_dir
}

# dotfiles pull
# Pull and rebase all the branches of the dotfiles repository.
function dpl {
    initial_dir=$PWD
    dotfiles_dir="$HOME/.dotfiles"

    cd $dotfiles_dir
    git checkout master && git pull --rebase &&
    git checkout arch && git pull --rebase &&
    git checkout mac && git pull --rebase &&
    git checkout termux && git pull --rebase &&
    if [ -n "$1" ]; then
        git checkout $1
    else
        git checkout master
    fi
    cd $initial_dir
}

function groot {
    # Change working directory to the git root if the current working
    # directory is inside of a git repository.
    git status > /dev/null 2>&1 || return 1
    cd "$(git rev-parse --show-cdup)".
}

# Kill processes by name.
alias ka='killall'

# Open ranger.
# alias r='ranger'
# The ranger-cd version switches the directory in bash on exit.
alias r='ranger-cd'

alias t='tmux'

# Open (with) vim.
alias v='vim'
# Open vimwiki.
alias vw='vim -c "VimwikiIndex"'

# Create directory.
# -p - no error if existing, make parent directories as needed.
# -v - print a message for each created directory.
alias mkd='mkdir -pv'

alias bandcamp-dl="bandcamp-dl --base-dir=$HOME/Downloads/bandcamp-dl"

alias ytdl='youtube-dl'
# Download playlists using a separate config.
# The config specifies different directory structure.
alias ytdlpl='youtube-dl --config-location ~/.config/youtube-dl-playlist.conf'
# There are options to download subtitles in the main config file,
# the subtitles are not needed for audio-only downloads, and can't
# be merged into an audio file, so a separate config file for audio
# is needed, without the subtitle options.
alias ytdlmp3='youtube-dl --config-location ~/.config/youtube-dl-audio.conf'

# Get weather report.
alias weather='curl wttr.in'
