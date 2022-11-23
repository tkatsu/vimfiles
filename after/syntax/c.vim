scriptencoding utf-8
highlight WordError term=bold cterm=bold ctermfg=red gui=bold guifg=red
syntax keyword WordError teh
syntax keyword WordError pirnt
syntax keyword WordError rutern

syntax keyword type qreal

" function name
syntax match myFunc /[a-zA-Z_][a-zA-Z_0-9]*\s*(/me=e-1
"hi myFunc ctermfg=darkgreen guifg=darkgreen
"hi myFunc ctermfg=darkgreen guifg=#336666 gui=bold

" 配列 [] の中
syntax match myArray /\[[a-zA-Z_0-9\.> +\-\*\/]*\]/
hi myArray ctermfg=darkgreen guifg=#996666


" Todo, Note
syntax keyword myNote contained Note note NOTE 注意
syntax keyword myTodo		contained TODO FIXME XXX Todo todo
syntax cluster cCommentGroup contains=myTodo,myNote
hi link myTodo	cTodo
hi link myNote	cError

" tags names
highlight tagsType cterm=bold ctermfg=darkred gui=bold guifg=darkred
highlight tagsFunc cterm=bold ctermfg=darkgreen gui=bold guifg=darkgreen
highlight tagsMacro cterm=bold ctermfg=darkcyan gui=bold guifg=darkcyan
highlight tagsOther cterm=bold ctermfg=darkmagenta gui=bold guifg=darkmagenta

" uITRON-2.0 function name
highlight itron2Func ctermfg=magenta gui=bold guifg=magenta
syntax keyword itron2Func sta_tsk
syntax keyword itron2Func ista_tsk
syntax keyword itron2Func ext_tsk
syntax keyword itron2Func ter_tsk
syntax keyword itron2Func chg_pri
syntax keyword itron2Func rot_rdq
syntax keyword itron2Func irot_rdq
syntax keyword itron2Func rel_wai
syntax keyword itron2Func get_tid
syntax keyword itron2Func tsk_sts
syntax keyword itron2Func sus_tsk
syntax keyword itron2Func rsm_tsk
syntax keyword itron2Func slp_tsk
syntax keyword itron2Func wai_tsk
syntax keyword itron2Func wup_tsk
syntax keyword itron2Func iwup_tsk
syntax keyword itron2Func can_wup
syntax keyword itron2Func set_flg
syntax keyword itron2Func iset_flg
syntax keyword itron2Func clr_flg
syntax keyword itron2Func wai_flg
syntax keyword itron2Func pol_flg
syntax keyword itron2Func flg_sts
syntax keyword itron2Func sig_sem
syntax keyword itron2Func isig_sem
syntax keyword itron2Func wai_sem
syntax keyword itron2Func preq_sem
syntax keyword itron2Func sem_sts
syntax keyword itron2Func snd_msg
syntax keyword itron2Func isnd_msg
syntax keyword itron2Func rcv_msg
syntax keyword itron2Func prcv_msg
syntax keyword itron2Func mbx_sts
syntax keyword itron2Func chg_ims
syntax keyword itron2Func ims_sts
syntax keyword itron2Func get_blk
syntax keyword itron2Func pget_blk
syntax keyword itron2Func rel_blk
syntax keyword itron2Func mpl_sts
syntax keyword itron2Func set_tim
syntax keyword itron2Func get_tim
syntax keyword itron2Func get_ver

" uITRON-4.0 function name
highlight itron4Func ctermfg=darkcyan gui=bold guifg=darkgreen
"/*
" *  タスク管理機能
" */
syntax keyword itron4Func act_tsk
syntax keyword itron4Func iact_tsk
syntax keyword itron4Func can_act
syntax keyword itron4Func ext_tsk
syntax keyword itron4Func ter_tsk
syntax keyword itron4Func chg_pri
syntax keyword itron4Func get_pri
"
"/*
" *  タスク付属同期機能
" */
syntax keyword itron4Func slp_tsk
syntax keyword itron4Func tslp_tsk
syntax keyword itron4Func wup_tsk
syntax keyword itron4Func iwup_tsk
syntax keyword itron4Func can_wup
syntax keyword itron4Func rel_wai
syntax keyword itron4Func irel_wai
syntax keyword itron4Func sus_tsk
syntax keyword itron4Func rsm_tsk
syntax keyword itron4Func frsm_tsk
syntax keyword itron4Func dly_tsk
"
"/*
" *  タスク例外処理機能
" */
syntax keyword itron4Func ras_tex
syntax keyword itron4Func iras_tex
syntax keyword itron4Func dis_tex
syntax keyword itron4Func ena_tex
syntax keyword itron4Func sns_tex
"
"/*
" *  同期・通信機能
" */
syntax keyword itron4Func sig_sem
syntax keyword itron4Func isig_sem
syntax keyword itron4Func wai_sem
syntax keyword itron4Func pol_sem
syntax keyword itron4Func twai_sem
"
syntax keyword itron4Func set_flg
syntax keyword itron4Func iset_flg
syntax keyword itron4Func clr_flg
syntax keyword itron4Func wai_flg
syntax keyword itron4Func pol_flg
syntax keyword itron4Func twai_flg
"
syntax keyword itron4Func snd_dtq
syntax keyword itron4Func psnd_dtq
syntax keyword itron4Func ipsnd_dtq
syntax keyword itron4Func tsnd_dtq
syntax keyword itron4Func fsnd_dtq
syntax keyword itron4Func ifsnd_dtq
syntax keyword itron4Func rcv_dtq
syntax keyword itron4Func prcv_dtq
syntax keyword itron4Func trcv_dtq
"
syntax keyword itron4Func snd_mbx
syntax keyword itron4Func rcv_mbx
syntax keyword itron4Func prcv_mbx
syntax keyword itron4Func trcv_mbx
"
"/*
" *  メモリプール管理機能
" */
syntax keyword itron4Func get_mpf
syntax keyword itron4Func pget_mpf
syntax keyword itron4Func tget_mpf
syntax keyword itron4Func rel_mpf
"
"/*
" *  時間管理機能
" */
syntax keyword itron4Func set_tim
syntax keyword itron4Func get_tim
syntax keyword itron4Func isig_tim
"
syntax keyword itron4Func sta_cyc
syntax keyword itron4Func stp_cyc
"
"/*
" *  システム状態管理機能
" */
syntax keyword itron4Func rot_rdq
syntax keyword itron4Func irot_rdq
syntax keyword itron4Func get_tid
syntax keyword itron4Func iget_tid
syntax keyword itron4Func loc_cpu
syntax keyword itron4Func iloc_cpu
syntax keyword itron4Func unl_cpu
syntax keyword itron4Func iunl_cpu
syntax keyword itron4Func dis_dsp
syntax keyword itron4Func ena_dsp
syntax keyword itron4Func sns_ctx
syntax keyword itron4Func sns_loc
syntax keyword itron4Func sns_dsp
syntax keyword itron4Func sns_dpn
"
"/*
" *  実装独自サービスコール
" */
syntax keyword itron4Func vxsns_ctx
syntax keyword itron4Func vxsns_loc
syntax keyword itron4Func vxsns_dsp
syntax keyword itron4Func vxsns_dpn
syntax keyword itron4Func vxsns_tex

if has('win32') || has('win64')
  source ~/vimfiles/after/syntax/ifdef.vim
else
  source ~/.vim/after/syntax/ifdef.vim
endif

