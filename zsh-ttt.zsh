function zsh-ttt() {
    local rbuf="$RBUFFER"
    BUFFER=$(cli-ttt -l -q <<< "$LBUFFER")
    CURSOR=$#BUFFER
    BUFFER="$BUFFER$rbuf"
}

zle -N zsh-ttt
bindkey '\ej' zsh-ttt
