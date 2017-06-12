#!/bin/bash
#
# 2017-06-06 cli-ttt -n -Z <- cli-ttt -nZ
# 2017-06-02
# 2017-06-01

function bash-ttt() {
    local src=$(printf "$READLINE_LINE" | cut -b 1-$READLINE_POINT)
    local rest=$(printf "$READLINE_LINE" | cut -b $(expr $READLINE_POINT + 1)-)
    local dst=$(cli-ttt -n -Z <<< "$src")
    READLINE_LINE="$dst$rest"
    READLINE_POINT=$(expr $(printf "$dst" | wc -c))
}

if [ $BASH_VERSINFO -gt 3 ]
then
    bind -x '"\ej": bash-ttt'
else
    # XXX: bash 3 用の定義
    #      → バグってる (引数が「"」を含むと危険、カーソル位置を復元しない)
    # bind '"\ej": "\C-u`cli-ttt -nZ "\C-y"`\e\C-e"'
    :
fi

# == ref
# - Bash で (fish みたいな) カラフルなコマンドライン (ble.sh) - Qiita
# - http://qiita.com/akinomyoga/items/22bbf8029e6459ed57ba
# | READLINE_LINE は現在のコマンドラインの内容で、READLINE_POINT は現在のカーソルの位置です。(ただし 単位は文字数ではなく何故かバイト数: この仕様のせいで世の中の多くの bind -x を利用した機能が日本語で変なことになる気が…)。
#
# - bashのコマンドラインに日時を挿入 - Qiita
# - http://qiita.com/GHR/items/f871d189b4d8c651e5f6
#
# == ref: READLINE_LINE と READLINE_POINT は bash 4 (?) が必要
# - bash - $READLINE_LINE and $READLINE_POINT empty - Stack Overflow
# - https://stackoverflow.com/questions/39566090/readline-line-and-readline-point-empty
