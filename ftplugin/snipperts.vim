" snipperts.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-03-26 12:36:24

if &cp || exists("g:loaded_snipperts")
    finish
endif
let g:loaded_snipperts = 1

let s:keepcpo = &cpo
set cpo&vim

setl sts=0

let &cpo = s:keepcpo
unlet s:keepcpo
