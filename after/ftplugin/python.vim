" python.vim	vim: ts=8 sw=4
" Language:	python
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2024-11-30 13:30:59

let b:undo_ftplugin .= 'setl tw< path<'

setl tw=80

let pyroot = system('which python')->fnamemodify(':h')->fnameescape()
if has('win32')
    let pyroot = substitute(pyroot, '^/\(.\)/', '\1:/', '')
endif
exe 'setl path+=' .. pyroot .. '/Lib'
exe 'setl path+=' .. pyroot .. '/Lib/site-packages'

