scriptencoding utf-8

" OmniSharpBuildAsync でビルド後の Quickfix画面の文字化けを直す
"   (合せて余計な CR も削除する)
function! ConvQuickfixListToUtf()
  echom "ConvQuickfixListToUtf()"
  if &filetype != 'cs'
    return
  endif
  let qflist = getqflist()
  for i in qflist
    let i.text = iconv(i.text, "cp932", "utf-8")
    let i.text = substitute(i.text, "\r$", "", "")
  endfor
  call setqflist(qflist)
endfunction

autocmd! QuickfixCmdPost cgetfile call ConvQuickfixListToUtf()
