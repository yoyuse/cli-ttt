function bash-ttt() {
    local lbuf=$(cut -b 1-$READLINE_POINT <<< "$READLINE_LINE")
    local rbuf=$(cut -b $(expr $READLINE_POINT + 1)- <<< "$READLINE_LINE")
    local buf=$(cli-ttt <<< "$lbuf")
    READLINE_LINE="$buf$rbuf"
    READLINE_POINT=$(expr $(wc -c <<< "$buf") - 1)
}

if [ $BASH_VERSINFO -gt 3 ]
then
    bind -x '"\ej": bash-ttt'
fi
