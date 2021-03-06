" Name:         hicolcode.vim
" Description:  vim plugin that highlight color codes in lines.
" Author:       MeF

function! s:cvt_fullcolor_256(fullcolor) abort
    let r = str2nr(a:fullcolor[1:2], 16)
    let r = (r-55)/40
    if r < 0 | let r = 0 | endif
    let g = str2nr(a:fullcolor[3:4], 16)
    let g = (g-55)/40
    if g < 0 | let g = 0 | endif
    let b = str2nr(a:fullcolor[5:6], 16)
    let b = (b-55)/40
    if b < 0 | let b = 0 | endif

    return 36*r+6*g+b+16
endfunction

function! s:is_dark(fullcolor) abort
    let r = str2nr(a:fullcolor[1:2], 16)
    let g = str2nr(a:fullcolor[3:4], 16)
    let b = str2nr(a:fullcolor[5:6], 16)

    " refer RGB -> YUV conversion equation
    let w_r = 0.299
    let w_g = 0.587
    let w_b = 0.114
    let thsd = 135.0
    " echo printf('r:%d, g:%d, b:%s, => %.2f, < %.2f', r, g, b, (r*w_r+g*w_g+b*w_g)/(w_r+w_g+w_b), thsd)

    return (r*w_r+g*w_g+b*w_g)/(w_r+w_g+w_b)<thsd
endfunction

function! hicolcode#hicolcode_enable() abort range
    if !exists('w:colcode_match_id')
        let w:colcode_match_id = []
    endif
    let colcode_grep = '#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]'
    for lnum in range(a:firstline, a:lastline)
        let line = getline(lnum)
        let colcode_cnt = count(line, '#')
        for i in range(colcode_cnt)
            let colcode_idx = match(line, colcode_grep, 0, i+1)
            if colcode_idx == -1
                break
            endif
            let colcode = line[colcode_idx:colcode_idx+6]
            if s:is_dark(colcode)
                let cfg = 255
                let gfg = 'White'
            else
                let cfg = 232
                let gfg = 'Black'
            endif
            execute printf('highlight ColCode%s ctermfg=%s ctermbg=%s guifg=%s guibg=%s',
                        \ colcode[1:], cfg, s:cvt_fullcolor_256(colcode), gfg, colcode)
            let match_id = matchadd('ColCode'..colcode[1:], colcode, 15)
            call add(w:colcode_match_id, match_id)
        endfor
    endfor
endfunction

function! hicolcode#hicolcode_disable() abort
    if !exists('w:colcode_match_id')
        return
    endif

    for match_id in w:colcode_match_id
        call matchdelete(match_id)
    endfor
    let w:colcode_match_id = []
endfunction

