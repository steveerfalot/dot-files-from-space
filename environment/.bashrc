set -o vi

shopt -s checkwinsize
shopt -s globstar

PS1="\[$(tput bold)\]\[$(tput setaf 1)\]\t\n"
PS1+="\[$(tput setaf 2)\]\u@\h \w\[$(tput sgr0)\] "
# PS1+="( $(git_color) )"
PS1+="\[$(tput setaf 6)\]\[$(tput bold)\] \$ "
PS1+="\[$(tput sgr0)\]"

xset b off
export TERM=linux

dot_files=$(find ${HOME}/env_files/alias/ -type f -name '*.*')

for filename in ${dot_files}; do
  . ${filename}
done

case $- in
  *i*) ;;
    *) return;;
esac

HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
## why is "want" in double quotes? -Parks 01-
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ -x /usr/bin/dircolors ]; then
  test -r ${HOME}/.dircolors && eval "$(dircolors -b ${HOME}/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -e  ~/env_files/functions/bash ]
then
  files=~/env_files/functions/bash/*
  for fl in ${files}
  do
    source "$fl"
  done
fi

export PHP_PEAR_BIN_DIR="/etc/php"

# For nvm in case you had it installed already
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
