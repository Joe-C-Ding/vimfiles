vim9script

# Language:	Vim-script
# Maintainer:	Joe Ding
# Version:	0.1
# Last Change:	2025-04-26 12:42:35

# move to the previous/next directory
# </> ignores those directories whose name begin with a dot
nmap <buffer><nowait><silent>   <	<Plug>(netrw-prev-dir)
nmap <buffer><nowait><silent>   >	<Plug>(netrw-next-dir)
nmap <buffer><nowait><silent>   {	<Plug>(netrw-prev-dirall)
nmap <buffer><nowait><silent>   }	<Plug>(netrw-next-dirall)

nnoremap <buffer><silent>   S	:S 

# Implements		{{{1
nnoremap <Plug>(netrw-prev-dir)    <ScriptCmd>Jumpdir(1)<CR>
nnoremap <Plug>(netrw-next-dir)    <ScriptCmd>Jumpdir(2)<CR>
nnoremap <Plug>(netrw-prev-dirall) <ScriptCmd>Jumpdir(3)<CR>
nnoremap <Plug>(netrw-next-dirall) <ScriptCmd>Jumpdir(4)<CR>

def Jumpdir(direction: number)
    # Move to the previous/next folder.
    # direction : number
    #	1, 2 -- move to the fold whose name not begin with a dot
    #   3, 4 -- similar to 1 and 2, but counts for all folds.
    var flags = 'sW'
    if direction == 1 || direction == 3
	flags ..= 'b'
    endif

    var pattern = '\m^.\+/$'
    if direction < 3
	pattern = '\m^\.\@!.*/$'
    endif

    search(pattern, flags)
enddef
#}}}
# netrw.vim	vim: ts=8 sw=4 fdm=marker

