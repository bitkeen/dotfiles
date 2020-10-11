# Exports {{{
# Only bash-specific variables. The rest of the exports are in shell_env.

# Ignore lines that start with a space,
# don't save lines matching a previous history entry.
export HISTCONTROL=ignorespace:ignoredups:erasedups
# Don't limit the number of commands to save in history.
export HISTSIZE=-1
export HISTTIMEFORMAT="%Y-%m-%d %T "
# Make any new terminal have the history of other terminals without
# having to exit those other terminals.
export PROMPT_COMMAND='history -a'
# }}}

# Main {{{

source ~/.config/shell_startup

# Enable autocd for bash versions greater than 4.
[ "${BASH_VERSINFO[0]}" -ge 4 ] && shopt -s autocd

# Enable extended pattern matching features.
shopt -s extglob

# Even though vi-mode is already set through readline configuration,
# still need to set it here for fzf default bindings to work.
set -o vi

# Disable XON/XOFF flow control (Ctrl+S, Ctrl+Q).
stty -ixon

# For copyline function see `shell_functions` file.
bind -x '"\C-]":copyline'

# Paths {{{
git_completion_file="/usr/share/bash-completion/completions/git"
# }}}

# Enable completion for git.
if _source_if_exists "$git_completion_file"; then
    # Make git completion work with an alias if it exists.
    # Since there could be multiple aliases that contain "git" in them,
    # Need to search strictly for aliases of 'git'.
    # \047 is octal representation of a single quote.
    git_alias=$(alias | awk '/\047git\047/ {print $2}' | cut -f 1 -d '=')
    if [ -n "$git_alias" ]; then
        complete -o default -o nospace -F _git "$git_alias"
    fi
fi

# }}}

# Prompt {{{

bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"

arrow_color="\[$(tput setaf 208)\]"
ranger_color="\[$(tput setaf 96)\]"
vim_color="\[$(tput setaf 70)\]"
venv_color="\[$(tput setaf 66)\]"
ssh_color="\[$(tput setaf 239)\]"
git_color="\[$(tput setaf 75)\]"

# Working directory.
ps1_left="${reset}${bold}\w${reset}"
ps1_right=""

ps1_vim() {
    if [ -n "$VIMRUNTIME" ]; then
        vim_status="in vim"
    else
        vim_status=""
    fi
    [ -n "$vim_status" ] && echo " ($vim_status)"
}

ps1_status() {
    local last_status="$?"
    [ "$last_status" = '0' ] && echo '+' || echo '-'
}

ps1_right+="${reset}${bold}${vim_color}\$(ps1_vim)${reset}"
ps1_right+="${reset}${bold}${ranger_color}\$(ps1_ranger)${reset}"
ps1_right+="${reset}${bold}${venv_color}\$(ps1_venv)${reset}"
ps1_right+="${reset}${bold}${git_color}\$(ps1_git)${reset}"

# Modify the prompt when using SSH.
if [ -n "$SSH_CLIENT" ]; then
    ps1_u_at_h="${reset}${bold}\u@\h " # user@host
    ps1_left="${ps1_u_at_h}${ps1_left}"
    ps1_right+=" ${reset}${bold}${ssh_color}(ssh)${reset}"
fi

# Show the number of background jobs in the number is greater than 0.
ps1_jobs='$([ \j -gt 0 ] && echo " [\j]")'
ps1_right+="${reset}${bold}${ps1_jobs}${reset}"

# Add an arrow at the end.
# Last space is actually an nbsp. It is used for searching the
# previous command in tmux (see .tmux.conf).
ps1_arrow=' > '
ps1_right+="${reset}${bold}${arrow_color}${ps1_arrow}${reset}"

export PS1="${reset}${bold}\$(ps1_status)${reset} ${ps1_left}${ps1_right}"

# }}}
