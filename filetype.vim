" filetype.vim	vim: ts=8 sw=4 ff=unix
" Language:	Vim filetype-detect file.
" Maintainer:	Joe Ding
" Version:	0.5
" Last Change:	2017-10-26 09:01:47

if exists("did_load_filetypes")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

if has('win32')
    let s:data_root = '~/vimfiles/.anime/s\ 声優资料/**/*'
else
    let s:data_root = '~/Documents/.about\ anime/s\ 声優资料/**/*'
endif

augroup myft
    au BufNewfile,BufRead *.sy	setf sy
    exec "au BufNewfile,BufRead ".s:data_root." setf sy"

    au BufNewfile,BufRead *.ass	setf ass
augroup END

let &cpo = s:cpo_save
unlet s:cpo_save
