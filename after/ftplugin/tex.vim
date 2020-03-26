" tex.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.5
" Last Change:	2020-03-26 12:33:45

if exists("*SetTeXTarget")
    call SetTeXTarget("pdf")
endif

set indentkeys-=[,(,{,),},]	" should set in after/
