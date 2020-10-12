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

get_color() {
    echo "\[$(tput setaf "$1")\]"
}

bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"

# Working directory.
ps1_left="\w"

ps1_right=""
ps1_right+="$(get_color 70)\$(ps1_vim)"
ps1_right+="$(get_color 96)\$(ps1_ranger)"
ps1_right+="$(get_color 66)\$(ps1_venv)"
ps1_right+="$(get_color 75)\$(ps1_git)"

# Modify the prompt when using SSH.
if [ -n "$SSH_CLIENT" ]; then
    ps1_u_at_h="\u@\h " # user@host
    ps1_left="${ps1_u_at_h}${ps1_left}"
    ps1_right+=" $(get_color 239)(ssh)"
fi

# Show the number of background jobs in the number is greater than 0.
ps1_jobs='$([ \j -gt 0 ] && echo " [\j]")'
# Use the same color as the `\w` part.
ps1_right+="${reset}${bold}${ps1_jobs}"

# Add an arrow at the end.
ps1_right+=" $(get_color 208)>"

# Last space is actually an nbsp. It is used for searching the
# previous command in tmux (see .tmux.conf).
export PS1="${reset}${bold}\$(ps1_status) ${ps1_left}${ps1_right}${reset} "

# }}}
