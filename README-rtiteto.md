# rtiteto: Ruby/Titeto - TT-code incremental search a la Migemo

`rtiteto` (Ruby/Titeto) is Ruby-implemented Titeto,
a TT-code version of
[Migemo](http://0xcc.net/migemo/) or
[C/Migemo](https://www.kaoriya.net/software/cmigemo/)
([koron/cmigemo](https://github.com/koron/cmigemo)).

Using `rtiteto` along with
[osyo-manga/vim-vigemo](https://github.com/osyo-manga/vim-vigemo)
enables incremetal search of Japanese text in Vim
without TT-code conversion.

## Installation

First install [Shougo/vimproc.vim](https://github.com/Shougo/vimproc.vim),
required by `osyo-manga/vim-vigemo`.

Install `rtiteto` command in your `$PATH`:

``` shellsession
mkdir -p ~/bin
cp cli-ttt.rb rtiteto.rb ~/bin/
ln -s rtiteto.rb ~/bin/rtiteto
```

Clone `osyo-manga/vim-vigemo` as `vim-titeto`
and modify so that it use `rtiteto` command instead of `cmigemo`:

``` shellsession
mkdir -p ~/.vim/pack/github/start/
git clone https://github.com/osyo-manga/vim-vigemo.git ~/.vim/pack/github/start/vim-titeto
cd ~/.vim/pack/github/start/vim-titeto

shopt -s globstar

perl -i -pe 's/cmigemo/rtiteto/g;' **/*.vim
perl -i -pe 's/Migemo/Titeto/g; s/migemo/titeto/g;' **/*.vim **/*.vital
perl -i -pe 's/Vigemo/Titeto/g; s/vigemo/titeto/g;' **/*.vim **/*.vital

for f in $(find . -name '*Migemo*'); do mv $f $(echo $f | sed -e 's/Migemo/Titeto/g'); done
for f in $(find . -name '*vigemo*'); do mv $f $(echo $f | sed -e 's/vigemo/titeto/g'); done
```

## Usage

Add key map in your `vimrc` file:

``` vim
nmap <Leader>/ <Plug>(titeto-search)
```

Type `<Leader>/kryglp;gfy7y` to search `日本語を検索`.

## Tips

- Put a `<Space>` between ASCII and TT-code in search string;
  `<Leader>/Vim<Space>mwus/xmf,d` searches `Vimプラグイン`.
- Unlike in original Migemo searching,
  there is no need to capitalize words to search 連文節, 用言 or 活用形.

## Known Issues

- Cannot search wrapped text
- Cannot search kanji by its yomi, katakana by hiragana,
  zenkaku by hankaku, etc.
- Cannot search katakana word by its English spelling

## License

MIT
