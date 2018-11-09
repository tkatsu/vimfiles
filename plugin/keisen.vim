scriptencoding utf-8
"=============================================================================
"File:         keisen.vim
"Author:       AKUTSU toshiyuki <locrian@mbd.ocn.ne.jp>
"Description:
"              `Keisen' is a Japanese word.
"              The meaning is `ruled-line' in English.
"Id:           $Id: keisen.vim,v 3.38 2003-07-29 18:18:18+09 ta Exp $
"=============================================================================
" :Keisen          罫線モードの開始。
" :Keisen --help   ヘルプを表示。
" :Keisen #        罫線文字種を `#' にする。
"
" h                カーソル左に "-" を書く。
" j                カーソル下に "|" を書く。
" k                カーソル上に "|" を書く。
" l                カーソル右に "-" を書く。
" m                罫線文字種の変更。
" <Space>          描画モードと消去モードの切り替え。
" <Esc>            罫線モードの終了。
"
"History:
"  2016-03-06 勝山
"       (1) 半角カナがあるとズレるのでその対策。
"  2011-03-10 勝山
"       (1) tab を含む行を左右に移動する際の不具合を修正した。
"  2008-09-04 勝山
"	(1) utf-8 対応した。
"       (2) tab を含む行も空白文字に変換することにより、罫線を引けるよ
"       うにした。同時に set list をやめた。
"
"=============================================================================

if exists("loaded_keisen")
    finish
endif
let loaded_keisen=1

"=============================================================================
"Commands:
command! -nargs=? Keisen :call <SID>Map(<q-args>)

"=============================================================================
"Variables:

let s:left=0
let s:down=1
let s:up=2
let s:right=3

let s:north=2
let s:south=1
let s:west=0
let s:east=3

let s:re_m_north='[│┌┐├┬┤┼┃┏┓┣┳┫╋]'
let s:re_m_south='[│┘└├┤┴┼┃┛┗┣┫┻╋]'
let s:re_m_west= '[─┌└├┬┴┼━┏┗┣┳┻╋]'
let s:re_m_east= '[─┐┘┬┤┴┼━┓┛┳┫┻╋]'

let s:re_north='[|+]'
let s:re_south='[|+]'
let s:re_west='[-+]'
let s:re_east='[-+]'

let s:draw=1
let s:multibyte=0
let s:keisen_type=0
let s:user_char=''
let s:user_specified=0

"v332
let s:keisen_init_type=0
if exists('keisen_type')
    if keisen_type =~# '^[012]$'
        let s:keisen_init_type=keisen_type
    endif
endif


"=============================================================================
function! s:Map(...)
    if a:1 =~# '--help\>'
        call s:Help()
        return
    endif
    nnoremap <silent> <buffer> h :call <sid>Keisen(0)<cr>
    nnoremap <silent> <buffer> j :call <sid>Keisen(1)<cr>
    nnoremap <silent> <buffer> k :call <sid>Keisen(2)<cr>
    nnoremap <silent> <buffer> l :call <sid>Keisen(3)<cr>
    nnoremap <silent> <buffer> m :call <sid>ChangeKeisenType()<cr>
    nnoremap <silent> <buffer> b :call <sid>ToggleBold()<cr>
    nnoremap <silent> <buffer> <Space> :call <sid>ToggleMode()<cr>
    nnoremap <silent> <buffer> <Esc> :call <sid>Unmap()<cr>

    let s:set_list=&list
    "if s:set_list==0
    "    set list
    "endif
    " tab を空白に変換できるようにする
    let s:set_expandtab = &expandtab
    set expandtab

    let s:draw=1
    "let s:multibyte=0
    let s:keisen_type=s:keisen_init_type
    let s:user_specified=0

    if a:1 =~# '-h'
        let s:keisen_type=0
    elseif a:1 =~# '-z'
        let s:keisen_type=1
    elseif a:1 =~# '-Z'
        let s:keisen_type=2
    endif
    "v326
    let params=substitute(a:1, '\C\s*-[hzZ]\s*','','')
    if params =~# '^.$'
        let s:user_specified=1
        let s:user_char=params
        let s:multibyte =(char2nr(s:user_char) > 0xff)
        let s:keisen_type=s:multibyte
    endif
    call s:InitVars()

endfunction

function! s:Unmap()
    call s:DrawCoupler(-1)

    nunmap <buffer> h
    nunmap <buffer> j
    nunmap <buffer> k
    nunmap <buffer> l
    nunmap <buffer> m
    nunmap <buffer> b
    nunmap <buffer> <Space>
    nunmap <buffer> <Esc>
    if s:set_list==0
        set nolist
    endif
    if s:set_expandtab == 0
	set noexpandtab
    endif
endfunction

function! s:Help()
echo 'SYNOPSIS:'
echo '               :Keisen [options]'
echo 'OPTIONS:'
echo '-h             半角罫線'
echo '-z             全角罫線'
echo '-Z             全角太字罫線'
echo '任意の１文字   任意の文字罫線'
echo ' '
echo 'let keisen_type=1 を ~/.vimrc に書くと、デフォルトの罫線が全角になります。'
echo 'let keisen_type=2 だと全角太字罫線になります。'
echo ' '
echo '実行中のキー:'
echo ' h             カーソル左に "-" を書く。'
echo ' j             カーソル下に "|" を書く。'
echo ' k             カーソル上に "|" を書く。'
echo ' l             カーソル右に "-" を書く。'
echo ' m             罫線文字種の変更。(任意の文字罫線の場合、使用不可)'
echo ' b             太字と標準のトグル。(任意の文字罫線の場合、使用不可)'
echo ' <Space>       描画モードと消去モードの切り替え。'
echo ' <Esc>         罫線モードの終了。'
endfunction

"=============================================================================
function! s:ToggleMode()
    let s:draw = (s:draw + 1) % 2
    call s:InitVars()
endfunction

function! s:ChangeKeisenType()
    if s:user_specified==1
        return
    endif
    let s:keisen_type = (s:keisen_type + 1) % 3
    let s:draw=1
    call s:InitVars()
endfunction

function! s:ToggleBold()
    if s:user_specified==1
        return
    endif
    let s:keisen_type=((s:keisen_type != 2) ? 2 : 1)
    let s:draw=1
    call s:InitVars()
endfunction

function! s:InitVars()
    if s:keisen_type == 0
        let s:multibyte=0
        if s:draw==0
            let s:vertical=' '
            let s:horizontal=' '
        elseif s:user_specified==1
            let s:vertical=s:user_char
            let s:horizontal=s:user_char
        else
            let s:vertical='|'
            let s:horizontal='-'
        endif
        let s:re_north='[|+]'
        let s:re_south='[|+]'
        let s:re_west='[-+]'
        let s:re_east='[-+]'
    else
        let s:multibyte=1
        if s:draw==0
            let s:vertical='　'
            let s:horizontal='　'
        elseif s:user_specified==1
            let s:vertical=s:user_char
            let s:horizontal=s:user_char
        elseif s:keisen_type == 1
            let s:vertical='│'
            let s:horizontal='─'
        else
            let s:vertical='┃'
            let s:horizontal='━'
        endif
        let s:re_north=s:re_m_north
        let s:re_south=s:re_m_south
        let s:re_west= s:re_m_west
        let s:re_east= s:re_m_east
    endif

endfunction
"End: s:InitVars()
"


"=============================================================================
" 文字が半角カナかどうか調べる。UTF-8 の場合、半角カナはマルチバイトなので。
function! s:IsHankakuKana(one_char)
    let charcode = char2nr(a:one_char)
    if charcode >= 0xff61 && charcode <= 0xff9f
        return 1
    else
        return 0
    endif
endfunction

"=============================================================================
"   引数で指定された文字列の、画面上のカラム位置(virtual column)を、バイト数に
"   よるカラム位置に変換する。
"   utf-8 の場合、占有バイト数と表示文字幅が一致しない為、この処理が必要となる。
function! s:Vcol2byte(str, column)
    if a:column <= 1
	return 1
    endif
    "  先頭から一文字づつその文字が占有するバイト数を数え、画面上のカラム位置
    "  に対応するバイト位置を探す。
    let len_str = strlen(a:str)
    let vcol_num = 0
    let byte_num = 0
    let start_pos = 0
    while  byte_num < len_str 
	let one_char = matchstr(a:str, '.', start_pos)
	let len_char = strlen(one_char)
	if len_char >= 2 && !(s:IsHankakuKana(one_char))
	    if (vcol_num + 2)  >= a:column
		break
	    endif
	    let vcol_num = vcol_num + 2
	else
	    let vcol_num = vcol_num + 1
        endif
	let byte_num = byte_num + len_char
	let start_pos = start_pos + len_char
	if (vcol_num + 1)  >= a:column
	    break
	endif
    endwhile
    return byte_num + 1
endfunction
"End: s:Vcol2byte()
"
"=============================================================================
" カーソル位置を、画面上のカラム位置(virtual column)で指定した場所にする。
"   cursor() 関数の第二引数の column はバイト数で指定するので utf-8 の文字を含んでいる
" 行だとカーソルの位置がズレてしまう為、この処理が必要となる。
function! s:Vcursor(lineno, column)
    let cline = getline(a:lineno)
    call cursor(a:lineno, s:Vcol2byte(cline, a:column))
endfunction
"End: s:Vcursor()

"=============================================================================
" カーソルの画面上のカラム位置(virtual column)をとりだす。
" utf-8 の文字を含んでいると col(".") の戻り値が画面上の位置と異なる。
" また、virtcol() はカーソル上の文字がマルチバイト文字ならその文字の後端位置を
" 返すのでその補正も行う。
function! s:Virtcol(pos)
    let vcolumn = virtcol(a:pos)

    " カーソル下の一文字取り出し、マルチバイト文字か調べる
    let acolumn = col(a:pos)
    let cline=strpart(getline(a:pos), acolumn - 1)
    let one_char = matchstr(cline, '^.')
    let len_char = strlen(one_char)

    " マルチバイト文字の場合は、virtcol() が文字の後端位置を返すので
    " 先端位置になるよう減算する。
    if len_char >= 2 && !(s:IsHankakuKana(one_char))
	return vcolumn - 1
    else
	return vcolumn
    endif
endfunction
"End: s:Virtcol()

"=============================================================================
function! s:Keisen(direction)

    let lineno=line(".")
    let column=s:Virtcol(".")

    if lineno==1 && a:direction==s:up
        call append(0, " ")
        let lineno=2
        call s:Vcursor(lineno, column)
    elseif lineno==line("$") && a:direction==s:down
        call append(lineno, " ")
        call s:Vcursor(lineno, column)
    endif

    if a:direction == s:up
        exec '-1retab'
        call s:DrawCoupler(s:up)
        call s:FillColumn(lineno - 1, column)
    elseif a:direction==s:down
        exec '+1retab'
        call s:DrawCoupler(s:down)
        call s:FillColumn(lineno + 1, column)
    elseif a:direction==s:right
        exec '.retab'
        call s:DrawCoupler(s:right)
        call s:FillColumn(lineno, column + 1)
    elseif a:direction==s:left
        if column==1 | return | endif
        exec '.retab'
        call s:DrawCoupler(s:left)
    endif

    call s:Vcursor(lineno, column)
    call s:DrawLine(a:direction, lineno,  column)

endfunction
"=============================================================================
function! s:DrawLine(direction, lineno, column)

    if a:direction == s:west
        call s:ReplaceChar(s:horizontal, a:lineno, a:column - 1 - s:multibyte)
    elseif a:direction == s:east
        call s:ReplaceChar(s:horizontal, a:lineno, a:column + 1 + s:multibyte)
    elseif a:direction == s:south
        call s:ReplaceChar(s:vertical, a:lineno + 1, a:column)
    else
        call s:ReplaceChar(s:vertical, a:lineno - 1, a:column)
    endif

endfunction
"=============================================================================
function! s:DrawCoupler(d)
    if s:draw==0 | return | endif
    if s:vertical ==# s:horizontal
        return
    endif
    let lineno=line(".")
    let column=s:Virtcol(".")
    let north=(a:d==s:north)
    let south=(a:d==s:south)
    let west=(a:d==s:west)
    let east=(a:d==s:east)

    if north==0
        call s:Vcursor(lineno - 1, column)
        if s:Virtcol(".")==column
            let cline=getline(lineno - 1)
            let cline=strpart(cline, s:Vcol2byte(cline, column) - 1)
            let north =(cline =~# '^' . s:re_north)
        endif
    endif

    if south==0
        call s:Vcursor(lineno + 1, column)
        if s:Virtcol(".")==column
            let cline=getline(lineno + 1)
            let cline=strpart(cline, s:Vcol2byte(cline, column) - 1)
            let south =(cline =~# '^' . s:re_south)
        endif
    endif

    let neighbor=''
    let cline = getline(lineno)
    if column > 1
        let neighbor=matchstr(strpart(cline,0, s:Vcol2byte(cline, column) - 1), '.$')
        let neighbor=neighbor . strpart(cline, s:Vcol2byte(cline, column) - 1)
        "s:multibyte=1 or 0
        if west == 0
            let west = (neighbor =~# '^' . s:re_west)
        endif
        if east == 0
            let east = (neighbor =~# '^..' . s:re_east)
        endif
    else
        if east == 0
            let east = (cline =~ '^.' . s:re_east)
        endif
    endif


    call s:Vcursor(lineno, column)
    if s:multibyte==0
        if north==1 || south==1
            if west==1 || east==1
                call s:ReplaceChar('+', lineno, column)
            endif
        else
            if north==1 || south==1
                call s:ReplaceChar('+', lineno, column)
            endif
        endif

        return
    endif

    "--------------------
    let sum=north + south + west + east
    if &encoding == 'utf-8'
	let mbyte_width = 3
    else
	let mbyte_width = 2
    endif

    let i=((s:keisen_type==1) ? 0 : mbyte_width)
    if sum==2
        if west
            if north==1
                call s:ReplaceChar(strpart('┘┛',i,mbyte_width), lineno, column)
            elseif east
                call s:ReplaceChar(strpart('─━',i,mbyte_width), lineno, column)
            else
                call s:ReplaceChar(strpart('┐┓',i,mbyte_width), lineno, column)
            endif
        elseif north
            if east
                call s:ReplaceChar(strpart('└┗',i,mbyte_width), lineno, column)
            else
                call s:ReplaceChar(strpart('│┃',i,mbyte_width), lineno, column)
            endif
        else
			call s:ReplaceChar(strpart('┌┏',i,mbyte_width), lineno, column)
        endif
    elseif sum==3
        if north==0
		    call s:ReplaceChar(strpart('┬┳',i,mbyte_width), lineno, column)
        elseif south==0
			call s:ReplaceChar(strpart('┴┻',i,mbyte_width), lineno, column)
        elseif west==0
			call s:ReplaceChar(strpart('├┣',i,mbyte_width), lineno, column)
        else
			call s:ReplaceChar(strpart('┤┫',i,mbyte_width), lineno, column)
        endif
    elseif sum==4
        call s:ReplaceChar(strpart('┼╋',i,mbyte_width), lineno, column)
    endif
endfunction
"End: s:DrawCoupler()
"=============================================================================
function! s:FillColumn(lineno, column)
"v322
    call s:Vcursor(a:lineno, a:column)
    let len=s:Virtcol('$')-1
    if (len - s:Virtcol(".")) >= 3
        return
    endif
    let column3=a:column + 3
    let len=len+1
    let spaces=' '
    while len < column3
        let spaces = spaces . ' '
        let len = len + 1
    endwhile

    call setline(a:lineno, getline(a:lineno) . spaces)
    "call s:Vcursor(a:lineno, a:column)
endfunction
"End: s:FillColumn()
"=============================================================================
function! s:ReplaceChar(char, lineno, column)
    let byte=strlen(a:char)

    let acolumn=((a:column > 0) ? a:column : 1)

    call s:Vcursor(a:lineno, acolumn)
    let lineno = line(".")
    let column = s:Virtcol(".")
    let cline=getline(lineno)
    let cline=strpart(cline, s:Vcol2byte(cline, column)-1)
    let one_char1=matchstr(cline, '^.')
    let len_char1=s:IsHankakuKana(one_char1)?1: strlen(one_char1)
    let one_char2=matchstr(cline, '^.\zs.')
    let len_char2=s:IsHankakuKana(one_char2)?1: strlen(one_char2)
    if byte==1
        "a  - A         1
        "あ - As        2
       "あ  - sA        3
        if column == acolumn
            if len_char1 < 2
                exec 'normal! r' . a:char
            else
                exec 'normal! r' . a:char . "a \<esc>h"
            endif
        else
            exec 'normal! r a' . a:char . "\<esc>"
        endif

        return
    endif

    "byte==2
     "a$  - ん
     "aa  - ん
     "aあ - んs
     "あ  - ん
    "あ$  - sん  伸びる。
    "あa  - sん
    "ああ - sんs

    if column == acolumn
        if len_char1 < 2
            if len_char2 == 0
                exec 'normal! r' . a:char
            elseif len_char2 < 2
                exec 'normal! xr' . a:char
            else
                exec 'normal! R' . a:char . " \<esc>h"
            endif
        else
            exec 'normal! r' . a:char
        endif
    else
        if len_char2 < 2
            exec 'normal! R ' . a:char . "\<esc>"
        else
            exec "normal! R  \<esc>i" . a:char . "\<esc>"
        endif
    endif
endfunction
"End: s:ReplaceChar(char, lineno, column)
"=============================================================================
" vim:noic:
