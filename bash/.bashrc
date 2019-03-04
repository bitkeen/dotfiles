export EDITOR=/usr/bin/vim
export HISTTIMEFORMAT="%Y-%m-%d %T "

# Even though vi-mode is already set through readline configuration,
# still need to set it here for fzf default bindings to work.
set -o vi

# Source fzf-related files.
fzf_bindings_file="/usr/share/fzf/key-bindings.bash"
if [ -f "$fzf_bindings_file" ]; then
    source "$fzf_bindings_file"
fi
fzf_completion_file="/usr/share/fzf/completion.bash"
if [ -f "$fzf_completion_file" ]; then
    source "$fzf_completion_file"
fi

# Enable completion for git.
git_completion_file="/usr/share/bash-completion/completions/git"
if [ -f "$git_completion_file" ]; then
    source $git_completion_file

    # Make git completion work with an alias if it exists.
    git_alias=$(alias | awk '/git/ {print $2}' | cut -f 1 -d '=')
    if [ -n "$git_alias" ]; then
        complete -o default -o nospace -F _git $git_alias
    fi
fi

export PATH="$PATH:$HOME/.vim/bundle/vim-superman/bin"


##################################################
# Prompt
##################################################

bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"

arrow_color="\[$(tput setaf 124)\]"
ranger_color="\[$(tput setaf 96)\]"
venv_color="\[$(tput setaf 66)\]"
ssh_color="\[$(tput setaf 239)\]"
git_color="\[$(tput setaf 75)\]"

# Working directory.
ps1_left="${reset}${bold}\w${reset}"
ps1_right=""

# Modify the prompt when using a shell from inside ranger.
function ps1_ranger {
    if [ -n "$RANGER_LEVEL" ]; then
        ranger="in ranger"
    else
        ranger=""
    fi
    [ -n "$ranger" ] && echo " ($ranger)"
}

# Modify the prompt when using a virtual environment.
function ps1_venv {
    if [ -n "$VIRTUAL_ENV" ]; then
        # Strip out the path and just leave the env name.
        venv="${VIRTUAL_ENV##*/}"
    else
        venv=""
    fi
    [ -n "$venv" ] && echo " ($venv)"
}

# Disable the default virtualenv prompt change.
export VIRTUAL_ENV_DISABLE_PROMPT=1

ps1_right="${reset}${bold}${ranger_color}\$(ps1_ranger)${reset}"
ps1_right+="${reset}${bold}${venv_color}\$(ps1_venv)${reset}"

# Modify the prompt when using SSH.
if [ -n "$SSH_CLIENT" ]; then
    ps1_u_at_h="${reset}${bold}\u@\h " # user@host
    ps1_left="${ps1_u_at_h}${ps1_left}"
    ps1_right+=" ${reset}${bold}${ssh_color}(ssh)${reset}"
fi

# Last space is actually an nbsp. It is used for searching the
# previous command in tmux (see .tmux.conf).
ps1_arrow=" ${reset}${bold}${arrow_color}>${reset} "
ps1_right+=${ps1_arrow}

export PS1="${ps1_left}${ps1_right}"


##################################################
# Aliases
##################################################

# Add main bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Add local (untracked) bash aliases.
if [ -f ~/.bash_aliases.local ]; then
    source ~/.bash_aliases.local
fi

# Add docker aliases.
if [ -f ~/.docker_aliases ]; then
    source ~/.docker_aliases
fi


##################################################
# ranger
##################################################

# Avoid loading default config file for ranger if a custom one exists.
ranger_config_file="$HOME/.config/ranger/rc.conf"
if [ -f "$ranger_config_file" ]; then
    export RANGER_LOAD_DEFAULT_RC=FALSE
fi

# Automatically change the directory in bash after closing ranger.
# Source:
# https://github.com/ranger/ranger/blob/master/examples/bash_automatic_cd.sh
# The same script can be found locally:
# /usr/share/doc/ranger/examples/bash_automatic_cd.sh
#
# This is a function for automatically changing the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
