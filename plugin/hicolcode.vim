" Name:         hicolcode.vim
" Description:  vim plugin that highlight color codes in lines.
" Author:       MeF

if exists('g:loaded_hicolcode')
    finish
endif
let g:loaded_hicolcode = 1

command! -range ColCode <line1>,<line2>call hicolcode#hicolcode_enable()
command! ColCodeDisable call hicolcode#hicolcode_disable()

