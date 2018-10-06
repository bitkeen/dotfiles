# Main {{{

_source_if_exists() {
    # Source a file if it exists.
    [ "$#" -ne 1 ] && return 1
    [ -f "$1" ] && source "$1"
}

# Paths
base16_shell_dir="$HOME/.config/base16-shell/"
fzf_bindings_file="/usr/share/fzf/key-bindings.bash"
fzf_completion_file="/usr/share/fzf/completion.bash"
git_completion_file="/usr/share/bash-completion/completions/git"
ranger_config_file="$HOME/.config/ranger/rc.conf"

export EDITOR=/usr/bin/vim
# Don't limit the number of commands to save in history.
export HISTSIZE=-1
# Ignore lines that start with a space,
# don't save lines matching a previous history entry.
export HISTCONTROL=ignorespace:ignoredups:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %T "
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/rgconfig"


# Enable autocd for bash versions greater than 4.
[ "${BASH_VERSINFO[0]}" -ge 4 ] && shopt -s autocd

# Even though vi-mode is already set through readline configuration,
# still need to set it here for fzf default bindings to work.
set -o vi

# Source fzf-related files.
_source_if_exists "$fzf_bindings_file"
_source_if_exists "$fzf_completion_file"

# Avoid loading default config file for ranger if a custom one exists.
if [ -f "$ranger_config_file" ]; then
    export RANGER_LOAD_DEFAULT_RC=FALSE
fi

# Enable completion for git.
if [ -f "$git_completion_file" ]; then
    source $git_completion_file

    # Make git completion work with an alias if it exists.
    git_alias=$(alias | awk '/git/ {print $2}' | cut -f 1 -d '=')
    if [ -n "$git_alias" ]; then
        complete -o default -o nospace -F _git $git_alias
    fi
fi

# Where user-specific Python packages are installed.
export PATH=$PATH:$HOME/.local/bin

export PATH="$PATH:$HOME/.vim/bundle/vim-superman/bin"

# Load virtualenvwrapper.
source /usr/bin/virtualenvwrapper_lazy.sh

# Base16 Shell.
[ -n "$PS1" ] && \
    [ -s "$base16_shell_dir/profile_helper.sh" ] && \
        eval "$("$base16_shell_dir/profile_helper.sh")"

# Enable completion for pip.
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip

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

green_color="\[$(tput setaf 77)\]"
red_color="\[$(tput setaf 124)\]"

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

# Modify the prompt when using a shell from inside ranger.
ps1_ranger() {
    if [ -n "$RANGER_LEVEL" ]; then
        ranger="in ranger"
    else
        ranger=""
    fi
    [ -n "$ranger" ] && echo " ($ranger)"
}

# Modify the prompt when using a virtual environment.
ps1_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        # Strip out the path and just leave the env name.
        venv="${VIRTUAL_ENV##*/}"
    else
        venv=""
    fi
    [ -n "$venv" ] && echo " ($venv)"
}

ps1_status() {
    local last_status="$?"
    [ "$last_status" == "0" ] && echo '+' || echo '-'
}

# Disable the default virtualenv prompt change.
export VIRTUAL_ENV_DISABLE_PROMPT=1

ps1_right+="${reset}${bold}${vim_color}\$(ps1_vim)${reset}"
ps1_right+="${reset}${bold}${ranger_color}\$(ps1_ranger)${reset}"
ps1_right+="${reset}${bold}${venv_color}\$(ps1_venv)${reset}"

# git-prompt.sh provides __git_ps1 that is used to show current Git branch
# in bash prompt.
git_prompt_file='/usr/share/git/completion/git-prompt.sh'
if [ -f "$git_prompt_file" ]; then
    # Add a '$' in the __git_ps1 output to show stashed changes
    # are present.
    export GIT_PS1_SHOWSTASHSTATE=1
    # Show unstaged (*) and staged (+) changes next to the branch name.
    export GIT_PS1_SHOWDIRTYSTATE=1
    # Indicate difference between HEAD and its upstream.
    export GIT_PS1_SHOWUPSTREAM="auto"

    source "$git_prompt_file"
    ps1_right+="${reset}${bold}${git_color}\$(__git_ps1)${reset}"
fi

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

# Aliases and functions {{{

# Add main bash aliases.
_source_if_exists "$HOME/.bash_aliases"
# Add  functions.
_source_if_exists "$HOME/.bash_functions"
# Add local (untracked) bash aliases.
_source_if_exists "$HOME/.bash_aliases.local"
# Add docker aliases.
_source_if_exists "$HOME/.docker_aliases"
# Add lab aliases.
_source_if_exists "$HOME/.lab_aliases"

# }}}
