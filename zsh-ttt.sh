#!/bin/zsh
#
# 2017-06-06 cli-ttt -n -Z <- cli-ttt -nZ
# 2017-06-02
# 2017-06-01

function zsh-ttt() {
    local rbuf="${RBUFFER}"
    BUFFER=$(cli-ttt -n -Z <<< "${LBUFFER}")
    CURSOR=$#BUFFER
    BUFFER="$BUFFER${rbuf}"
}

zle -N zsh-ttt
bindkey '\ej' zsh-ttt
