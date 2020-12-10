export HISTFILE=~/.zsh_history
# Zsh doesn't have an option for unlimited history. Set size to a billion.
export HISTSIZE=1000000000
export SAVEHIST="$HISTSIZE"

# Source aliases and functions.
source ~/.config/shell_startup

autoload -Uz compinit
compinit
# Show hidden files in completions.
_comp_options+=(globdots)

# Disable XON/XOFF flow control (Ctrl+S, Ctrl+Q).
unsetopt FLOW_CONTROL
# Make globs case-insensitive.
unsetopt CASE_GLOB

setopt AUTO_CD
# Make completion work with cursor in the middle of a word.
setopt COMPLETE_IN_WORD
# Record command timestamps and runtime.
setopt EXTENDED_HISTORY
# Append to history on each command, don't wait for shell exit.
setopt INC_APPEND_HISTORY
# Do not display duplicates in search, even if the duplicates are not
# contiguous. History already worked this way with fzf Ctrl-R.
setopt HIST_FIND_NO_DUPS
# Allow comments even in interactive shells.
setopt INTERACTIVE_COMMENTS

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

# Enable surround.vim functionality.
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# Escape globs when pasting urls.
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload edit-command-line
zle -N edit-command-line
# Default mapping for v in normal mode is to start visual selection.
bindkey -M vicmd v edit-command-line

# Perform parameter expansion, command substitution and
# arithmetic expansion in prompts.
setopt prompt_subst

PROMPT="%(0?.+.-)"               # Status of last command.
PROMPT+=" %~"                    # Current directory.
PROMPT+="%F{70}\$(ps1_vim)%f"    # Vim.
PROMPT+="%F{96}\$(ps1_ranger)%f" # Ranger.
PROMPT+="%F{66}\$(ps1_venv)%f"   # Venv.
PROMPT+="%F{75}\$(ps1_git)%f"    # Git status
PROMPT+="%(1j. [%j].)"           # Background job count.
# Surrounding spaces are actually nbsps, used for searching the previous
# command in tmux (see .tmux.conf).
PROMPT+=" %F{green}>%f "         # Arrow.
# Make everything bold.
PROMPT="%B$PROMPT%b"

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

# Copy current command to system clipboard.
vi-copy-line() {
    zle vi-yank-whole-line
    printf %s "$CUTBUFFER" | copy
}
zle -N vi-copy-line
bindkey -M vicmd 'Y' vi-copy-line
bindkey -M vicmd '^]' vi-copy-line
bindkey -M viins '^]' vi-copy-line

# Update cursor for each new prompt.
precmd() { zle-keymap-select } 

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# Plugins
zsh_plugins="$HOME/.config/zsh/plugins"
# Increment and decrement numbers easily with Ctrl+a and Ctrl+x.
source "$zsh_plugins/vi-increment/vi-increment.zsh"
source "$zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
