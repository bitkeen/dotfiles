#!/usr/bin/env bash
# From https://github.com/ranger/ranger/wiki/Shell-aliases.

# EXPL: simplify when ranger-shell.sh -c $SHELL
if [[ $# == 2 && $1 == -c && ($2 == $SHELL || $2 == '$SHELL') ]]
then shift 2; fi

# EXPL: overwrite when SHELL=ranger-shell.sh
[[ -x /usr/bin/zsh ]] \
&& export SHELL='/usr/bin/env zsh' \
|| export SHELL='/usr/bin/env bash'

# USE: Interactive shell
(($#)) || exec ${SHELL:?}

# USE: Cmdline populated with aliases
[[ $1 != -c ]] || shift
exec ${SHELL:?} -c '
(( $(id -u) )) || HOME=/home/${SUDO_USER:-${USER:-${USERNAME:?}}}
source ~/.bash_aliases
source ~/.bash_aliases.local
[[ ${SHELL:?} =~ zsh$ ]] && setopt aliases || shopt -s expand_aliases
eval "$@"
' "$0" "$@"
