echo 'executing ~/.bashrc'

set -o vi
shopt -s checkwinsize

#Terminal colors
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

if [ `id -un` = root ]; then
    PS1='\[\033[1;31m\]\h:\w\$\[\033[0m\] '
else
    PS1='\[\033[1;32m\]\h:\w\$\[\033[0m\] '
fi

xset b off
export TERM=xterm-256color

#If this file exists, execute it
if [ -f ~/.bash_files/.bash_exports ]; then
    . ~/.bash_files/.bash_exports
fi

case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#Add aliases if the file exists
if [ -f ~/bash_files/.aliases ]; then
    . ~/bash_files/.aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

