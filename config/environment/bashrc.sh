#!/bin/bash
####################################################################################
## convenience
####################################################################################
# aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sqlite3="rlwrap sqlite3" # enable sqlite3 to use command history
alias clean_cwd='find . -iname "*~" | while read f; do rm "$f"; echo "removed $f"; done' # remove orphaned files ending in ~
alias hadoop_stop="for service in /etc/init.d/hadoop*; do sudo \$service stop; done" # stop hadoop
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"' # alert long running commands.  Use: "sleep 10; alert"

# overrule git SSL noisy failures
export GIT_SSL_NO_VERIFY=1
export EDITOR="/usr/bin/gedit -w -s"

####################################################################################
## shell history
####################################################################################
# shell history
HISTCONTROL=ignoreboth # don't put duplicate lines in the history
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=1000 # set history size
HISTFILESIZE=2000 # history filesize

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

####################################################################################
## color profiles
####################################################################################
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ "$force_color_prompt" = yes ] || [ "$color_prompt" = yes ]; then
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


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
