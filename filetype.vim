" filetype.vim	vim: ts=8 sw=4
" Language:	Vim filetype-detect file.
" Maintainer:	Joe Ding
" Version:	0.5
" Last Change:	2020-03-26 12:39:11

if exists("did_load_filetypes")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

augroup myft
    au!

    au BufNewfile,BufRead *.sy	setf sy
    au BufNewfile,BufRead *.ass	setf ass
augroup END

let &cpo = s:cpo_save
unlet s:cpo_save
