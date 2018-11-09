" --------------------------------------------------------------------------
"  iconv.vim
"  iconv() ���g���������R�[�h�̕ϊ�
"  �I��͈͂� option 'encoding' �ɃZ�b�g����Ă���G���R�[�f�B���O�֕ϊ�����B
"     						����18�N10��25��(��) ���R 
" --------------------------------------------------------------------------
" 'euc-jp' ����ϊ�
command! -range  ConvFromEuc <line1>,<line2>call ConvertEncoding("euc-jp")

" 'sjis' ����ϊ�
command! -range  ConvFromSjis <line1>,<line2>call ConvertEncoding("cp932")

" 'iso-2022-jp' ����ϊ�
command! -range  ConvFromJisx <line1>,<line2>call ConvertEncoding("iso-2022-jp")

" 'utf-8' ����ϊ�
command! -range  ConvFromUtf8 <line1>,<line2>call ConvertEncoding("utf-8")

" option 'fencoding' �ɃZ�b�g����Ă���G���R�[�f�B���O����ϊ�
command! -range  ConvFromFenc <line1>,<line2>call ConvertEncoding(&fenc)

" ���̓G���R�[�h�����������F��(�������Asjis(cp932)�� euc-jp �̂�)���ĕϊ�
command! -range  ConvAuto <line1>,<line2>call ConvertEncoding("")

" NKF �ŕϊ�
command! -range  ConvNKF <line1>,<line2>call ConvertNKF()

" --------------------------------------------------------------------------
"  ConvertEncoding
"
" �����Ŏw�肳���G���R�[�f�B���O���� option 'encoding' �ɃZ�b�g����Ă���G
" ���R�[�f�B���O�֕ϊ����ABuffer ��̕ϊ����Ɠ��ꊷ����B
function! ConvertEncoding(from) range
    " ����concode �̎����F���ɂ��ϊ��̍ۂ̕ϊ��L���̔���p
    if &enc =~? "euc"
      let out_enc = 'euc-jp'
    elseif &enc =~? "cp932" || &enc =~? "sjis"
      let out_enc = 'cp932'
    endif

    let n = a:firstline
    while n <= a:lastline
	let str = getline(n)

	" ���̓R�[�h�������F�����ĕϊ�
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
" �����Ŏw�肳���G���R�[�f�B���O���� option 'encoding' �ɃZ�b�g����Ă���G
" ���R�[�f�B���O�֕ϊ����ABuffer ��̕ϊ����Ɠ��ꊷ����B
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
