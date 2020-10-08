autoload -Uz compinit
compinit

setopt autocd

# Disable XON/XOFF flow control (Ctrl+S, Ctrl+Q).
unsetopt flow_control

# Vi mode
# Set up esc timeout
# (readline?)
bindkey -v
# Reduce Esc key lag in vi mode to 10ms.
export KEYTIMEOUT=1

# for f in ~/.config/bash/*; do source "$f"; done
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'

# Source aliases and functions.
source ~/.config/shell_startup

# Plugins
zsh_plugins="$HOME/.config/zsh/plugins"
# Increment and decrement numbers easily with Ctrl+a and Ctrl+x.
source "$zsh_plugins/vi-increment/vi-increment.plugin.zsh"
