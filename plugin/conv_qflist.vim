function! ConvQflistFromSjis()
   let qflist = getqflist()
   for i in qflist
      let i.text = iconv(i.text, "sjis", &enc)
   endfor
   call setqflist(qflist)
endfunction
