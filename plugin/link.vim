scriptencoding utf-8
"---------------------------------------------------------------------------
"  file:// や http:// で始まる文字列のある行にカーソルを置いて何等かの操作をしたら、
" それぞれに関連付けられた動作をする。
"
" 操作と対応する動作:
"   ・ 左マウスクリック
"        または
"   ・ Control-Enter (C-CR) --- 対象がファイルの場合、OS が関連付けた
"                               アプリで開く。
"                               対象がフォルダの場合、explorer.exe を起動する。
"                               対象が、http:// の場合、デフォルトのブラウザ
"                               で開く。
"
"   ・ Shift-Enter (S-CR)   --- 対象がディレクトリの場合、新しいタブを開き、
"                               :Explorer を実行する(即ち、:Texplorer)
"                               ファイルの場合は OS が関連付けたアプリ
"                               で開く。
" 制限事項：
"    １行に記述できるリンクは一つだけ。
"    １行に複数のリンクを記述すると無効となる。
"
"  2008年2月22日(金)  新規作成 by T.Katsuyama
"  2008年2月25日(月)  改訂
"  2018年11月08日(木)  改訂 左マウスクリックでのリンクをマスク、http の対象検
"                      索を改善
"---------------------------------------------------------------------------
" Control-Enter (C-CR)
nmap <silent> <C-CR> :call Link_App(0)<CR>
" 左マウスクリック
" nmap <silent> <LeftMouse> <LeftMouse>:call Link_App(0)<CR>
" Shift-enter (S-CR>
nmap <silent> <S-CR> :call Link_App(1)<CR>

function! Link_App(explorer)
  let line = getline(".")
  "--- file:// で始まるもの
  " file:// から右側を取り出す
  let result =  matchlist(line, "file\:\/\/\\(.*\$\\)")
  if get(result, 1, "") != "" 
    let target = result[1]
    " 後端のスペースを削除
    let target = substitute(target, "\\s*$", "", "")
    " ドライブレターの前に \\ があれば削除する(例 \\X:...)
    if target =~ "^\\\\*[a-zA-Z]:"
      let target = substitute(target, "^\\\\*", "", "")
    endif

    if (filereadable(target) == 0) && (isdirectory(target) == 0)
      echohl WarningMsg
      echo "そのファイルまたはフォルダは存在しません!! " . '"' . target .'"'
      return
    endif

    " アプリの起動
    if (a:explorer == 1) && (isdirectory(target) == 1)
      " 後端の \ を削除
      let target = substitute(target, "\\\\*$", "", "")
      silent exe ":Texplore " . target
    else
      normal "<CR>"
      echohl WarningMsg
      let target2 = iconv(target, &enc, "sjis")
      call netrw#BrowseX(target2, 0)
    endif
    return
  endif

  "--- http:// で始まるもの
  let result =  matchlist(line, 'https\=:\/\/[0-9A-Za-z.\/\-_#?:=&+\~%]*')
  if get(result, 0, "") != "" 
    " アプリの起動
    echohl WarningMsg
    call netrw#BrowseX(result[0], 0)
  endif
endfunction
" vim:set sw=2:
