function zsh-ttt() {
    local rbuf="$RBUFFER"
    BUFFER=$(cli-ttt <<< "$LBUFFER")
    CURSOR=$#BUFFER
    BUFFER="$BUFFER$rbuf"
}

zle -N zsh-ttt
bindkey '\ej' zsh-ttt
