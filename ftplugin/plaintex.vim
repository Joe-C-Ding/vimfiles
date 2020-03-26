" plaintex.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.8
" Last Change:	2020-03-26 12:36:14

let s:keepcpo= &cpo
set cpo&vim

let b:undo_ftplugin = "setl kp< sw< tw< isk< cfu<"

set sw=2 textwidth=78

if has('win32')
    nnoremap <buffer>   <C-F5>  :update<CR>:!tex %<CR>
    nnoremap <buffer>   \lv  :!start /B yap %:t:r<CR>
else
    nnoremap <buffer>   <C-F5>  :call Go()<CR>
    nnoremap <buffer>   \lv  :!evince %:r.dvi &<CR>
endif

function! Go()
    update

    silent !tex -interaction=nonstopmode 1>null 2>&1 %
    vs %:r.log
    silent !evince %:r.dvi &

    redraw
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
