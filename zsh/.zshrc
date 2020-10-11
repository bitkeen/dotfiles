# Source aliases and functions.
source ~/.config/shell_startup

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

PROMPT="%(0?.+.-)"               # Status of last command.
PROMPT+=" %~"                    # Current directory.
PROMPT+="%F{70}\$(ps1_vim)%f"    # Vim.
PROMPT+="%F{96}\$(ps1_ranger)%f" # Ranger.
PROMPT+="%F{66}\$(ps1_venv)%f"   # Venv.
PROMPT+="%F{75}\$(ps1_git)%f"    # Git status
PROMPT+="%(1j. [%j].)"           # Background job count.
PROMPT+=" %F{green}>%f"            # Arrow.
PROMPT="%B$PROMPT%b "            # Make everything bold.

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

# Plugins
zsh_plugins="$HOME/.config/zsh/plugins"
# Increment and decrement numbers easily with Ctrl+a and Ctrl+x.
source "$zsh_plugins/vi-increment/vi-increment.zsh"
source "$zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
