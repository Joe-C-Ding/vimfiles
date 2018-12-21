" tex.vim	vim: ts=8 sw=4 ff=unix
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.5
" Last Change:	2018-08-07 09:45:59

if exists("*SetTeXTarget")
    call SetTeXTarget("pdf")
endif

set indentkeys-=[,(,{,),},]	" should set in after/
