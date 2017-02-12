" ctermcolors.vim	vim: ts=8 sw=4
" Vim script for testing colors
" Language:	Vim-script
" Version:	0.5
" Maintainer:	Joe
" Last Change:	2016-10-26 14:32:50

if &t_Co == '' | finish | endif

" Open this file in a window if it isn't edited yet.
" Use the current window if it's empty.
let s:fname = expand('<sfile>:t:r')
if exists('*fnameescape')
    let s:fname = fnameescape(s:fname)
else
    let s:fname = escape(s:fname, ' \|')
endif
if &mod || line('$') != 1 || getline(1) != ''
    exe 'new +set\ bt=nofile ' . s:fname
else
    set bt=nofile
endif
unlet s:fname

syntax clear
for i in range(0, &t_Co-1)
    call setline(i+1, i)
    exec 'hi col_'.i.' ctermfg='.i
    exec 'syn keyword col_'.i.' '.i
endfor
