" snipperts.vim	vim: ts=8 sw=4 ff=unix
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2019-04-27 23:07:38

if &cp || exists("g:loaded_snipperts")
    finish
endif
let g:loaded_snipperts = 1

let s:keepcpo = &cpo
set cpo&vim

setl sts=0

let &cpo = s:keepcpo
unlet s:keepcpo
