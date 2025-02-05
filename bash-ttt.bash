function bash-ttt-old() {
    local lbuf=$(cut -b 1-$READLINE_POINT <<< "$READLINE_LINE")
    local rbuf=$(cut -b $(expr $READLINE_POINT + 1)- <<< "$READLINE_LINE")
    local buf=$(cli-ttt -l -q -- "$lbuf")
    READLINE_LINE="$buf$rbuf"
    READLINE_POINT=$(expr $(wc -c <<< "$buf") - 1)
}

function bash-ttt() {
    local lbuf="${READLINE_LINE:0:$READLINE_POINT}"
    local rbuf="${READLINE_LINE:$READLINE_POINT}"
    local buf="$(cli-ttt -l -q -- "$lbuf")"
    READLINE_LINE="$buf$rbuf"
    READLINE_POINT=${#buf}
}

if [ $BASH_VERSINFO -gt 3 ]
then
    bind -x '"\ej": bash-ttt'
fi
