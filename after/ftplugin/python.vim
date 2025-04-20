vim9script

# Language:	Python
# Maintainer:	Joe Ding
# Version:	0.1
# Last Change:	2025-04-19 16:34:32

b:undo_ftplugin ..= '|setl tw< path<'

setl tw=80

var pyroot = system('which python')->fnamemodify(':h')->fnameescape()
if has('win32')
    pyroot = substitute(pyroot, '^/\(.\)/', '\1:/', '')
endif
exe $'setl path+={pyroot}/Lib'
exe $'setl path+={pyroot}/Lib/site-packages'

# python.vim	vim: ts=8 sw=4
