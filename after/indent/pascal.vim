scriptencoding utf-8

let pascal_delphi=1
set shiftwidth=2
set smartindent

" abbr
" begin
"
" end
iab beg begin

"""" if
" if () then begin 
" end else begin
" end{if};
iab if if exp then

"""" case
" case (var) of
"   A: ?;
"   B:
"     begin
"     end;
" else
" end{case};
iab case case exp of

"""" while
" while (exp) do begin
" end {while};
iab whi while (exp) do

"""" for
" for I :=B to E do begin
" end{for};
iab for for i := B to E do

""" function
" function name(var: Type): Type;
" var
"   varname : Type;
" begin
"   procedure;
" end;
iab func function name(var: Type): Type;

""" procedure
" procedure name(var: Type);
" begin
"   proc;
" end;
iab proc procedure name(var: Type);


"""" try
" finally
" end{try};
iab tryf try

"""" try
" except
" end{try};
iab trye try

"""" 関数 header
iab fh {****************************************************************************

"""" 手続き header
iab ph {****************************************************************************
"
"""" module(file) header
"iab mh {****************************************************************************