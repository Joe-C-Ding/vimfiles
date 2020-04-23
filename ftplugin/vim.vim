" vim.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.9
" Last Change:	2020-04-22 00:09:55

" don't define b:did_ftplugin, or the global ftplugin will not be loaded.

setl iskeyword+=:
" actually we don't need this, cause global ftplugin also set &isk.
" anyway this won't work, cause user ftplugin will load before global one.
" let b:undo_ftplugin ..= '| setl isk<'

nnoremap <buffer>   <C-F5>  m`ggVG"ay``:@a<CR>
vnoremap <buffer>   <C-F5>  "ay:@a<CR>gv

command -nargs=0  Vim2html  :call vim#Vim2html()

augroup MyVim
    au!

    au BufNewFile *.vim	call vim#InsertTemplate()
    au BufWrite *.vim	call vim#Writeheader(expand("<afile>:p"))
augroup END

" Airline:
let b:airline_whitespace_checks = ['indent', 'trailing', 'conflicts']
