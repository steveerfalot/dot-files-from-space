# .bashrc

shopt -s checkwinsize

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

if [ `id -un` = root ]; then
    PS1='\[\033[1;31m\]\h:\w\$\[\033[0m\] '
else
    PS1='\[\033[1;32m\]\h:\w\$\[\033[0m\] '
fi

alias cls='clear'
alias c='clear'
alias clls='clear; ls'
alias ll='ls -ahlF --group-directories-first'
alias lsa='ls -altr'
alias lsg='ls | grep'
alias ls='ls --color'
alias k='kill -9'
alias gotoConf='cd /usr/local/bullhorn/conf'
alias gotoTomcat='cd /bullhorn/tomcat/instance1/logs'
alias gotoTomcat2='cd /bullhorn/tomcat/instance2/logs'
alias gotoTomcat3='cd /bullhorn/tomcat/instance3/logs'
alias bounceTomcats='initctl restart ats-tomcat && initctl restart ats-tomcat2'
alias logs1='tail -f /bullhorn/tomcat/instance1/logs/server.log'
alias logs2='tail -f /bullhorn/tomcat/instance2/logs/server.log'
alias logs3='tail -f /bullhorn/tomcat/instance3/logs/server.log'