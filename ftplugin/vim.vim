" vim.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.9
" Last Change:	2020-03-26 12:40:20

if &cp || exists("g:loaded_myvimftp")
    finish
endif
let g:loaded_myvimftp = 1

nnoremap <buffer>   <C-F5>  m`ggVG"ay``:@a<CR>
vnoremap <buffer>   <C-F5>  "ay:@a<CR>gv

command -nargs=0  Vim2html  :call vim#Vim2html()

augroup MyVim
    au!

    au BufNewFile *.vim	call vim#InsertTemplate()
    au BufWrite *.vim	call vim#Writeheader(expand("<afile>:p"))
augroup END
