" --------------------------------------------------------------------------
"  iconv.vim
"  iconv() を使った漢字コードの変換
"  選択範囲を option 'encoding' にセットされているエンコーディングへ変換する。
"     						平成18年10月25日(水) 勝山 
" --------------------------------------------------------------------------
" 'euc-jp' から変換
command! -range  ConvFromEuc <line1>,<line2>call ConvertEncoding("euc-jp")

" 'sjis' から変換
command! -range  ConvFromSjis <line1>,<line2>call ConvertEncoding("cp932")

" 'iso-2022-jp' から変換
command! -range  ConvFromJisx <line1>,<line2>call ConvertEncoding("iso-2022-jp")

" 'utf-8' から変換
command! -range  ConvFromUtf8 <line1>,<line2>call ConvertEncoding("utf-8")

" option 'fencoding' にセットされているエンコーディングから変換
command! -range  ConvFromFenc <line1>,<line2>call ConvertEncoding(&fenc)

" 入力エンコード方式を自動認識(ただし、sjis(cp932)か euc-jp のみ)して変換
command! -range  ConvAuto <line1>,<line2>call ConvertEncoding("")

" NKF で変換
command! -range  ConvNKF <line1>,<line2>call ConvertNKF()

" --------------------------------------------------------------------------
"  ConvertEncoding
"
" 引数で指定されるエンコーディングから option 'encoding' にセットされているエ
" ンコーディングへ変換し、Buffer 上の変換元と入れ換える。
function! ConvertEncoding(from) range
    " 入力concode の自動認識による変換の際の変換有無の判定用
    if &enc =~? "euc"
      let out_enc = 'euc-jp'
    elseif &enc =~? "cp932" || &enc =~? "sjis"
      let out_enc = 'cp932'
    endif

    let n = a:firstline
    while n <= a:lastline
	let str = getline(n)

	" 入力コードを自動認識して変換
	if a:from == ""	
	    " check if including multibyte characters and convert
	    if str !~ "^[0-9A-Za-z_ \t/.,:;+-=(){}<>!#$%&'\]*$"
		" recognition of input encoding
		let in_enc = 'euc-jp'
		let len = strlen(str)
		let j = 0
		while (j < len)
		    let c = char2nr(strpart(str, j, 1))
		    if c >= 0x80 && c <= 0xA0	 " input is sjis or cp932
			let in_enc = 'cp932'
			break
		    endif
		    let  j += 1
		endwhile

		" convert encoding
		if in_enc != out_enc
		  let str = iconv(str, in_enc, &enc)
		endif
	    endif

	else
	    let str = iconv(str, a:from, &enc)
	endif
	call setline(n, str)
	let n +=  1
    endwhile
endfunction

" --------------------------------------------------------------------------
"  ConvertNKF
"
" 引数で指定されるエンコーディングから option 'encoding' にセットされているエ
" ンコーディングへ変換し、Buffer 上の変換元と入れ換える。
function! ConvertNKF() range
    let n = a:firstline

    if &enc =~? "euc"
	let prog = "nkf -e "
    elseif (&enc =~? "sjis" || &enc =~? "cp932")
	let prog = "nkf -s "
    else
	return
    endif

    while (n <= a:lastline)
	let str = getline(n)
	let str = system(prog, str . "\n")
	let str = substitute(str, "\n", "", "")
	call setline(n, str)
	let n +=  1
    endwhile
endfunction

" vim: set sw=4:
