" Name:         hicolcode.vim
" Description:  vim plugin that highlight color codes in lines.
" Author:       MeF

if exists('g:loaded_hicolcode')
    finish
endif
let g:loaded_hicolcode = 1

command! -range ColCode <line1>,<line2>call hicolcode#hicolcode_enable()
command! ColCodeDisable call hicolcode#hicolcode_disable()

if get(g:, 'hicolcode_auto_enable', 0)
    augroup HiColCode
        autocmd!
        autocmd VimEnter * ++once call hicolcode#hicolcode_auto()
        autocmd InsertLeave * call hicolcode#hicolcode_auto()
    augroup END
endif

