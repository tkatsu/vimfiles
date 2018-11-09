scriptencoding utf-8

" C 言語固有の設定
"   for vim6.1 以降  by 勝山

set shiftwidth=4
" :0 -- switch 文の case ラベルを switch と同じ位置に
"set cinoptions+=:0
"set tabstop=8

"--------- ソースの自動整形
" 外部プログラム GNU indent による C ソースの整形 (Berkeley 風や K&R 風にする)
" 操作方法：
"   (1) Visual モードで整形範囲を選択し、;i とキーインする。
"       indent_options のオプション指定でで整形する
"   (2) Visual モードで整形範囲を選択し、;I とキーインする。
"       indent_options2 のオプション指定でで整形する
"   (3) コマンドラインで範囲を選択し、Indent とキーインする。
"       indent_options のオプション指定でで整形する
"   (4) コマンドラインで範囲を選択し、Indent2 とキーインする。
"       indent_options2 のオプション指定でで整形する

"   ※ indent_options、indent プログラム は、_gvimrc にて指定しておく。
"
" ショートカットキー
vnoremap ,i "ey:call VIndent(g:indent_options)<CR>
vnoremap ,I "ey:call VIndent(g:indent_options2)<CR>
" コマンドライン のインターフェイス
command! -range Indent <Line1>,<Line2>call Indent(g:indent_options)
command! -range Indent2 <Line1>,<Line2>call Indent(g:indent_options2)
command! -range IndentKR <Line1>,<Line2>call Indent(g:indent_options_kr)
command! -range IndentKR2 <Line1>,<Line2>call Indent(g:indent_options_kr2)

function! VIndent(indent_options)
    '<,'>call Indent(a:indent_options)
endfunction

function! Indent(indent_options) range
  " タブの長さを合わせる
  let options = "-ts" . &tabstop . " " . a:indent_options
  let l:OSTYPE=system('uname')
  if (l:OSTYPE == "Linux" || l:OSTYPE =~? "cygwin") && &ff == "dos"
    " 一旦、改行コードを LF にして indent を実行する。
    exec ":set ff=unix"
    " 整形の実行
    exec a:firstline . "," . a:lastline . "!" . g:indentprog . " " . options
    " 改行コードを元に戻す
    exec ":set ff=dos"
  else
    " 整形の実行
    exec a:firstline . "," . a:lastline . "!" . g:indentprog . " " . options
  endif
endfunction
"--------- ソースの自動整形 ここまで -----

"""""""""""""  短縮表記 for C ソース
" help abbreviations  で詳細な使用方法が分かる。
func! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

"""" if
"if () {
"} else {
"}
"iabbr <silent> if if () {<CR>} else {<CR>}<ESC>kk0f(a<C-R>=Eatchar('\s')<CR>

"""" for
"for (;;) {
"}
"iab <silent> for for (;;) {<CR>}<ESC>k0f(a<C-R>=Eatchar('\s')<CR>

"""" while
"while () {
"}
"iab <silent> whi while () {<CR>}<ESC>k0f(a<C-R>=Eatchar('\s')<CR>
"iab <silent> while while () {<CR>}<ESC>k0f(a<C-R>=Eatchar('\s')<CR>

"""" switch
"switch () {
"case A:
"    break;
"case B:
"    break;
"}

"iab swi switch () {<CR>case ?:<CR>break;<CR>default:<CR>break;<CR>}<ESC>%0f(a<C-R>=Eatchar('\s')<CR>
"iab switch switch () {<CR>case ?:<CR>break;<CR>default:<CR>break;<CR>}<ESC>%0f(a<C-R>=Eatchar('\s')<CR>

"""" etc
"iab re return;
"iab ex extern
"iab un unsigned 
" char のミスタイプ
iab cahr char

""" C macro
"iab inc #include
"iab def #define
"iab ifdef #ifdef ?<CR>#else<CR>#endif<ESC>kk0f?cw<Left>
"iab end #endif
