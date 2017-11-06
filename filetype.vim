" filetype.vim	vim: ts=8 sw=4 ff=unix
" Language:	Vim filetype-detect file.
" Maintainer:	Joe Ding
" Version:	0.5
" Last Change:	2017-10-28 23:01:03

if exists("did_load_filetypes")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

augroup myft
    au BufNewfile,BufRead *.sy	setf sy

    au BufNewfile,BufRead *.ass	setf ass

    au BufNewFile *.vim	call vim#InsertTemplate()
    au BufWrite *.vim	call vim#Writeheader(expand("<afile>:p"))
augroup END

let &cpo = s:cpo_save
unlet s:cpo_save
