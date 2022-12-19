#!/bin/bash

###########
# General #
###########
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

if [[ $OSTYPE == 'linux-gnu'* ]]; then # Linux settings
  # Map escape to capslock (`setxkbmap -option`
  # restores the mapping) Linux specific
  setxkbmap -option caps:escape

  ###########
  # EXPORTS #
  ###########
  export PATH="$PATH:~/Dev/apache-maven-3.8.6/bin"
  export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

  ###########
  # ALIASES #
  ###########
  alias supr='sudo apt update; sudo apt upgrade; sudo reboot'
fi

########
# MISC #
########
export EDITOR='vim'
export TERM='xterm-256color'
export PATH="$PATH:/usr/local/bin:$HOME/.local/bin"
export IPYTHONDIR="$HOME/.dotfiles/ipython"

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

###########
# HISTORY #
###########
# Append to the Bash history file, rather than overwriting
shopt -s histappend 2> /dev/null


export HISTFILE="$HOME/.bash_history"
# Hide some commands from the history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help";

# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignorespace:erasedups"

# Give history timestamps.
export HISTTIMEFORMAT="[%F %T] "

# Lots o' history.
export HISTSIZE=10000
export HISTFILESIZE=10000

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

alias vi='vim'

if [ -f /usr/bin/xdg-open ]; then
    alias open='/usr/bin/xdg-open'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bjf='bundle install && bundle exec jekyll serve | firefox --new-tab --url http://localhost:4000/'
alias py2='python2'
alias py3='python3'
alias ipy='ipython3'

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
yellow=$(tput setaf 3)
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
brightpink=$(tput setaf 199)
pink=$(tput setaf 217)

##########
# Prompt #
##########
function virtualenv_info(){
  # Get Virtual Env
  if [[ -n "$VIRTUAL_ENV" ]]; then
      # Strip out the path and just leave the env name
      venv="${VIRTUAL_ENV##*/}"
  else
      # In case you don't have one activated
      venv=''
  fi
  [[ -n "$venv" ]] && echo "(pyv:$venv)"
}

# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

if [[ "$USER" == "root" ]]; then
  prompt_r=$brightred
  prompt_g=$brightgreen
  prompt_b=$brightblue
  prompt_x=$brightpink
elif [[ "$SSH_TTY" ]]; then
  prompt_r=$red
  prompt_g=$green
  prompt_b=$blue
  prompt_x=$pink
else
  prompt_r=$red
  prompt_g=$green
  prompt_b=$blue
  prompt_x=$pink
fi

if [[ -n "$SSH_CONNECTION" ]]; then
    user_name="$USER@"
    host_name="$HOSTNAME:"
else
    host_name=""
    user_name=""
fi

export PS1='\n\[$reset\]🐷\[$prompt_x\][$user_name$host_name$PWD]\[$reset\]\n'

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  export PS1+='\[$prompt_b\]$(__git_ps1 "(git:%s)")'
fi

export PS1+='\[$prompt_r\]$(virtualenv_info)\[$reset\]\
\[$prompt_g\]\$\[$reset\] '

#############
# Functions #
#############

function cdb() {
    for (( i=1; i<=$1; i++ ))
    do
        cd ..
    done
}

function so() { # source py env
    source ~/Venvs/$1/bin/activate
}

# Search in files
function sif() {
    grep -EiIrl "$*" .
}

# Colored man pages
function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

function cl() {
    local dir="$1"
    local dir="${dir:=$HOME}"
    if [[ -d "$dir" ]]; then
        cd "$dir" >/dev/null; ls
    else
        echo "bash: cl: $dir: Directory not found"
    fi
}

##########
# Jekyll #
##########
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
