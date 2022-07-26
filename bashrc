# If not running interactively, don't do anything
[[ $- != *i* ]] && return

###########
# General #
###########

# Map escape to capslock (`setxkbmap -option` restores the mapping)
setxkbmap -option caps:escape

# Auto "cd" when entering just a path
shopt -s autocd 2> /dev/null

# Line wrap on window resize
shopt -s checkwinsize 2> /dev/null

# Case-insensitive tab completetion
bind 'set completion-ignore-case on'

# When displaying tab completion options, show just the remaining characters
bind 'set completion-prefix-display-length 2'

# Show tab completion options on the first press of TAB
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

########
# Path #
########

PATH=/usr/local/bin:$PATH

###########
# History #
###########

# Append to the Bash history file, rather than overwriting
shopt -s histappend 2> /dev/null

# Hide some commands from the history
#export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help";

# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignorespace:erasedups"

# Give history timestamps.
export HISTTIMEFORMAT="[%F %T] "

# Lots o' history.
export HISTSIZE=10000
export HISTFILESIZE=10000


###########
# Exports #
###########

export EDITOR="vim"

###########
# Aliases #
###########

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

alias ll='ls -lahF ${colorflag}'
alias lsa='ls -A'
alias lsd="ls ${colorflag} | /usr/bin/grep --color=never '^d'"
alias lsda="lsa | /usr/bin/grep --color=never '^d'"

alias grep='grep --color=auto -n -i'

alias clear="clear && printf '\e[3J'";

alias df="df -h"
alias du="du -h"

alias vim='nvim'
alias vi='nvim'

alias cdp='cd ~/Projects'

if [ -f /usr/bin/xdg-open ]; then
    alias open='/usr/bin/xdg-open'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

##########
# Colors #
##########

if dircolors > /dev/null 2>&1; then
	eval $(dircolors -b ~/.dircolors)
fi

reset=$(tput sgr0)
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 2)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
brightblack=$(tput setaf 8)
brightred=$(tput setaf 9)
brightgreen=$(tput setaf 10)
brightyellow=$(tput setaf 11)
brightblue=$(tput setaf 12)
brightmagenta=$(tput setaf 13)
brightcyan=$(tput setaf 14)
brightwhite=$(tput setaf 15)

##########
# Prompt #
##########

if [[ "$USER" == "root" ]]; then
	prompt_col_1=$brightred
	prompt_col_2=$red
elif [[ "$SSH_TTY" ]]; then
	prompt_col_1=$brightblue
	prompt_col_2=$blue
else
	prompt_col_1=$brightgreen
	prompt_col_2=$green
fi

PS1='\n\[$reset\]\[$prompt_col_1\]\u\[$reset\]@\[$prompt_col_2\]\h\[$prompt_col_1\]:\W'

if [ -f ~/.git-prompt.sh ]; then
	source ~/.git-prompt.sh
	export PS1+='\[$prompt_col_2\]$(__git_ps1 "(%s)")'
fi

PS1+='\[$reset\]\n\$ '

#############
# Functions #
#############

# Search in files
sif() {
grep -EiIrl "$*" .
}

# Colored man pages
man() {
env LESS_TERMCAP_mb=$'\E[01;31m' \
LESS_TERMCAP_md=$'\E[01;38;5;74m' \
LESS_TERMCAP_me=$'\E[0m' \
LESS_TERMCAP_se=$'\E[0m' \
LESS_TERMCAP_so=$'\E[38;5;246m' \
LESS_TERMCAP_ue=$'\E[0m' \
LESS_TERMCAP_us=$'\E[04;38;5;146m' \
man "$@"
}

cl() {
local dir="$1"
local dir="${dir:=$HOME}"
if [[ -d "$dir" ]]; then
    cd "$dir" >/dev/null; ls
else
    echo "bash: cl: $dir: Directory not found"
fi
}

if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
