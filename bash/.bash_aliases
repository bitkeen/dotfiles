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
alias grep='grep --color=auto --ignore-case'
# Output line numbers with -n.
# Ignore binary files with -I.
alias gr='grep -n -I'

# Git.
alias g='git'
alias l='lab'

# Kill processes by name.
alias ka='killall'

alias d='docker'
alias c='docker-compose'
alias cdu='docker-compose down; docker-compose up'

# Open ranger.
# The ranger-cd version switches the directory in bash on exit,
# r.shell allows to expand shell aliases inside the :shell command.
alias r='SHELL=~/.dotfiles/scripts/ranger-shell.sh ranger-cd'

alias t='tmux'
alias ta='tmux attach -t'

alias ts='task'

# Open (with) vim.
alias v='vim'
# Open vimwiki.
alias vw='vim -c "VimwikiIndex"'
alias vm='vman'

# The space at the end allows the next command word following the alias
# to also be checked for alias expansion.
alias s='sudo '

# Create directory.
# -p - no error if existing, make parent directories as needed.
# -v - print a message for each created directory.
alias mkd='mkdir -pv'

alias tch='touch'

alias py='python'
alias ipy='ipython'
# Python virtualenvwrapper.
alias wo='workon'
alias deac='deactivate'

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

# --auto-vertical-output - automatically switch to vertical output
# mode if the result is wider than the terminal width.
alias mycli='mycli --auto-vertical-output'

alias dps='dotfiles_push'
alias dpl='dotfiles_pull'
