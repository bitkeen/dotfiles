export EDITOR=/usr/bin/vim


##################################################
# Prompt
##################################################

tan="\[$(tput setaf 180)\]"
red3="\[$(tput setaf 124)\]"
cornsilk1="\[$(tput setaf 230)\]"
grey30="\[$(tput setaf 239)\]"
bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"

ps1_left="${reset}${bold}\w${reset}" # working directory
ps1_right=""
# ps1_arrow=" ${reset}${bold}${tan}>${reset} " # Tan
ps1_arrow=" ${reset}${bold}${red3}>${reset} " # Red3

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

# ps1_right="${reset}${bold}${cornsilk1}\$(ps1_ranger)\$(ps1_venv)${reset}"
ps1_right="${reset}${bold}${grey30}\$(ps1_ranger)\$(ps1_venv)${reset}"

# Modify the prompt when using SSH.
if [ -n "$SSH_CLIENT" ]; then
    ps1_u_at_h="${reset}${bold}\u@\h " # user@host
    ps1_left="${ps1_u_at_h}${ps1_left}"
    # ps1_right+=" ${reset}${bold}${cornsilk1}(ssh)${reset}"
    ps1_right+=" ${reset}${bold}${grey30}(ssh)${reset}"
fi

export PS1="${ps1_left}${ps1_right}${ps1_arrow}"


##################################################
# Aliases
##################################################

# Add main bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi


##################################################
# ranger
##################################################

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
