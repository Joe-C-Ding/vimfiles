" plaintex.vim	vim: ts=8 sw=4 ff=unix
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.6
" Last Change:	2017-11-13 10:29:41

let s:keepcpo= &cpo
set cpo&vim

let b:undo_ftplugin = "setl kp< sw< tw< isk< cfu<"

set sw=2 textwidth=78

nnoremap <buffer>   <C-F5>  :update<CR>:!tex %<CR>
nnoremap <buffer>   \lv  :!start /B yap %:t:r<CR>

let &cpo = s:keepcpo
unlet s:keepcpo
