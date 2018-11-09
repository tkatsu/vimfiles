"----------------------------------------------------------------------------
" List up function name of current C language file
" vim : set sw=4
"						  by Katsuyama ('02/12/10)
"----------------------------------------------------------------------------
if exists("loaded_cflist")
    finish
endif
let loaded_cflist=1

command! Cflist call FuncCflist()

function! FuncCflist()
    let tmpfile = tempname()
    "let file_in = a:name
    "currenet file name
    let file_in = bufname("")

    " Create tags file with cross-refferenc option "-x", C-func name and  no sort
    exec "silent !ctags -x --c-types=f --sort=no " file_in " > " tmpfile

    " convert format to 'errorformat' style  (filename:line-number:message)
    exe "silent sp" tmpfile
    exe 'silent %sm/^\(\S\+\)\s\+function\s\+\([0-9]\+\)\s\+\(\S\+\)\s\+\(.*\)/\3:\2:\1/'
    "echo tmpfile
    exe "silent wq"

    "cgetfile as quick-refference style
    " backup current grepformat setting
    let save_grepformat = &grepformat
    let &grepformat = '%f:%l:%m'
    exe "silent cgetfile " tmpfile
    exe "silent copen"
    " restore grepformat setting
    let &grepformat = save_grepformat

    exe "silent !rm " tmpfile
endfunction
"----------------------------------------------------------------------------
