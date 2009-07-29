# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# {{{ General setup

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_colored_prompt=yes

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
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# General setup }}}

# {{{ Alias definitions
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# utils
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -al'
alias l='ls -CF'
alias rm='rm -i'
alias cp='cp -i'

# system
alias psa='ps aux | grep'
alias sk='sudo killall'
alias sk9='sudo kill -9'

alias 'cd..'='cd ..'

# apt-get
alias up='sudo aptitude update'
alias upg='sudo aptitude safe-upgrade'
alias uu='up && upg'
alias i='sudo aptitude install'
alias ri='sudo aptitude reinstall'
alias r='sudo aptitude remove'
alias s='sudo aptitude search'
alias show='sudo aptitude show'

# vim
function myvim {
    if [ "$#" -eq "0" ]; then
        /usr/bin/vim --servername vim
    else
        if echo "$*" | grep -q -- "--servername" ; then
            /usr/bin/vim $*
        else
            /usr/bin/vim --servername vim --remote-tab-silent $*
        fi
    fi
}

function mygvim {
    if [ "$#" -eq "0" ]; then
        /usr/bin/gvim --servername vim
    else
        if echo "$*" | grep -q -- "--servername" ; then
            /usr/bin/gvim $*
        else
            /usr/bin/gvim --servername vim --remote-tab-silent $*
        fi
    fi
}

alias vi=myvim
alias vim=myvim
alias gvim=mygvim
alias gv=mygvim
alias sv='sudo vim'
alias sgv='sudo gvim'
alias sgvim='sudo gvim'

# dev
alias gcc='gcc -pedantic -W -Wall -lm'
alias 'gcc+ansi'='gcc -ansi'
alias 'gcc+c99'='gcc -std=c99'
alias gfortran='gfortran -pedantic -Wextra -Wall -fimplicit-none -Wunused -ftrapv -fexceptions'
alias g95='gfortran -std=f95'
alias g2003='gfortran -std=f2003'
alias irb='irb1.8'

# git
alias 'git-remove'='git update-index --force-remove'

# LaTeX
# alias pour gérer epstopdf avec TEXLive
alias  pdflatex='pdflatex --shell-escape'
# LaTeX personnal packages and conf directories
# the trailing colon indicates the standard search path should be appended
# double trailing slash indicates this directory is to be search recursively
#export TEXHOME=".:~//:"
export TEXINPUTS=".:~/texmf//:"

# ruby switch
alias ruby-switch-1.8='sudo ln -fs /usr/bin/ruby1.8                           /usr/bin/ruby &&
                       sudo ln -fs /usr/bin/irb1.8                            /usr/bin/irb  &&
                       sudo ln -fs /usr/bin/gem1.8                            /usr/bin/gem  &&
                       sudo ln -fs /var/lib/gems/1.8/gems/rake-0.8.7/bin/rake /usr/bin/rake'

alias ruby-switch-1.9='sudo ln -fs /opt/ruby1.9/bin/ruby1.9.1 /usr/bin/ruby &&
                       sudo ln -fs /opt/ruby1.9/bin/irb1.9.1  /usr/bin/irb  &&
                       sudo ln -fs /usr/local/bin/gem1.9.1    /usr/bin/gem  &&
                       sudo ln -fs /opt/ruby1.9/bin/rake      /usr/bin/rake'

# Alias }}}

# Export {{{

#export RUBYOPT=rubygems
export PATH=$PATH:/home/jd/opt:/opt/ruby1.9/bin

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# http://www.clavier-dvorak.org/wiki/Utilisation_avec_X.Org
export GTK_IM_MODULE=xim

# https://help.ubuntu.com/community/GnuPrivacyGuardHowto
export GPGKEY=692C50E8

# }}}

# {{{ Notification

# http://doc.ubuntu-fr.org/laptop_mode
echo 'Penser à contrôler le Load_Cycle_Count (74074 et des poussières le 19/05/2008)'
#echo 'sudo hdparm -B 254 /dev/sda le 15/05/2008'
#echo 'Le Load_Cycle_Count ne doit plus (trop) bouger'
echo "sudo smartctl -a `mount | grep '/ ' | cut -d' ' -f1 | sed -e 's#[0-9]##'` | egrep 'Cycle|Power'"

#sudo sh /usr/bin/fortune_bashfr.sh

# Notification }}}

# a two-lines prompt
PS1="\n\[\e[35;1m\]\u@\h \[\e[37;1m\][\w]\[\e[34;1m\]\n\$ \[\e[0m\]"

