scriptencoding utf-8
"
" 英語の短縮名で月を表記している「日付表示」を ISO8601形式 "YYYY-MM-DD" に変換する。
"     変換前の形式: "DD Mon YYYY" (例. 21 Feb 2011)
"
" 操作方法：
"   (1) 変換対象をビジュアルモードで選択する。
"   (2) ";dt" とキーインする。
"   NOTE: 変換対象の日付は レジスタ y を使って本スクリプトに渡される。
"
"   変換結果は変換前の内容に置き換わる。
"
" 変換例：
"  "21 Feb 2011" --> "2011-02-21"
"  "31 DEC. 2011" --> "2011-12-31"
"
" 作成者：勝山武晴
" 作成日：2011-03-07
" Last Change: 2017-06-07.

vnoremap ,idt "ey:call ToISO8601DateFormat()<CR>

function! ToISO8601DateFormat()
    let monthname = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    " 変換前の日付パターン("DD Mon YYYY" )
    let mx = '\(\d\{1,2}\)\s\+\(\a\{3,3}\)\.*\s\+\(\d\{4,4}\)'

    let dd = substitute (@e, mx, '\1', "")
    let mmm = substitute (@e, mx, '\2', "")
    let yy =  substitute (@e, mx, '\3', "")

    " 月名を数字に変換
    let i = 0
    while i < 12
	    if mmm =~? monthname[i]
		    break
	    endif
	    let i += 1
    endwhile

    if i >= 12
	    echo 'month name error!'
	    return
    endif

    " ISO8601 形式で日付を出力する
    let answer = printf("%s-%02d-%s", yy, i+1, dd)
    if answer !~ '^-'
	    exec "normal gvc" . answer
    else
	    echo 'No Date'
    endif
endfunction
