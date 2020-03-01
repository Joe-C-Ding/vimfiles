" netrw.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.52
" Last Change:	2020-02-29 11:31:37

" move to the previous/next directory
" </> ignores those directories whose name begin with a dot
nmap <buffer><nowait><silent>   <	<Plug>(netrw-prev-dir)
nmap <buffer><nowait><silent>   >	<Plug>(netrw-next-dir)
nmap <buffer><nowait><silent>   {	<Plug>(netrw-prev-dirall)
nmap <buffer><nowait><silent>   }	<Plug>(netrw-next-dirall)
nmap <buffer><nowait><silent>   c	<Plug>(netrw-open-terminal)

nnoremap <buffer><silent> <Plug>(netrw-prev-dir)    :call <SID>Jumpdir(1)<CR>
nnoremap <buffer><silent> <Plug>(netrw-next-dir)    :call <SID>Jumpdir(2)<CR>
nnoremap <buffer><silent> <Plug>(netrw-prev-dirall) :call <SID>Jumpdir(3)<CR>
nnoremap <buffer><silent> <Plug>(netrw-next-dirall) :call <SID>Jumpdir(4)<CR>
nnoremap <buffer><silent> <Plug>(netrw-open-terminal)	:call <SID>Msys()<CR>


" Jumpdir: move to the next fold for plugin netrw
" direction: 1, 2 -- move to the fold whose name not begin with a dot
"	     3, 4 -- similar to 1 and 2, but counts for all folds.
function s:Jumpdir ( direction )
    let l:flags = 'sW'
    if a:direction == 1 || a:direction == 3
	let l:flags .= 'b'
    endif

    if a:direction < 3
	let l:pattern = '\m^\.\@!.*/$'
    else    " elseif a:direction < 5
	let l:pattern = '\m^.\+/$'
    end
	
    call search(l:pattern, l:flags)
endfunction

function s:Msys()
    if has('win32')
	!start cmd /k
    else
	!bash
    end
endfunction
