"=============================================================================
" File:          pascal-matchit.vim
" Author:        AKUTSU toshiyuki <locrian@mbd.sphere.ne.jp> 
" Requirements:  Vim version 6.1 and later
" Description:   Matchit for Pascal.
"                Map "%" to move from one keyword to its matching keyword in
"                Pascal files.
" Installation: 
"     (Linux)    $HOME/.vim/ftplugin/pascal/matchit.vim
"     (Windows)  %HOME%\vimfiles\ftplugin\pascal\matchit.vim
"             or %VIM%\vimfiles\ftplugin\pascal\matchit.vim
"
"                $ mkdir -p ~/.vim/ftplugin/pascal
"                $ cp pascal-matchit.vim ~/.vim/ftplugin/pascal/matchit.vim
"                $ vim a.pas
"
"=============================================================================
" $Id: pascal-matchit.vim,v 1.11 2002-12-17 09:03:30+09 ta Exp $
"=============================================================================
if v:version < 601 | finish | endif
if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin=1
"=============================================================================
"Commands And Keymappings:
nnoremap <buffer> <silent> % :call <SID>PascalMatchIt(0)<CR>
vnoremap <buffer> <silent> % <Esc>:call <SID>PascalMatchIt(1)<CR>
"let tmp = expand("<sfile>:p")
"command! Whop :echo "$Id: pascal-matchit.vim,v 1.11 2002-12-17 09:03:30+09 ta Exp $\n" . tmp

"=============================================================================
" Load Once:
if exists("s:loaded_pascal_matchit") | finish | endif
let s:loaded_pascal_matchit=1

"d:/lang/editor/a.pas
"=============================================================================
"Variables:

let s:re_matchwords = '\c\<\%(begin\|end\|until\|try\|repeat\|record' . 
                   \  '\|interface\|dispinterface\|asm\)\>' .
                   \  '\|\<case\>.\{-1,}\<of\>\|\<class\>[^;]*\_$'

let s:re_subs = '\<\%(except\|finally\|published\|public\|protected\|private\)\>'

let s:re_keywords= s:re_matchwords . '\|' . s:re_subs
let s:re_close='\c^\%(end\|until\)$'
let s:re_syntax='\c\<pascal\%(Statement\|Repeat\|Label\|Conditional\|Struct' . 
              \ '\|Exception\|Access\=\|Operator\|AsmKey\)\>'

let s:synid=-999
"=============================================================================
"Functions:
function! s:PascalMatchIt(visual)
    if getline(".")[col(".")-1] =~# '[][(){}]'
        if a:visual
            normal! gv%
        else
            normal! %
        endif
        return
    endif
    if a:visual
        let vmode = visualmode()
    endif

    if ! s:Preprocess() | return | endif

    let i = line(".") - winline() + 1 + &scrolloff
    let restore = "normal! " . i . "Gzt`x"

    normal! mxviw"xy`<my
    if @x !~# s:re_close
        let rt = s:Forward()
    else
        let rt = s:Backward()
    endif
    if rt==0
        exe restore
        call s:ShowMsg( "`" . @x . "' doesn't have its matching keyword.", 1)
    elseif a:visual
        exe "normal! mz`y" . vmode . "`z"
    endif
endfunction
"end s:PascalMatchIt()
"=============================================================================
function! s:Preprocess()
    " Is Syntax Enable:
    if ! exists("b:current_syntax")
        call s:ShowMsg("b:current_syntax doesn't exist, do :syntax on", 0)
        return 0
    elseif b:current_syntax !~# '\c^pascal$'
        call s:ShowMsg("b:current_syntax isn't pascal, do :set filetype=pascal", 0)
        return 0
    elseif ! s:IsCursorOn(s:re_keywords)
        call s:ShowMsg("No matching rule applies here", 0)
        return 0
    elseif ! s:IsCursorOnSyntax()
        call s:ShowMsg("The cursor isn't on " . s:re_syntax . ' syntax group', 1)
        return 0
    endif
    return 1
endfunction
" end s:Preprocess()
"=============================================================================
function! s:IsCursorOn(regex)
    let s:matchdata=""
    let column = col(".")-1
    let cline = getline(".")
    let matchstart = 0
    let mtop = match(cline, a:regex, matchstart)
    while mtop != -1
        let mend = matchend(cline, a:regex, matchstart)
        if mtop <= column && mend > column
            "Found:
            return 1
        elseif mtop == mend
            return 0
        endif
        let matchstart = mend
        let mtop = match(cline, a:regex, matchstart)
    endwhile
    return 0
endfunction
"end s:IsCursorOn()
"-----------------------------------------------------------------------------
function! s:IsCursorOnSyntax()
    let id = synID(line("."), col("."), 1)
    if id == s:synid
        return 1
    elseif synIDattr(id, "name") =~# s:re_syntax
        let s:synid = id
        return 1
    endif
    return 0
endfunction
"end s:IsCursorOnSyntax()
"-----------------------------------------------------------------------------
function! s:Forward()
    let stacksize=1
    let linenr = search(s:re_matchwords, "W")
    while linenr > 0
        if s:IsCursorOnSyntax()
            normal! viw"zy
            if @z =~# s:re_close
                let stacksize = stacksize - 1
                if stacksize == 0
                "Found:
                    return 1
                endif
            else
                let stacksize = stacksize + 1
            endif
        endif
        let linenr = search(s:re_matchwords, "W")
    endwhile
    return 0
endfunction
"end s:Forward()
"-----------------------------------------------------------------------------
function! s:Backward()
    let stacksize=1
    let linenr = search(s:re_matchwords, "bW")
    while linenr > 0
        if s:IsCursorOnSyntax()
            normal! viw"zy`<
            if @z =~# s:re_close
                let stacksize = stacksize + 1
            else
                let stacksize = stacksize - 1
                if stacksize == 0
                "Found:
                    return 1
                endif
            endif
        endif
        let linenr = search(s:re_matchwords, "bW")
    endwhile
    return 0
endfunction
"end s:Backward()
"-----------------------------------------------------------------------------
function! s:ShowMsg(msg, confirm_redraw)
    if ! exists('b:pascal_matchit_redraw')
        let b:pascal_matchit_redraw=0
    endif
    if a:confirm_redraw==0 || b:pascal_matchit_redraw==1
        redraw!
        echohl WarningMsg | echo a:msg | echohl NONE
        return
    endif

    let msg = a:msg . "\nDo you want to redraw ? (y/n) :"

    let b:pascal_matchit_redraw=1
    redraw!
    let rt=input(msg, "")
    if rt !~# '\c^y' | return | endif

    let i = line(".") - winline() + 1 + &scrolloff
    let restore = "normal! " . i . "Gzt`y"
    exe "normal! my1G\<C-l>"
    let eof = line("$")
    while line(".") < eof
        exe "normal! \<C-f>"
        redraw!
    endwhile
    exe restore

endfunction
"end s:ShowMsg()
"-----------------------------------------------------------------------------
