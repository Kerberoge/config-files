# /etc/bash/bashrc.d/color.sh

alias ls='ls --color --group-directories-first'
alias grep='grep --color'
alias diff='diff --color'

C1='\[\e[38;5;130m\]'
C2='\[\e[38;5;84m\]'
C3='\[\e[38;5;220m\]'
C4='\[\e[38;5;117m\]'
RS='\[\e[0m\]'
export PS1="$C1[$C2\h$RS:$C3\w$C1]$C4\\$ $RS"
unset C1 C2 C3 C4 RS
