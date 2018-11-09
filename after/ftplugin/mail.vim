scriptencoding utf-8
" -------------------------------------------------------------------------
" メールヘッダや引用部、添付ファイルの折り畳みを行う。
"   引用部の記号は '>', '|', ']' のいづれかで、6段まで対応。
"
"   _gvimrc 等の設定ファイルで g:mail_fold_enable = 1 とすれば本スクリ
"   プトによる折り畳みが有効になる。
"                                       by 勝山    2008年4月16日(水)
" -------------------------------------------------------------------------
if !exists("g:mail_fold_enable")
  finish
endif

setlocal foldmethod=expr
setlocal foldexpr=GetMailFold(v:lnum)
setlocal foldtext=GetMailFoldtext()
setlocal formatoptions+=2M

" 必ず表示するヘッダ
let b:dispHeader = '^\(Date\|From\|Subject\|To\|Cc\):'
" 非表示にする(折畳む)ヘッダ
let b:maskHeader = '^\(Received\|X-\|Message-\|MIME-\|Content-\|References\|In-Reply-\|Reply-\|Organization\|User-\|Erros-To\|Sender\|Thread-\).*:'
" 引用の折畳み用
let b:quoteLevel1 = '^\s*\(>\|]\||\|｜\)'
let b:quoteLevel2 = '^\s*\(>\|]\||\|｜\)\s*\1'
let b:quoteLevel3 = '^\s*\(>\|]\||\|｜\)\s*\1\s*\1'
let b:quoteLevel4 = '^\s*\(>\|]\||\|｜\)\s*\1\s*\1\s*\1'
let b:quoteLevel5 = '^\s*\(>\|]\||\|｜\)\s*\1\s*\1\s*\1\s*\1'
let b:quoteLevel6 = '^\s*\(>\|]\||\|｜\)\s*\1\s*\1\s*\1\s*\1\s*\1'

" バッファローカルな変数
let b:maskedHeader = 0
let b:multipartMode = 0
let b:maskedMultipartBody = 0
let b:str_boundary =  '^--'

" -------------------------------------------------------------------------
" 折り畳み行の決定
"   戻り値：
"    ">1" --- レベル1 の折畳みの開始
"    "<1" --- レベル1 の折畳みの終了
"    "=" --- 前行のレベルと同じ
"    0 --- 折り畳みレベル  0 (折り畳みしない。必ず表示する)
"    1 --- 折り畳みレベル  1
"    n --- 折り畳みレベル  n
" -------------------------------------------------------------------------
function! GetMailFold(lnum)
  let lineCurr = getline(a:lnum)
  if a:lnum < line("$")
    let lineNext = getline(a:lnum+1)
  else
    let lineNext = ''
  endif

  "１行目が 'From - ' なら折畳みを開始
  if (a:lnum == 1) && ( lineCurr =~ '^From\s*-')
    let b:maskedHeader = 1
    return ">1"
  endif

  " multipart 宣言の検索
  if (b:multipartMode == 0) && (lineCurr =~ '^Content-Type: multipart/')
    let b:multipartMode = 1
  endif

  " multipart の境界文字列定義の検索
  if b:multipartMode == 1
    let result =  matchlist(lineCurr, 'boundary=\(.*\)')
    if get(result, 1, "") != "" 
      " 境界文字列を取り出す
      let boundary = result[1]
      " ダブルクォーテーションで囲まれていたら、その内側を取り出す
      let boundary = substitute(boundary, '"\(.*\)"', "\\1", "")
      let b:str_boundary = b:str_boundary . boundary
      let b:multipartMode = 2
    else
      let result =  matchlist(lineCurr, '^--\(Boundary.*\)')
      if get(result, 1, "") != "" 
	" 境界文字列を取り出す
	let boundary = result[1]
	let b:str_boundary = b:str_boundary . boundary
	let b:multipartMode = 2
      endif
    endif
  endif

  " multipart ヘッダの最後(text/plain の先頭)を検索
  if (b:multipartMode == 2) && (lineCurr =~ '^Content-Type: text/plain')
    let b:multipartMode = 3
  endif

  " 空の行が来たら折り畳みを終了
  if (lineCurr =~ '^$') && (foldlevel(a:lnum -1)==1) && (b:multipartMode == 0 || b:multipartMode == 3) && (b:maskedMultipartBody == 0)
    let b:maskedHeader = 0
    return "<1"
  endif

  " multipart の境界文字列が来たら、
  if b:multipartMode == 3 && lineCurr =~ b:str_boundary
    if lineNext =~ '^Content-Type: application'
      let b:maskedMultipartBody = 1
      " 折り畳みの開始
      return ">1"
    elseif foldlevel(a:lnum -1)!=1
      " 折り畳みの開始
      let b:maskedMultipartBody = 1
      return ">1"
    endif
  endif

  " 非表示にしたいヘッダが来たら折り畳み開始
  if b:maskedMultipartBody == 0 && lineCurr =~ b:maskHeader
    " 次行に必須ヘッダがなければ、折り畳み開始
    if lineNext !~ b:dispHeader && foldlevel(a:lnum-1)!=1
      let b:maskedHeader = 1
      return ">1"
    else
      " 非表示ヘッダが１行だけの場合。
      " (１行が長く折り返される時にのみ畳み込まれる)
      return 1
    endif
  elseif lineCurr =~ b:dispHeader 
    " 必須ヘッダは必ず表示する
    return 0

  " 引用メッセージの折り畳み
  elseif lineCurr =~ b:quoteLevel6
    return 6
  elseif lineCurr =~ b:quoteLevel5
    return 5
  elseif lineCurr =~ b:quoteLevel4
    return 4
  elseif lineCurr =~ b:quoteLevel3
    return 3
  elseif lineCurr =~ b:quoteLevel2
    return 2
  elseif lineCurr =~ b:quoteLevel1
    return 1
  endif

  " 次行に必須ヘッダがあれば、折り畳みはここで終了
  if lineNext =~ b:dispHeader && (foldlevel(a:lnum-1)==1)
    let b:maskedHeader=0
    return "<1"
  endif

  " 折畳み中
  if b:maskedHeader==1 || b:maskedMultipartBody==1
    return "="
  else
    return 0
  endif
endfunction

" -------------------------------------------------------------------------
" 折り畳みのタイトルとして表示するものを決定する
" -------------------------------------------------------------------------
function! GetMailFoldtext()
  let text = s:getFilename(v:foldstart, v:foldend)
  if text ==''
    " デフォルトの折り畳み表示
    return foldtext()
  else
    " ファイル名を表示
    return '+-- '. (v:foldend - v:foldstart + 1). '行: 添付ファイル "' . text .'"'
  endif
endfunction

" -------------------------------------------------------------------------
"  折り畳み範囲の中で Content-Type:...\n name=... という記述を探、name= 以降を
" ファイル名として返す。
"  (範囲の先頭4行だけで判断する)
" -------------------------------------------------------------------------
function! s:getFilename(zonestart, zoneend)
  let text = ''
  if a:zoneend < a:zonestart + 4
    return text
  endif

  let linepos = a:zonestart
  while linepos <= a:zonestart + 4
    let lineCurr = getline(linepos)
    if lineCurr =~ '^Content-Type:'
      let result =  matchlist(lineCurr, "name\=\"\\(.*\\)\"")
      if get(result, 1, "") == "" 
	" 現在行で見付からなかったら次の行を探す
	let lineName = getline(linepos+1)
	let result =  matchlist(lineName, "name\=\"\\(.*\\)\"")
	" それでも見付からなかったら、次の次の行を探す
	if get(result, 1, "") == "" 
	  let lineName = getline(linepos+2)
	  let result =  matchlist(lineName, "name\=\"\\(.*\\)\"")
	endif
      endif
      if get(result, 1, "") != "" 
	" name
	return result[1]
      endif
      return text
    endif
    let linepos += 1
  endwhile
  return text
endfunction

" vim: set sw=2:
