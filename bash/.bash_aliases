# Reload .Xresources.
alias xup="xrdb ~/.Xresources"
# Reload .bashrc.
alias bup='source ~/.bashrc'
# Reload .tmux.conf.
alias tup='tmux source-file ~/.tmux.conf'

alias ll='ls -AlF'

# Highlight matches.
alias grep='grep --color=auto'

# Clear screen.
alias c='clear'

# Git.
alias g='git'

# Kill processes by name.
alias ka='killall'

# Open ranger.
alias r='ranger'

# Open (with) vim
alias v='vim'

# Create directory.
# -p - no error if existing, make parent directories as needed.
# -v - print a message for each created directory.
alias mkd='mkdir -pv'

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
