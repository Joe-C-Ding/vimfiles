" tex.vim	vim: ts=8 sw=4 ff=unix
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.7
" Last Change:	2017-11-21 09:19:37

let s:keepcpo= &cpo
set cpo&vim

let b:undo_ftplugin = "setl kp< sw< tw< isk< cfu<"

set sw=2 textwidth=78

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

nnoremap <buffer>   <C-F5>  :update<CR>:!xelatex %<CR>
nnoremap <buffer>   K	:exec "!texdoc ".expand("<cword>")<CR>

let &cpo = s:keepcpo
unlet s:keepcpo
