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
compdef alias-wrapper-docker=docker
compdef alias-wrapper-journalctl=journalctl
compdef alias-wrapper-systemctl=systemctl
compdef alias-wrapper-pip=pip
compdef git_alias=git
compdef m=man

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
# Don't write command to history if it starts with a space.
setopt HIST_IGNORE_SPACE
# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS
# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS
# Allow comments even in interactive shells.
setopt INTERACTIVE_COMMENTS

# Set vi mode.
bindkey -v
# Set Esc key lag in vi mode to 150ms.
# https://github.com/zsh-users/zsh-autosuggestions/issues/254
export KEYTIMEOUT=15

# Original source: https://vinipsmaker.wordpress.com/2014/02/23/my-zsh-config/
# bash prints ^C when you're typing a command and Ctrl-C to cancel, so it
# is easy to see it wasn't executed. By default, ZSH doesn't print the ^C.
# Trap SIGINT to make it print the ^C.
TRAPINT() {
  print -n -u2 '^C'
  return $((128+$1))
}

# Insert mode.
bindkey -M viins '^[[3~' delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^F' clear-screen
bindkey -M viins '^]' vi-yank-whole-line
bindkey -M viins '^N' down-history
bindkey -M viins '^P' up-history

bindkey -M viins '^X^U' kill-whole-line
bindkey -M viins -s '^[g' '^X^U fzg\n'
bindkey -M viins -s '^o' '^X^U fg\n'
bindkey -M viins -s '^g' '^X^U git status\n'

# Set up some emacs-like bindings in insert mode.
# ^[ is Alt.
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^[d' delete-word
bindkey -M viins '^d' delete-char
bindkey -M viins '^[b' backward-word
bindkey -M viins '^b' backward-char
bindkey -M viins '^[f' forward-word

# Normal mode.
bindkey -M vicmd '^F' clear-screen
bindkey -M vicmd '^[[3~' delete-char

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

PROMPT=""
PROMPT+="%~"                      # Current directory.
PROMPT+="%F{70}\$(ps1_vim)%f"     # Vim.
PROMPT+="%F{96}\$(ps1_ranger)%f"  # Ranger.
PROMPT+="%F{66}\$(ps1_venv)%f"    # Venv.
PROMPT+="%F{75}\$(ps1_git)%f"     # Git status.

if [ -n "$SSH_CLIENT" ]; then
    PROMPT="%F{250}%n@%M%f ${PROMPT}"  # user@host
    PROMPT+=" %F{160}(ssh)%f"
fi

# Show the number of background jobs.
PROMPT+="%(1j. [%j].)"

# Add status of the previous command.
PROMPT="%(0?.+.-) ${PROMPT}"

# Add an arrow at the end.
# Surrounding spaces are actually nbsps, used for searching the previous
# command in tmux (see .tmux.conf).
PROMPT+=" %F{green}>%f "

# Make everything bold.
PROMPT="%B${PROMPT}%b"

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
    # The second condition would have been enough, but
    # the first one is likely a tiny bit faster.
    # Unlike the first one the second one would be set
    # over SSH even if not attached to TMUX on the remote host.
    if [ -n "$TMUX" ] || [ "$TERM" = 'tmux-256color' ]; then
        cursor="\ePtmux;\e$cursor\e\\"
    fi
    echo -ne "$cursor"
}
zle -N zle-keymap-select

# Copy current command to system clipboard.
vi-copy-line() {
    zle vi-yank-whole-line
    printf %s "$CUTBUFFER" | xclip-in
}
vi-copy-eol() {
    zle vi-yank-eol
    printf %s "$CUTBUFFER" | xclip-in
}
zle -N vi-copy-line
zle -N vi-copy-eol
bindkey -M vicmd 'Y' vi-copy-eol
bindkey -M vicmd '^]' vi-copy-line
bindkey -M viins '^]' vi-copy-line

# Update cursor for each new prompt.
precmd() { zle-keymap-select }

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select
# Case-insensitive (uppercase from lowercase) completion.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Plugins
zsh_plugins="$HOME/.config/zsh/plugins"

source "$zsh_plugins/fzf-tab/fzf-tab.plugin.zsh"
# Disable sort when completing `git checkout`.
zstyle ':completion:*:git-checkout:*' sort false
# Set descriptions format to enable group support.
zstyle ':completion:*:descriptions' format '[%d]'
# Prefix for entries in groups default is '·'.
zstyle ':fzf-tab:*' prefix ''
# Preview directory's content with ls when completing cd.
ls_alias="$(alias ls | cut -d '=' -f2- | sed "s/'//g")"
zstyle ':fzf-tab:complete:cd:*' fzf-preview "$ls_alias --color=always \$realpath"
# Switch group using `,` and `.`.
zstyle ':fzf-tab:*' switch-group ',' '.'

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
export ZSH_AUTOSUGGEST_USE_ASYNC=1
source "$zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Increment and decrement numbers easily with Ctrl+a and Ctrl+x.
source "$zsh_plugins/vi-increment/vi-increment.zsh"
source "$zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Disable globs for the `=` calculator script
# to be able to do `= 3*3` instead of `= '3*3'`.
aliases[=]='noglob ='
