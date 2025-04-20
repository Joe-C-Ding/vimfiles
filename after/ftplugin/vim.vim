vim9script

# Language:	Vim-script
# Maintainer:	Joe Ding
# Version:	0.9
# Last Change:	2025-04-20 10:01:55

def MyVimUndo()
    # setl isk<
    silent! nunmap <buffer> <C-F5>
    silent! vunmap <buffer> <C-F5>
    unlet b:airline_whitespace_checks
enddef

b:undo_ftplugin ..= $"|call {expand('<SID>')}MyVimUndo()"

import autoload '../../autoload/vim.vim'

# setl iskeyword+=:	" not useful for vim 9 script

nnoremap <buffer>   <C-F5>  <ScriptCmd>vim.Execute(v:false)<CR>
vnoremap <buffer>   <C-F5>  <ScriptCmd>vim.Execute(v:true)<CR>

augroup MyVim
    au!

    au BufWrite *.vim	call vim.Writeheader()
augroup END

# Airline:
b:airline_whitespace_checks = ['indent', 'trailing', 'conflicts']

# vim.vim	vim: ts=8 sw=4
