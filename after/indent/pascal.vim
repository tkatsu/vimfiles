scriptencoding utf-8

let pascal_delphi=1
set shiftwidth=2
set smartindent

" abbr
" begin
"
" end
iab beg beginendkko

"""" if
" if () then begin 
" end else begin
" end{if};
iab if if exp thenbeginend elsebeginend{if};kkkk0/expcw

"""" case
" case (var) of
"   A: ?;
"   B:
"     begin
"     end;
" else
" end{case};
iab case case exp ofA: ??;B:beginend;elseend{case};kkkkkk0/expcw

"""" while
" while (exp) do begin
" end {while};
iab whi while (exp) dobeginend{while};kk0/expcw

"""" for
" for I :=B to E do begin
" end{for};
iab for for i := B to E dobeginend{for};kk0

""" function
" function name(var: Type): Type;
" var
"   varname : Type;
" begin
"   procedure;
" end;
iab func function name(var: Type): Type;varvarname: Type;beginproc;end;kkkkk0/namecw

""" procedure
" procedure name(var: Type);
" begin
"   proc;
" end;
iab proc procedure name(var: Type);beginproc;end;kkk/namecw


"""" try
" finally
" end{try};
iab tryf tryfinallyend{try};kko

"""" try
" except
" end{try};
iab trye tryexceptend{try};kko

"""" 関数 header
iab fh {**************************************************************************** * name : func* Purpose:*    * Parameters:* Returns:* Written by:*   your_name date Versin 1.0****************************************************************************}kkkkkkk0/funccw

"""" 手続き header
iab ph {**************************************************************************** * name : proc* Purpose:*    * Written by:*   your_name date Versin 1.0****************************************************************************}kkkkk0/proccw
"
"""" module(file) header
"iab mh {***************************************************************************** $id:$* Copyright(C) Nagano Japan Radio Engineering Corp.  2002*        All Rights Reseved****************************************************************************** Purpose:*    * Author: your_name* History:*    date Versin 1.0****************************************************************************}
