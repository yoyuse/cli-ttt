function bash-ttt() {
    local IFS=$' \t\n'
    local CLI_TTT_COMMAND="${CLI_TTT_COMMAND:-cli-ttt -q --}"
    local lbuf="${READLINE_LINE:0:$READLINE_POINT}"
    local rbuf="${READLINE_LINE:$READLINE_POINT}"
    local buf="$($CLI_TTT_COMMAND "$lbuf")"
    READLINE_LINE="$buf$rbuf"
    READLINE_POINT=${#buf}
}

if [ $BASH_VERSINFO -gt 3 ]
then
    bind -x '"\ej": bash-ttt'
fi
