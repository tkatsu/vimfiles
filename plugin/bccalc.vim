"  bccalc.vim
"    This scirpt calculates equations using the program 'bc' (found on most
"    linux systems, available for most systems).  Visually select the equation
"    you want to calculate, then hit ,bc - if the selection ends with an '='
"    sign, the answer will be appended after the equal, otherwise, the answer
"    is echoed as a message. Equations can span multiple lines, and the full
"    bc syntax is probably supported.  Additionally, sin (), cos (), etc, are
"    transformed into the names used by bc (s () c (), etc). 
"  Author:	scott urban
"  Version:	1.9
"  History:
"    Ver. 1.9:  Modified by T.Katsuyama (at 2006-10-03)
"          1. Fixed a bug of Stripping trailing 0s with the answer
"             The answer of (5.761 * 0.33) was 1.9113. This must be 1.90113
"          2. Fixed a problem of remainder(%)
"            The answer of (5 % 2) was not '1'. We hope '1'.
"            "scale=1;" automatically added in case of '%' operation.
"          3. Fixed a bug of the position of the answer in visual mode
"             The answer was displayed in a first line. This must be displayed
"             after '=' in a last line.
"             vnoremap line is placed after noremap one.
"          4. Fixed a problem of the escape in Windows
"             Don't escape the characters of '%*();&><|' in windows.
"             One of '^' become '^^^^'.
"          5. Fixed a bug of chained equations
"             "obase=16;" or "obase=16;" are not ignored.
"          6. New feature. Starting from command line
"             Visualy select lines or on current line in normal mode,
"             hit ":BcCalc"
"             (The new function BcCalc() is called.)
"          9. New feature/bugfix. Comments starting with '#' by line became
"             enabled.  So far, the data after '#' was all ignored.
"          10. New feature. Input hexs automatically converted to upper case
"             if there is a 'ibase=16' in input string.
"          11. New feature. Printing the answer with a comma every 3 digtis
"             'let bccalc_output_comma=1' in .vimrc can supress 
"             comma printing.
"          12. New feature. you can change 'bc' programs in .vimrc
"               'let bccalc_bc_prog=c:\\cygwin\\bin\\bc'   (default = 'bc')
"          13. New feature. You can set the number of digits after decimal
"             point in the answer by 'bccalc_output_decimals'. (Default 3)
"          14. New feature. Allowing input with zenkaku characters
"             Input string is converted to hankaku one, if there is a
"             'hz_ja.vim' in plugin directory and
"             'let bccalc_input_allow_zenkaku=1' in .vimrc.
"          15. New feature. Enabling output with zenkaku characters
"            if there is a 'let bccalc_output_zenkaku = 1' in .vimrc,
"            the answer is output with zenkaku characters. (Default '0')
"            Also, 'hz_ja.vim' is needed.
"
"    Ver. 1.8:   Mr scott urbans's latest release at 2005-10-28
" ---------------------------------------------------------------------
"
"" calculate expression entered on command line and give answer, e.g.:
" :Calculate sin (3) + sin (4) ^ 2
command! -nargs=+ Calculate echo "<args> = " . Calculate ("<args>")

"" calculate expression on current line, pick a mapping, or use the Leader
noremap  ,bc "eyy:call CalcLines(0)<CR>
"noremap  <Leader>bc "eyy:call<SID>CalcBC(0)<CR>

"" calculate expression from selection, pick a mapping, or use the Leader form
vnoremap ,bc "ey:call CalcLines(1)<CR>
"vnoremap <Leader>bc "ey:call<SID>CalcBC(1)<CR>

" calculate expression from command line (by T.Katsuyama)
command! -range BcCalc <Line1>,<Line2>call BcCalc()

" ---------------------------------------------------------------------
"  BcCalc
"    start from command line.   (by T.Katsuyama)
function! BcCalc() range
	" if single line
	if a:firstline == a:lastline
		let @e = getline(a:firstline)
		call CalcLines(0)
	" if not visualy selected
	elseif (a:firstline != line("'<")) || (a:lastline != line("'>"))
		echo "Select lines with Shift-V!!!"
		return
	else
		let lines = getline("'<", "'>")
		let @e = join(lines, "\n")
		call CalcLines(1)
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
"  Calculate:
"    clean up an expression, pass it to bc, return answer
function! Calculate (s)

	let str = a:s

	" remove newlines and trailing spaces
	let str = substitute (str, "\n",   "", "g")
	let str = substitute (str, '\s*$', "", "g")

	" when hexadecimal input, convert lower case to upper (by T.Katsuyama)
	if str =~ "ibase\s*=\s*16"
		" remove leading '0x' (0xXXX --> XXX)
		let str = substitute (str, '\<0x\(\x\+\)\>', '\U\1', "g")
		let str = substitute (str, '\<\(\x\+\)\>', '\U\1', "g")
	endif


	" sub common func names for bc equivalent
	let str = substitute (str, '\csin\s*(',  's (', 'g')
	let str = substitute (str, '\ccos\s*(',  'c (', 'g')
	let str = substitute (str, '\catan\s*(', 'a (', 'g')
	let str = substitute (str, "\cln\s*(",   'l (', 'g')
	let str = substitute (str, '\clog\s*(',  'l (', 'g')
	let str = substitute (str, '\cexp\s*(',  'e (', 'g')

	" alternate exponitiation symbols
	let str = substitute (str, '\*\*', '^', "g")
	let str = substitute (str, '`', '^',    "g")

	" if there is remainder operator('%') and no 'scale=', add 'scale=0;'
	"   (by T.Katsuyama)
	if str =~ "%" && !(str =~ "scale\s*=")
		let str = "scale=0;" . str
	endif

	" escape chars for shell
	" let str = escape (str, '%*();&><|') ---  Removed (by T.Katsuyama)

	let preload = exists ("g:bccalc_preload") ? g:bccalc_preload : ""

	" program of 'bc' can be changed (by T.Katsuyama)
	let bc_prog = exists ("g:bccalc_bc_prog") ? g:bccalc_bc_prog : "bc"

	" run bc
	"    (changed not to use 'echo', because of the problems around it.
	"     by T.Katsuyama)
	let answer = system (bc_prog . " -l " . preload ." " , str . "\n")

	" strip newline
	let answer = substitute (answer, "\n", "", "")

	" strip trailing 0s in decimals
	" Fixed a bug of wrong replace(5.761*0.33=1.9113. This must be 1.90113)
	"   (by T.Katsuyama)
	let answer = substitute (answer, '\.\(\d*[1-9]\)0\+$', '.\1', "")
	let answer = substitute (answer, '\.0\+$', '.', "")

	" if the answer includes only numerics,
	" - trim decimals,
	" - insert a comma every 3 digits,
	" - and convert to zenkaku if needed.  (by T.Katsuyama)
	let output_comma = 
	  \ exists ("g:bccalc_output_comma") ? g:bccalc_output_comma : 1
	let output_zenkaku= 
	  \ exists ("g:bccalc_output_zenkaku") ? g:bccalc_output_zenkaku : 0

	" normal answer (not error message)
	if answer =~ '^-*\x*\.\?\x*$'
		" split string to integer part and decimal one at '.' postion
		let pos_split  = stridx(answer, "\.")
		" no integer
		if pos_split == 0
			let integers = "0"
			let decimals = strpart(answer, 1)
		elseif pos_split > 0
			let integers = strpart(answer, 0, pos_split)
			let decimals = strpart(answer, pos_split + 1)
		else
			let integers = answer
			let decimals = ''
		endif
		if integers == '-'
			let integers = '-0'
		endif

		" triming digits of decimals
		if  exists ("g:bccalc_output_decimals")
			let decimal_digits = g:bccalc_output_decimals
		else
			let decimal_digits = "3" 
		endif
		if !(a:s =~ 'scale') && decimals != ''
			let decimals = strpart(decimals, 0, decimal_digits)
		endif

		" insert commas
		if output_comma == 1
			" insert commas every 3 digits with integer part
			let integers = InsertCommas (integers)

			" insert commas every 3 digits with decimal part
			let decimals = substitute (decimals, '\(\x\{3}\)', '\1,', "g")
			" remove ',' at the end
			let decimals = substitute (decimals, ',$', "", "")
		endif
		
		if decimals == ''
			let answer = integers
		else
			let answer = integers . '.' . decimals
		endif

		" output the answer with zenkaku characters
		if output_zenkaku == 1 && exists('*ToZenkaku')
			let answer = ToZenkaku(answer)
		endif
	endif

	return answer
endfunction

" ---------------------------------------------------------------------
" CalcLines:
"
" take expression from lines, either visually selected or the current line, as
" passed determined by arg vsl, pass to calculate function, echo or past
" answer after '='
function! CalcLines(vsl)
	" allow input of zenkaku string (convert input string to hankaku)
	"  (by T.Katsuyama)
	if exists ("g:bccalc_input_allow_zenkaku")
		let input_allow_zenkaku= g:bccalc_input_allow_zenkaku
	else
		let input_allow_zenkaku= 0
	endif
	
	" Converting Zenkaku to Hankaku
	if input_allow_zenkaku == 1 &&  exists('*ToHankaku')
		let @e = ToHankaku(@e)
	endif

	let has_equal = 0

	" remove comments starting with '#' and ending with newline
	"   (by T.Katsuyama)
	let lines = split(@e, '\n', 1)
	let i = 0
	while i < len(lines)
		let lines[i] = substitute (lines[i], '#.*', "", "")
		let i += 1
	endwhile
	let @e = join(lines)

	" remove newlines and trailing spaces
	let @e = substitute (@e, "\n", "",   "g")
	let @e = substitute (@e, '\s*$', "", "g")

	" remove comments starting with '/*' and ending with '*/'
	"  (by T.Katsuyama)
	let @e = substitute (@e, '/\*[^/]*\*/', "", "g")

	" remove commas among numerics.  (by T.Katsuyama)
	let @e = substitute (@e, '\(\x\),\(\x\)', '\1\2', "g")

	" if we end with an equal, strip, and remember for output
	if @e =~ "=$"
		let @e = substitute (@e, '=$', "", "")
		let has_equal = 1
	endif

	" if there is another equal in the line, assume chained equations,
	" remove leading ones
	" Although, if there is ';',  maybe 'ibase=xx;', 'obase=xx;' or
	" 'scale=xx;' exists. So remain them.  (by Katsuyama)
	"  e.g.
	"   "obase=16; ibase=16; 190+29=1B9+1" --> "obase=16; ibase=16; 1B9+1"
	if @e =~ ";"
		" split the string at last ';'.
		let pos_split  = strridx(@e, ";") + 1
		let lefthand = strpart(@e, 0, pos_split)
		let righthand = strpart(@e, pos_split)
		let @e = lefthand . substitute (righthand, '^.\+=', '', '')
	else
		let @e = substitute (@e, '^.\+=', '', '')
	endif

	let answer = Calculate (@e)

	" append answer or echo to status line
	if has_equal == 1
		if a:vsl == 1
			normal `>
		else
			normal $
		endif
		exec "normal a" . answer
	else
		echo "answer = " . answer
	endif
endfunction
" vi:set ts=8 sw=8:
