"  sum.vim
"     calculate a value on each line and get the sum.
"     e.g
"            100
"            20*2 + 1
"            30/2
"     type   :Sum  or ,sum
"
"         Calculate 100 + 20*2 + 30/2
"         then, new lines is opened and you get the answer on it.
"            Total. 156
"            
"  Author:	Takeharu Katsuyama
"  Version:	0.1
"  History:
"    Ver. 0.1:   Initial release
" ---------------------------------------------------------------------
"
"" calculate expression on current line, pick a mapping, or use the Leader
noremap  ,sum "eyy:call SumLines(0)<CR>

"" calculate expression from selection, pick a mapping, or use the Leader form
vnoremap ,sum "ey:call SumLines(1)<CR>

" calculate expression from command line (by T.Katsuyama)
command! -range Sum <Line1>,<Line2>call Sum()

" ---------------------------------------------------------------------
"  Sum
"    start from command line.
function! Sum() range
    " if single line
    if a:firstline == a:lastline
	let @e = getline(a:firstline)
	call SumLines(0)

    " if not visualy selected
    elseif (a:firstline != line("'<")) || (a:lastline != line("'>"))
	echo "Select lines with Shift-V!!!"
	return
    else
	let lines = getline("'<", "'>")
	let @e = join(lines, "\n")
	call SumLines(1)
    endif
endfunction

" ---------------------------------------------------------------------
"  InsertCommas:
"    InserCommas every 3 digits with integer part  (by T.Katsuyama)
function! InsertCommas (s)
    let integers = a:s
    let times = strlen(integers)/3
    let integers = substitute (integers, '\(\x\{3}\)$', ',\1', "")
    let i = 1
    while  i < times
	let integers = substitute (integers, '\(\x\{3},\)', ',\1', "")
	let i += 1
    endwhile
    " remove ',' at the top
    let integers = substitute (integers, '^,', "", "")
    let integers = substitute (integers, '^-,', "-", "")
    return (integers)
endfunction

" ---------------------------------------------------------------------
" SumLines:
"
function! SumLines(vsl)
    " allow input of zenkaku string (convert input string to hankaku)
    if exists ("g:bccalc_input_allow_zenkaku")
	let input_allow_zenkaku= g:bccalc_input_allow_zenkaku
    else
	let input_allow_zenkaku= 0
    endif

    " Converting Zenkaku to Hankaku
    if input_allow_zenkaku == 1 &&  exists('*ToHankaku')
	let @e = ToHankaku(@e)
    endif

    " remove CR
    let @e = substitute (@e, "\r", "",   "g")

    let lines = split(@e, '\n', 1)
    let i = 0
    let str = ''
    let operator = ''
    while i < len(lines)
	let line = lines[i]
	let line = substitute (line, 'x', "*", "g")
	let line = substitute (line, '\', "", "g")
	let line = substitute (line, ',', "", "g")
	let line = substitute (line, '\s', "", "g")
	let line = substitute (line, '-$', "", "")
	let line = substitute (line, '#.*', "", "")
	if line != ''
	    let str = str . operator . '('.line.')'
	    let operator = '+'
	endif
	let i += 1
    endwhile

    " program of 'bc' can be changed
    let bc_prog = exists ("g:bccalc_bc_prog") ? g:bccalc_bc_prog : "bc"
    let answer = system (bc_prog . " -l ", str . "\n")

    if a:vsl == 1
	normal `>
    else
	normal $
    endif
    let title = "Total. "
    exec "normal o" . title . answer
endfunction
" vi:set ts=8 sw=4:
