# If not running interactively, don't do anything
case $- in
    *i*) ;;
*) return;;
esac



# PS1 Prompt
################################################################################
# Add git branch if its present to PS1
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
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



# COLOR
################################################################################
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


LS_COLORS='di=01;34:fi=0:ln=33:pi=5:so=5:bd=5:cd=5:or=37:mi=0:ex=91:*.rpm=90:*.deb=92:*.run=1;92:*.png=34:*.jpg=94:*.JPG=94:*.JPEG=94:*.xcf=34:*.tiff=1;34:*.TIFF=1;34:*.gif=1;94:*.aux=90:*.bib=34:*.log=1;90:*.pdf=1;93:*.tex=33:*.zip=31:*.tar.gz=91:*.tar.bz2=91:*.exe=1;94;100:*.doc=1;94;100:*.xlsx=1;94;100:*.xls=1;94;100:*.pptx=1;94;100:*.nb=31:*.math=91:*.m=31:*.py=93:*.sh=92:*.rb=95:*.pl=1;94:*.c=31:*.h=91:*.cc=93:*.cpp=93:*.md=1;33:*README=1;33:*LICENSE=33:*.txt=93:*.ipynb=1;33:*.mp3=31:*.mp4=91:*.mov=1;91:*.html=95:*.js=35:*.css=1;95:*rc=32:*config=1;32:*makefile=1;91'


#History
################################################################################


# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups  
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

## reedit a history substitution line if it failed
shopt -s histreedit
## edit a recalled history line before executing
shopt -s histverify


# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000


# bash completion
################################################################################
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



################################################################################


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# Yeah! vi !! 
export EDITOR=/usr/bin/vim
set -o vi

export MAKEFLAGS="-j8"



# ALIASES
################################################################################
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# I don't want everything on the internet
if [ -f ~/.private_bashrc ]; then
    . ~/.private_bashrc
fi

export GOBY_HDF5_PLUGIN="/home/ams/src/ams-core/core/lib/libams_hdf5plugin.so"

export PATH="~/src/ams-core/core/bin/:$PATH"

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/arcgis/runtime_sdk/qt10.2.6/sdk/linux/x64/lib
export LD_LIBRARY_PATH
