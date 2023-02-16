#!/bin/bash

[[ -f ~/.bashrc ]] && . ~/.bashrc

################################################################################
# Completion
################################################################################

# Bash completion
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# Beets bash completion
if hash beet 2>/dev/null; then
    eval "$(beet completion)"
fi

# ssh/scp/sftp completion for known hosts
if [[ -e ~/.ssh/known_hosts ]]; then
    complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq )" ssh scp sftp
fi
