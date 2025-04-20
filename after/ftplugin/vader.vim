vim9script

# Language:	Vim-script
# Maintainer:	Joe Ding
# Version:	0.1
# Last Change:	2025-04-25 22:52:56

b:undo_ftplugin ..= "| nunmap <buffer> <C-F5>"

nnoremap <buffer> <C-F5> :update<CR>:Vader<CR>

# vader.vim	vim: ts=8 sw=4
