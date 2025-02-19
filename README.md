# cli-ttt

`cli-ttt` は、コマンドライン上の TT-code 変換ツールです。

## インストール

`cli-ttt` (Perl スクリプト) を `$PATH` 内のディレクトリに配置します。

例:

``` shellsession
$ mkdir -p $HOME/bin
$ git clone https://github.com/yoyuse/cli-ttt.git
$ cp cli-ttt/cli-ttt $HOME/bin/
```

補助変換を利用するには辞書が必要です。
[kanchoku/tc](https://github.com/kanchoku/tc) の `tcode` ディレクトリから以下のファイルを入手して `$HOME/tcode/` に配置してください。

- 部首合成変換に必要: `bushu.rev`, `symbol.rev`
- 交ぜ書き変換に必要: `pd_kihon.yom`, `jukujiku.maz`, `greece.maz`
- 異体字変換に必要: `itaiji.maz`

`mazegaki.dic` は必要ありません

例:

``` shellsession
$ mkdir -p $HOME/tcode
$ git clone https://github.com/kanchoku/tc.git
$ cd tc/tcode
$ cp bushu.rev greece.maz itaiji.maz jukujiku.maz pd_kihon.yom symbol.rev $HOME/tcode/
```

## 使用法

``` shellsession
$ cli-ttt [OPTIONS] [--] [STRING ...]
```

コマンドライン引数の TT-code 文字列 *STRING* を日本語に変換します (`echo` モード)。
引数が与えられなかったときは、標準入力を変換します (`cat` モード)。

例:

``` shellsession
$ cli-ttt 'ysksjsks/ajgjdjfkdt8p3;gpzjshdjtighdiakslghdhgiajd'
わたしたちは、氷砂糖をほしいくらいもたないでも、

$ echo 'yfkd% Iha-Tovo kd,fhrjaoajrksqrjd%' | cli-ttt -m %
あの Iha-Tovo のすきとおった風、

$ cli-ttt -m % 'yd.djtjshdjfoxhgw7ig;eks% Morio:/vjd%'
うつくしい森で飾られた Morio市、
```

変換は [ttt.el](https://github.com/yoyuse/ttt) と同様です。
文字列の末尾から先頭に向かって TT-code 文字列を検索し、最初に見つかったものを変換します。

半角英数字と TT-code 文字列の間は、スペースを入れてください。
スペースを空けたくないところは、コロン `:` で区切ります。
区切りの `:` は変換後に削除されます。

`-m` *MARKER* オプションが与えられたときは *MARKER* の各位置で [ttt.el](https://github.com/yoyuse/ttt) と同様の変換を行います。

### コマンドラインオプション

| オプション | 意味 |
|--------|---------|
| `-h` | 使用法を表示して終了する |
| `-i` | 対話的に候補を選択する |
| `-m` *MARKER* | *MARKER* の各位置で変換を行う |
| `-n` | 改行文字を出力しない (`echo` モードのとき) |
| `-q` | コードヘルプを表示しない |
| `-v` | バージョンを表示して終了する |
| `-w` | 文字列全体を変換する |

### *MARKER* 文字列

*MARKER* 文字列は、通常の ASCII 文字や、以下のエスケープ文字列を含むことができます。

| 文字列 | 意味 |
|----------|---------|
| `\a` | ベル |
| `\b` | バックスペース |
| `\e` | エスケープ |
| `\f` | 改ページ |
| `\n` | 改行 |
| `\r` | 復帰 |
| `\t` | タブ |
| `\\` | バックスラッシュ |
| `\`*ooo* | 8 進表記 |
| `\x`*hh* | 16 進表記 |
| `\c`*C* | コントロール文字 |

たとえば `$ cli-ttt -m '\ej'` は *MARKER* 文字列に `ESC j` を設定します。
`'\033j'` や `'\x1bj'` や `'\c[j'` も同様です。

## 補助変換

部首合成変換と交ぜ書き変換 (異体字変換を含む) が使えます。

### 部首合成変換

`jfjf` に続く 2 文字が合成されます。

- 例: `jfjf` `pw` `ha` → `森`

`-i` オプションを指定した場合は `森<jfox>` のように、標準エラー出力にコードヘルプが表示されます。
ヘルプの表示を抑制するには `-q` オプションを指定します。

合成できない場合は `jfjf` は `◆` となって残ります。

- 例: `jfjf` `l4` `z/` → `◆漢字`

### 交ぜ書き変換

`fjfj` に続く読み (漢字を含んでいてもよい) が変換されます。

- 例: `fjfj` `ml` `1f` `hr` → `完璧`

変換候補が複数ある場合は、端末 (tty) に候補が表示されます。
番号で選択し `RET` を押下すると入力できます。

例:

``` shellsession
$ echo 'fjfjjendz/' | cli-ttt -i
[かん字]
1 換字
2 漢字
>> 2
漢<l4>字
漢字
```

変換は単語変換です。
活用する語は、活用語尾を除いた読み (語幹) で変換してください。
変換できない場合は `fjfj` は `◇` となって残ります。

例:

``` shellsession
$ echo 'fjfjkd.uhdks' | cli-ttt -i
◇のぞいた
$ echo 'fjfjkd.u' | cli-ttt -i
[のぞ]
1 除
2 覗
3 望
4 臨
>> 1
除<;5>
除
```

異体字変換を含んでいます。

- 例: `fjfj` `eg` → `廣`

## Tips

### 区切り

区切り `:` は、変換の際に ASCII 文字と日本語の境界を示す文字列です。

区切りは変換後に削除されます。
区切りを残したいときは `::` のようにタイプしてください (ただし `:` が区切りと解釈されないところでは、その必要はありません)。

例:

| 入力 | 結果|
|----|----|
| `http:mwnsleyrkw`  | `httpプロトコル`   |
| `http::mwnsleyrkw` | `http:プロトコル`  |
| `http: mwnsleyrkw` | `http: プロトコル` |

### 再帰的な補助変換

再帰的な補助変換が可能です。

- 例: `jfjf` `pg` `jfjf` `pw` `pw` → `淋`

### 交ぜ書き変換の読みの範囲

交ぜ書き変換では、通常 `fjfj` から文字列の終端までを読みとして扱いますが、読みの終わりに `・<lf>` (活用しない語) または `—<kc>` (活用する語) を付加することで、読みの範囲を指定できます。

例:

``` shellsession
$ echo 'fjfj,fhrhxkcjrksfjfjje;3lfjd' | cli-ttt -i
¤◇すき通—った[かぜ]、
1       風
2       風邪
>> 1
透<jfu;>き通 風<qr>
透き通った風、
```

## 利用例 (コマンドライン編集)

対話シェルのコマンドライン編集で `<a-j>` (`Alt`+`j`) で TT-code 日本語変換を行う設定例です。

### Bash

``` bash
function bash-ttt() {
    local lbuf="${READLINE_LINE:0:$READLINE_POINT}"
    local rbuf="${READLINE_LINE:$READLINE_POINT}"
    local buf="$(cli-ttt -q -- "$lbuf")"
    READLINE_LINE="$buf$rbuf"
    READLINE_POINT=${#buf}
}

if [ $BASH_VERSINFO -gt 3 ]
then
    bind -x '"\ej": bash-ttt'
fi
```

### Zsh

``` zsh
function zsh-ttt() {
    local rbuf="$RBUFFER"
    BUFFER=$(cli-ttt -q -- "$LBUFFER")
    CURSOR=$#BUFFER
    BUFFER="$BUFFER$rbuf"
    zle && zle reset-prompt
}

zle -N zsh-ttt
bindkey '\ej' zsh-ttt
```

### Fish

``` fish
function fish-ttt
    set -l rbuf (string sub -s (math (commandline -C) + 1) -- (commandline))
    set -l lbuf (cli-ttt -q -- (commandline -c))
    set -l cursor (string length -- "$lbuf")
    commandline -- "$lbuf$rbuf"
    commandline -C $cursor
    commandline -f repaint
end

bind \ej fish-ttt
```

### 候補選択

変換候補が複数の場合、変換結果は `/` で区切られた候補リストになります。
候補リストに続けてさらに入力することで、選択や確定などが行えます。

例:

``` shellsession
# 「かんじ」を変換する例。複数の候補に展開される
$ echo fjfjjendux<a-j>
$ echo ¤[かんじ]/完治/寛治/幹事/感じ/換字/漢字/監事/

# <a-j> で左に 1 つシフトする
$ echo ¤[かんじ]/完治/寛治/幹事/感じ/換字/漢字/監事/<a-j>
$ echo ¤[かんじ]/寛治/幹事/感じ/換字/漢字/監事/完治/

# /<a-j> で右に 1 つシフトする
$ echo ¤[かんじ]/完治/寛治/幹事/感じ/換字/漢字/監事//<a-j>
$ echo ¤[かんじ]/監事/完治/寛治/幹事/感じ/換字/漢字/

# <space><a-j> で先頭の候補を選択して確定する
$ echo ¤[かんじ]/完治/寛治/幹事/感じ/換字/漢字/監事/<space><a-j>
$ echo 完治

# 4<a-j> で 4 番目の候補を選択して確定する
$ echo ¤[かんじ]/完治/寛治/幹事/感じ/換字/漢字/監事/4<a-j>
$ echo 感じ

# 0<a-j> で最後の候補を選択して確定する
$ echo ¤[かんじ]/完治/寛治/幹事/感じ/換字/漢字/監事/0<a-j>
$ echo 監事

# -2<a-j> で右から 2 番目の候補を選択して確定する
$ echo ¤[かんじ]/完治/寛治/幹事/感じ/換字/漢字/監事/-2<a-j>
$ echo 漢字
```

### 後置型変換

読みに続けて `<space><a-j>` で後置型変換を行います。

- 読みが 1 文字の場合は、異体字変換 + 交ぜ書き変換
- 読みが 2 文字の場合は、部首合成変換 + 交ぜ書き変換
- 読みが 3 文字以上の場合は、交ぜ書き変換

例:

``` shellsession
# 「糸」を変換すると、異体字の「絲」になる
$ echo ei<space><a-j>
$ echo 絲

# 「糸糸」を変換すると、部首合成 (「糸 + 糸」) により「絲」になる
$ echo eiei<space><a-j>
$ echo 絲

# 候補が候数の場合は確定しない。上記の 候補選択 の操作で確定させる
$ echo hdja<space><a-j>
$ echo ¤[いと]/伊都/意図/厭/糸/
```

### コードヘルプ

`-q` オプションを指定しない場合は `漢字¤?漢<l4>字<z/>?` のように、コードヘルプが表示されます。
コードヘルプはさらに `<a-j>` を入力すると消去できます。

## ライセンス

MIT
