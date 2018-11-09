scriptencoding utf-8
syntax match memoLabelRound display "^\s*[○●◎〇・]"hs=e-1
syntax match memoTodo display  "^\s*[⇒→]"hs=e-1
hi def link memoTodo			Todo
