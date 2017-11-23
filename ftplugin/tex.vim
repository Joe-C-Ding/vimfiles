" tex.vim	vim: ts=8 sw=4 ff=unix
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.8
" Last Change:	2017-11-23 16:49:57

let s:keepcpo= &cpo
set cpo&vim

let b:undo_ftplugin = "setl kp< sw< tw< isk< cfu<"

set sw=2 textwidth=78

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

if has('win32')
    nnoremap <buffer>   <C-F5>  :update<CR>:!xelatex %<CR>
else
    nnoremap <buffer>   <C-F5>  :call Go()<CR>
endif
nnoremap <buffer>	K  :exec "!texdoc " . expand("<cword>")<CR>

function! Go()
    update

    silent !xelatex -interaction=nonstopmode 1>null 2>&1 %
    vs %:r.log
    silent !evince %:r.pdf &

    redraw
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
