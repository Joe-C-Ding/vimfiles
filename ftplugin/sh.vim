" Vim filetype plugin file
" Language:	bash
" Maintainer:	Joe Ding
" Last Changed: 2011-05-04 00:47:23

if exists("b:jd_ftpsh") | finish | endif
let b:jd_ftpsh =  1

" Mappings.  <F6> is used to execute current script.
nnoremap <buffer> <F6> :update<BAR>!bash '%:p'<CR>

" Some shortcut for sharp-bang
inoreab <buffer> #!	#!/bin/bash
