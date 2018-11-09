scriptencoding utf-8
" C 言語固有の設定
if has('win32') || has('win64') || system('uname') =~ 'MINGW'
  source $HOME/vimfiles/after/indent/c.vim
else
  source $HOME/.vim/after/indent/c.vim
endif
