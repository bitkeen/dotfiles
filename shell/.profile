export EDITOR=/usr/bin/vim
export TERMINAL=/usr/bin/urxvt
export FZF_DEFAULT_OPTS=" \
    --preview 'fzf-preview {} | head -n 50' \
    --preview-window='hidden' \
    --bind='ctrl-t:toggle-preview' \
    --bind='alt-enter:print-query' \
    "
export FZF_ALT_C_OPTS='--height 60% --preview-window="nohidden"'
export FZF_CTRL_R_OPTS='--sort --reverse --height 60%'
export FZF_CTRL_T_OPTS='--height 60% --preview-window="nohidden"'
# Default command ignores all dot-directories. This one only ignores `.git`.
export FZF_ALT_C_COMMAND="command find -L . -mindepth 1 \\( -path '*/\\.git*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) \
    -prune -o -type d -print 2> /dev/null | cut -b3-"
export FZF_CTRL_T_COMMAND="command find -L . -mindepth 1 \\( -path '*/\\.git*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) \
    -prune -o -type f -print -o -type d -print -o -type l -print 2> /dev/null | cut -b3-"
export GOPATH="$HOME/.local/share/go"
# The following variable is needed for USB drives to work.
# See https://unix.stackexchange.com/questions/26842/mounting-usb-drive-that-is-not-recognized.
export MTP_NO_PROBE="1"
# Scripts and user-specific Python packages are installed in .local/bin.
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/bin.local"
export PATH="$PATH:$HOME/.vim/pack/bundle/opt/vim-superman/bin"
which ruby > /dev/null 2>&1 && export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
# Avoid loading default config file for ranger if a custom one exists.
[ -f "$HOME/.config/ranger/rc.conf" ] && export RANGER_LOAD_DEFAULT_RC=FALSE
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/rgconfig"
# Disable the default virtualenv prompt change.
export VIRTUAL_ENV_DISABLE_PROMPT=1
# The number of pixels the prompt of auth_x11 may be moved at startup to
# mitigate possible burn-in effects
export XSECURELOCK_SHOW_DATETIME=1
export XSECURELOCK_BURNIN_MITIGATION=20

# Scale Qt applications.
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_FONT_DPI=120

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
	startx
fi
