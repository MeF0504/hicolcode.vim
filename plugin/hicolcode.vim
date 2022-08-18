" Name:         hicolcode.vim
" Description:  vim plugin that highlight color codes in lines.
" Author:       MeF

if exists('g:loaded_hicolcode')
    finish
endif
let g:loaded_hicolcode = 1

command! -range ColCode <line1>,<line2>call hicolcode#hicolcode()
command! ColCodeClear call hicolcode#clear()

if get(g:, 'hicolcode_auto_enable', 0)
    autocmd VimEnter * ++once call hicolcode#auto_enable()
endif

