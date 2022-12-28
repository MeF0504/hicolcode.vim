# hicolcode.vim

Vim plugin that highlight color codes in lines.

![colcode](images/hicolcode1.png)

## Requirements

## Installation

- [dein](https://github.com/Shougo/dein.vim)
```vim
call dein#add('MeF0504/hicolcode.vim')
```
- [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'MeF0504/hicolcode.vim'
```
or do something like this.

## Usage

```vim
:ColCode
```
search for and highlight color codes in current line.  
The color code this plugin highlight is `#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]`,  
e.g. `#7d8fa4`, `#a47996`, `#00af5d`.

```vim
:ColCodeClear
```
clear all highlights set by this plugin.

`ColCode` command can specify the line number range.
If you want to highlight lines from 2 to 10, you can do this by
```vim
:2,10ColCode
```
or, if you want to highlight all lines in the current file, the following command is possible.
```vim
:%ColCode
```
## Options

- `g:hicolcode_auto_enable` (number)  
    If set 1, color codes are highlighted automatically.  
    default: 0
- `g:hicolcode_max_idx` (number)  
    The max number of highlight indexes. Bigger is better to avoid duplication, but maybe the processing becomes heavy.  
    default: 100

## License
[MIT](https://github.com/MeF0504/hicolcode.vim/blob/main/LICENSE)

## Author
[MeF0504](https://github.com/MeF0504)

