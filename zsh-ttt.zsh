function zsh-ttt() {
    local CLI_TTT_COMMAND="${CLI_TTT_COMMAND:-cli-ttt -l -q --}"
    local rbuf="$RBUFFER"
    BUFFER=$(${=CLI_TTT_COMMAND} "$LBUFFER")
    CURSOR=$#BUFFER
    BUFFER="$BUFFER$rbuf"
    zle && zle reset-prompt
}

zle -N zsh-ttt
bindkey '\ej' zsh-ttt
