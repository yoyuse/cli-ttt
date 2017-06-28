# cli-ttt

`cli-ttt` is a Tiny TT-Code Translation program for command-line interface,
written in Ruby.

## Usage

``` console
$ cli-ttt [options] [--] [string ...]
```

`cli-ttt` decodes each T-Code strings given as command line arguments
to Japanese text (`echo` mode).
If no argument is provided, `cli-ttt` decodes standard input (`cat` mode).

Some examples:

``` console
$ cli-ttt 'ysksjsks/ajgjdjfkdt8p3;gpzjshdjtighdiakslghdhgiajd'
わたしたちは、氷砂糖をほしいくらいもたないでも、

$ echo 'yfkd% Iha-Tovo kd,fhrjaoajrksqrjd%' | cli-ttt -m %
あの Iha-Tovo のすきとおった風、

$ cli-ttt -m % <<< 'yd.djtjshdjfoxhgw7ig;eks% Morio:/vjd%'
うつくしい森で飾られた Morio市、
```

Decode is done as well as [ttt.el](https://github.com/yoyuse/ttt);
that is, `cli-ttt` scans string from tail to head,
finds first valid T-Code string and decode it to Japanese.

If `-m` *marker* option is given,
`cli-ttt` does ttt decode at each position in strings where *marker* appears.

### Command line options

| Option | Description |
|--------|---------|
| `-m` *marker* | Decode at each position of *marker* |
| `-n` | Do not output newline (when `echo` mode) |
| `-w` | Decode whole string rather than à la ttt |

### Marker string

Marker string can include normal ASCII characters and following sequences:

| Sequence | Description |
|----------|---------|
| `\a` | Bell |
| `\b` | BackSpace|
| `\e` | Escape |
| `\f` | Form feed |
| `\n` | Newline |
| `\r` | Carriage return |
| `\t` | Tab |
| `\\` | Backslash |
| `\`*ooo* | Octal character |
| `\x`*hh* | Hexadecimal character |
| `\c`*C* | Control character |

For example, `$ cli-ttt -m '\ej'` sets marker to `Esc j`.
Either `'\033j'`, `'\x1bj'` or `'\c[j'` works as well.

## Sample scripts

With following configuration,
ttt-like Japanse input can be done with <kbd>Alt</kbd>+<kbd>j</kbd>
on command line of interactive shell.

### Bash

~/.bashrc (Bash 4 or later is required):

``` shell
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
```

### Zsh

~/.zshrc:

``` shell
function zsh-ttt() {
    local rbuf="$RBUFFER"
    BUFFER=$(cli-ttt <<< "$LBUFFER")
    CURSOR=$#BUFFER
    BUFFER="$BUFFER$rbuf"
}

zle -N zsh-ttt
bindkey '\ej' zsh-ttt
```

## License

MIT
