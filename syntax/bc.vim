scriptencoding utf-8
"
" bc.vim - bc/bccalc(vim上の計算ツール)用のシンタックス定義
"   (使用方法：~/vimfiles/syntax にこのファイルをコピーするだけ)
" Language:	bc
" Maintainer:	Takeharu Katsuyama
" Last Change:	2017-04-28.

syntax match bcOpe	display '[\+\-\=\/\*\%]'
syntax match bcDot	display '[0-9A-F-a-f]\.'hs=s+1
syn region	bcComment	start="/\*" end="\*/"  fold
syn keyword bcKeyword ibase obase

hi def link bcKeyword			MoreMsg
hi def link bcOpe			MoreMsg
hi def link bcComment			Comment
hi def link bcDot			Constant

let b:current_syntax = "bc"
" vim:ts=8 sts=2 sw=2 tw=0 wrap:
