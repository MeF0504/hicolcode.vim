" Name:         hicolcode.vim
" Description:  vim plugin that highlight color codes in lines.
" Author:       MeF

let s:match_cnt = 0

function! s:ret_colcode(line, index)
    let ptrn = tolower(a:line[a:index:a:index+6])
    let r = str2nr(ptrn[1:2], 16)
    let g = str2nr(ptrn[3:4], 16)
    let b = str2nr(ptrn[5:6], 16)
    let pat = join(map(split(ptrn, '\zs'),
                \ 'v:val==#toupper(v:val)?v:val:"[".v:val.toupper(v:val)."]"'), '')

    return [[r, g, b], pat]
endfunction

function! s:cvt_fullcolor_256(r, g, b) abort
    let r = (a:r-55)/40
    if r < 0 | let r = 0 | endif
    let g = (a:g-55)/40
    if g < 0 | let g = 0 | endif
    let b = (a:b-55)/40
    if b < 0 | let b = 0 | endif

    return 36*r+6*g+b+16
endfunction

function! s:is_dark(r, g, b) abort
    " refer RGB -> YUV conversion equation
    let w_r = 0.299
    let w_g = 0.587
    let w_b = 0.114
    let thsd = 135.0
    " echo printf('a:r:%d, a:g:%d, a:b:%s, => %.2f, < %.2f', a:r, a:g, a:b, (a:r*w_r+a:g*w_g+a:b*w_g)/(w_r+w_g+w_b), thsd)

    return (a:r*w_r+a:g*w_g+a:b*w_g)/(w_r+w_g+w_b)<thsd
endfunction

function! hicolcode#hicolcode() abort range
    if !exists('w:hicolcode_match_id')
        let w:hicolcode_match_id = {}
    endif
    let colcode_config = [
                \ {
                    \ 'ptrn': '#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]',
                    \ 'func': expand('<SID>')..'ret_colcode',
                    \ } ]
    if exists('g:hicolcode_config')
        if has_key(g:hicolcode_config, '_')
            let colcode_config += g:hicolcode_config._
        endif
        if has_key(g:hicolcode_config, &filetype)
            let colcode_config += g:hicolcode_config[&filetype]
        endif
    endif

    for lnum in range(a:firstline, a:lastline)
        let line = getline(lnum)
        for config in colcode_config
            let st = 0
            while 1
                let idx = match(line, config.ptrn, st)
                if idx == -1
                    break
                endif
                let [rgb, match_ptrn] = call(config.func, [line, idx])
                if empty(rgb)
                    let st += 1
                    continue
                endif
                let [r, g, b] = rgb
                if !has_key(w:hicolcode_match_id, match_ptrn)
                    if s:is_dark(r, g, b)
                        let cfg = 255
                        let gfg = 'White'
                    else
                        let cfg = 232
                        let gfg = 'Black'
                    endif
                    execute printf('highlight ColCode%d ctermfg=%s ctermbg=%s guifg=%s guibg=#%02x%02x%02x',
                                \ s:match_cnt, cfg, s:cvt_fullcolor_256(r, g, b), gfg, r, g, b)
                    let match_id = matchadd('ColCode'..s:match_cnt, match_ptrn, 15)
                    let w:hicolcode_match_id[match_ptrn] = match_id
                    let s:match_cnt += 1
                    if s:match_cnt >= 100
                        let s:match_cnt = 0
                    endif
                endif
                let st = matchend(line, config.ptrn, st)
            endwhile
        endfor
    endfor
endfunction

function! hicolcode#disable() abort
    augroup HiColCode
        autocmd!
    augroup END
    call hicolcode#clear()
endfunction

function! hicolcode#clear() abort
    if !exists('w:hicolcode_match_id')
        return
    endif

    for match_id in values(w:hicolcode_match_id)
        call matchdelete(match_id)
    endfor
    let w:hicolcode_match_id = {}
endfunction

function! <SID>hicolcode_auto(ran) abort
    let pos = getpos('.')
    execute printf("%scall hicolcode#hicolcode()", a:ran)
    call setpos('.', pos)
endfunction

function! hicolcode#auto_enable() abort
    call <SID>hicolcode_auto('%')
    augroup HiColCode
        autocmd!
        autocmd BufWinEnter * call <SID>hicolcode_auto("%")
        autocmd CursorMoved * call <SID>hicolcode_auto("")
    augroup END
endfunction

