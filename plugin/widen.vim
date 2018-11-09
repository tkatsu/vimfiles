scriptencoding utf-8
" Visual Select された範囲の文字間にスペースを挿入して、文字列を広げる、など。
"                                      	by T. Katsuyama   2006-11-30
vnoremap ,wi "ey:call Widen()<CR>
vnoremap ,na "ey:call Narrow()<CR>
vnoremap ,en "ey:call Enforce()<CR>

function! Widen()
    let @e = substitute(@e, '\(\S\)', '\1 ', 'g')
    let @e = substitute(@e, '\s\+$', '', '')
    exec "normal gvc" . @e
endfunction

" Visual Select された範囲のスペースを取り除く
function! Narrow()
    let @e = substitute(@e, '\s', '', 'g')
    exec "normal gvc" . @e
endfunction

function! Enforce()
    let @e = '**' . @e . '**'
    exec "normal gvc" . @e
endfunction
