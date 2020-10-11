autoload -Uz compinit
compinit

setopt autocd

# Disable XON/XOFF flow control (Ctrl+S, Ctrl+Q).
unsetopt flow_control

# Set vi mode.
bindkey -v
# Reduce Esc key lag in vi mode to 10ms.
export KEYTIMEOUT=1

# Insert mode.
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^F' clear-screen
bindkey '^]' vi-yank-whole-line
bindkey -s '^G' ' fzg\n'

# Normal mode.
bindkey -a '^F' clear-screen
bindkey -a '^[[3~' delete-char

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
PROMPT='%F{blue}%B%~%b%f > '

# Change cursor shape for different vi modes.
zle-keymap-select () {
    if [ "$KEYMAP" = 'vicmd' ]; then
        cursor='\e[2 q'
    elif 
        [ "$KEYMAP" = 'main' ] ||
        [ "$KEYMAP" = 'viins' ] ||
        [ "$KEYMAP" = '' ]; then
            cursor='\e[5 q'
    fi
    [ -n "$TMUX" ] && cursor="\ePtmux;\e$cursor\e\\"
    echo -ne "$cursor"
}
zle -N zle-keymap-select

# Update cursor for each new prompt.
precmd() { zle-keymap-select } 

# Source aliases and functions.
source ~/.config/shell_startup

# Plugins
zsh_plugins="$HOME/.config/zsh/plugins"
# Increment and decrement numbers easily with Ctrl+a and Ctrl+x.
source "$zsh_plugins/vi-increment/vi-increment.zsh"
source "$zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
