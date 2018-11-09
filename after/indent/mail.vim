scriptencoding utf-8
set sw=2
set expandtab
"set tw=80

"------------------------------------------------------------------
"  全角スペースの強調
"                                  by T.Akutsu San  2003-11-25 
"------------------------------------------------------------------
if &enc =~# '\%(sjis\|cp932\)'
    exec "syntax match ZenkakuSpace '\x81\x40\\+'"
elseif &enc =~# '\%(utf8\|utf-8\)'
    exec "syntax match ZenkakuSpace '\xe3\x80\x80\\+'"
else
    exec "syntax match ZenkakuSpace '\xa1\xa1\\+'"
endif
hi def link ZenkakuSpace UnderLined
