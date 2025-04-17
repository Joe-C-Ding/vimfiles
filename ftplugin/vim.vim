vim9script

# Language:	Vim-script
# Maintainer:	Joe Ding
# Version:	0.9
# Last Change:	2025-04-16 20:55:12

# don't define b:did_ftplugin, or the global ftplugin will not be loaded.

# setl iskeyword+=:	" not useful for vim 9 script
# actually we don't need this, cause global ftplugin also set &isk.
# anyway this won't work, cause user ftplugin will load before global one.
# let b:undo_ftplugin ..= '| setl isk<'

import autoload '../autoload/vim.vim'

nnoremap <buffer>   <C-F5>  <ScriptCmd>vim.Execute(v:false)<CR>
vnoremap <buffer>   <C-F5>  <ScriptCmd>vim.Execute(v:true)<CR>

augroup MyVim
    au!

    au BufWrite *.vim	call vim.Writeheader()
augroup END

# Airline:
b:airline_whitespace_checks = ['indent', 'trailing', 'conflicts']

# vim.vim	vim: ts=8 sw=4
