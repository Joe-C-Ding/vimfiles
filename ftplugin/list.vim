" Vim filetype plugin file for my own use.
" Language:	anime-list
" Maintainer:	Joe Ding
" Last Changed: 2011-05-05 13:23:56

if exists("b:my_ftplist") | finish | endif
let b:my_ftplist = 1

let b:undo_ftplugin = "setl fdm< fdl<"
setl fdm=marker fdl=1 ts=4

" Count
nnoremap <buffer> ;c	:%s/^ \{4\}\S.*$//n<CR>

" Move around
nnoremap <silent><buffer> [[ :call search('^__ [#A-Z] __', "bs")<CR>
nnoremap <silent><buffer> ]] :call search('^__ [#A-Z] __', "s")<CR>

nnoremap <silent><buffer> <M-#> :call search('^__ # __', "sw")<CR>zt
nnoremap <silent><buffer> <M-3> :call search('^__ # __', "sw")<CR>zt
nnoremap <silent><buffer> <M-a> :call search('^__ A __', "sw")<CR>zt
nnoremap <silent><buffer> <M-b> :call search('^__ B __', "sw")<CR>zt
nnoremap <silent><buffer> <M-c> :call search('^__ C __', "sw")<CR>zt
nnoremap <silent><buffer> <M-d> :call search('^__ D __', "sw")<CR>zt
nnoremap <silent><buffer> <M-e> :call search('^__ E __', "sw")<CR>zt
nnoremap <silent><buffer> <M-f> :call search('^__ F __', "sw")<CR>zt
nnoremap <silent><buffer> <M-g> :call search('^__ G __', "sw")<CR>zt
nnoremap <silent><buffer> <M-h> :call search('^__ H __', "sw")<CR>zt
nnoremap <silent><buffer> <M-i> :call search('^__ I __', "sw")<CR>zt
nnoremap <silent><buffer> <M-j> :call search('^__ J __', "sw")<CR>zt
nnoremap <silent><buffer> <M-k> :call search('^__ K __', "sw")<CR>zt
nnoremap <silent><buffer> <M-l> :call search('^__ L __', "sw")<CR>zt
nnoremap <silent><buffer> <M-m> :call search('^__ M __', "sw")<CR>zt
nnoremap <silent><buffer> <M-n> :call search('^__ N __', "sw")<CR>zt
nnoremap <silent><buffer> <M-o> :call search('^__ O __', "sw")<CR>zt
nnoremap <silent><buffer> <M-p> :call search('^__ P __', "sw")<CR>zt
nnoremap <silent><buffer> <M-q> :call search('^__ Q __', "sw")<CR>zt
nnoremap <silent><buffer> <M-r> :call search('^__ R __', "sw")<CR>zt
nnoremap <silent><buffer> <M-s> :call search('^__ S __', "sw")<CR>zt
nnoremap <silent><buffer> <M-t> :call search('^__ T __', "sw")<CR>zt
nnoremap <silent><buffer> <M-u> :call search('^__ U __', "sw")<CR>zt
nnoremap <silent><buffer> <M-v> :call search('^__ V __', "sw")<CR>zt
nnoremap <silent><buffer> <M-w> :call search('^__ W __', "sw")<CR>zt
nnoremap <silent><buffer> <M-x> :call search('^__ X __', "sw")<CR>zt
nnoremap <silent><buffer> <M-y> :call search('^__ Y __', "sw")<CR>zt
nnoremap <silent><buffer> <M-z> :call search('^__ Z __', "sw")<CR>zt

