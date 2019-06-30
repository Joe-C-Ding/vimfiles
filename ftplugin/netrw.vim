" netrw.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.52
" Last Change:	2019-05-06 10:54:41

" nmap ,s	:call spectrum#Spect("")<CR>

" jump to the previous/next directory
" </> ignores those directories whose name begin with a dot
nnoremap <buffer><silent>   <	:call <SID>Jumpdir(1)<CR>
nnoremap <buffer><silent>   >	:call <SID>Jumpdir(2)<CR>
nnoremap <buffer><silent>   {	:call <SID>Jumpdir(3)<CR>
nnoremap <buffer><silent>   }	:call <SID>Jumpdir(4)<CR>

if has('win32')
    nnoremap <buffer><silent>   e	:exec '!start /b '.substitute(getcwd(), '/', '\', 'g')<CR>
else
    nnoremap <buffer><silent>   e	:exec '!nautilus '.shellescape(getcwd()).' &'<CR>
endif
nnoremap <buffer><silent>   c	:call <SID>Msys()<CR>

function s:Jumpdir ( dir )
    let l:flags = 'sW'
    if a:dir == 1 || a:dir == 3
	let l:flags .= 'b'
    endif

    if a:dir < 3
	let l:pattern = '\m^\.\@!.*/$'
    else    " elseif a:dir < 5
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
