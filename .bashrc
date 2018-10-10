if [[ $HOSTNAME = sts* ]]; then
  if [[ -z $STARTED_SCREEN ]] && [[ -n $SSH_TTY ]]; then
    if [[ $- = *i* ]]; then
      STARTED_SCREEN=1; export STARTED_SCREEN
      screen -RR -S ssh || echo >&2 "Screen failed! continuing with normal bash startup"
    fi
  fi
fi

###################################################

# Nice commands:
# - s-tui
# - cmatrix

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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
force_color_prompt=yes

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

##################################

# alias ll='ls -al'
alias vi='vim'
# export PATH="~/opt/cmake-3.12.0-Linux-x86_64/bin:$PATH"
# export CMAKE_ROOT=/home/mstanek/opt/cmake-3.12.0-Linux-x86_64/bin/cmake
export GTEST_COLOR=1
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
shopt -s histappend
export EDITOR=vim

alias v='vim'
# alias ls='ls -hN --color=auto --group-directories-first'
# alias ll='ls -hNal --color=auto --group-directories-first'
alias grep='grep --color=auto'
#alias cls='printf "\e\143"' # Use ^L instead
export EDITOR=vi
export TIME_STYLE=long-iso
# set -o vi
# bind -m vi-insert "\C-l":clear-screen
shopt -s autocd

### Prompt Configuration ######################################################

COLS=`tput cols`
LEN=54
AL=$(($((COLS - LEN)) / 2 ))
AR=

ps1_git_branch() {
	br=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [[ ! -z $br ]]; then
		echo -en "\u2500\u2528\e[31;1m$br\e[0m\u2520"
	fi
}
ps1_common() {
  echo -n $'\u2520\u2500\u2528\e[1;34m'
  echo -n $(date +%F)
  echo -n $'\e[0m\u2520\u2500\u2528\e[1;34m'
  echo -n $(date +%X)
  echo -n $'\e[0m\u2520'
  echo -n $(ps1_git_branch)
  echo -n $'\u2500\u2528\e[1;33m'
  PROMPT_DIRTRIM=3
  #pwd=$(pwd)
  #pwd_prefix=
  #while (( ${#pwd} > 40 )); do
  #  pwd=${pwd#*/}
  #  pwd_prefix=.../
  #done
  #echo -n $pwd_prefix$pwd
  echo -n '\w'
  echo $'\e[0m\u2520\u257c\n\u2570\u257c '
}
ps1_default() {
  echo -n $'\n\u256d\u2500\u2528$(s=$?; if [[ $s == 0 ]]; then echo "\e[1;32m$s\e[0m"; else echo "\e[1;31m$s\e[0m"; fi)'
  echo -n $(ps1_common)
  echo -n '\w'
}
#ps1_initial() {
#  echo 1
#}

#export PS1="\w\$ "
#export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
PS1=$'\n\u256d\u2500\u2528$(s=$?; if [[ $s == 0 ]]; then echo "\e[1;32m$s\e[0m"; else echo "\e[1;31m$s\e[0m"; fi)\u2520\u2500\u2528\e[1;34m$(echo $(date +%F))\e[0m\u2520\u2500\u2528\e[1;34m$(echo $(date +%X))\e[0m\u2520$(ps1_git_branch)\u2500\u2528\e[1;33m\w\e[0m\u2520\u257c\n\u2570\u257c '
#PS1=$(ps1_default)

### Various PATH entries ######################################################

PATH=$PATH:/home/mstanek/bin
PATH=$PATH:/opt/gcc-arm-none-eabi/bin
PATH=$PATH:/opt/eclipse/eclipse

### ISE WebPack ###############################################################

# source <(cat /opt/Xilinx/14.7/ISE_DS/settings64.sh | grep -v '^\s*echo')
# PATH=$PATH:/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64

### Quartus ###################################################################

# PATH=$PATH:~/intelFPGA_lite/17.0/quartus/bin
# PATH=$PATH:~/intelFPGA_lite/17.0/modelsim_ase/bin
# export QSYS_ROOTDIR="/home/mstanek/intelFPGA_lite/17.0/quartus/sopc_builder/bin"

### ModelSim SE ###############################################################

#export LM_LICENSE_FILE=:1717@wv-lic-03.wv.mentorg.com:1717@wv-lic-01.wv.mentorg.com:1717@wv-lic-02.wv.mentorg.com:1717@wv-lic-04.wv.mentorg.com:1717@wv-lic-05.wv.mentorg.com:1718@wv-lic-snpslmd.wv.mentorg.com:1717@vanginkel.ies.mentorg.com:1718@vanginkel.ies.mentorg.com
export LM_LICENSE_FILE=1717@150.254.21.65
PATH=/opt/modelsim/modeltech/bin:$PATH

### ROS #######################################################################

# source /opt/ros/kinetic/setup.bash
# source ~/robor_ws/devel/setup.bash
# source ~/mozgotron/devel/setup.bash

### youBot ####################################################################

# alias rbr_rostart='ssh -t youbot@yb_pc "cd ~/robor_ws/src/robor_utilities/resources/systemd && sudo ./rostart.sh &"'
# alias rbr_start='rbr_odometry'
# alias rbr_simulator='roslaunch robor_utilities robor_simulator.launch'
# alias rbr_odometry='source $HOME/robor_ws/src/robor_utilities/scripts/start.sh use_odometry'
# alias rbr_optitrack='source $HOME/robor_ws/src/robor_utilities/scripts/start.sh use_optitrack'
# alias rbr_amcl='source $HOME/robor_ws/src/robor_utilities/scripts/start.sh use_map'
# alias rbr_mapping='source $HOME/robor_ws/src/robor_utilities/scripts/start.sh do_mapping'
# alias rbr_connect='ssh youbot@yb_pc'
# alias rbr_env='source $HOME/robor_ws/src/robor_utilities/scripts/user_env.sh'
# alias rbr_shutdown='ssh -t youbot@yb_pc "sudo systemctl poweroff"'
# alias rbr_reboot='ssh -t youbot@yb_pc "sudo systemctl reboot"'

###############################################################################
