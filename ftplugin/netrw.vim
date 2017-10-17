" netrw.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.3
" Last Change:	2017-09-16 16:22:12

" nmap ,s	:call spectrum#Spect("")<CR>

nnoremap <buffer><silent>   <	:call <SID>Jumpdir(1)<CR>
nnoremap <buffer><silent>   >	:call <SID>Jumpdir(2)<CR>

nnoremap <buffer><silent>   e	:exec '!start /b explorer "'.getcwd().'"'<CR>
nnoremap <buffer><silent>   c	:call <SID>Msys()<CR>

function s:Jumpdir ( dir )
    let l:flags = 'sW'
    if a:dir == 1 | let l:flags .= 'b' | endif

    call search('^.*\%(\.\.\=\)\@<!/$', l:flags)
endfunction

function s:Msys()
    " make clipboard contents `cd cwd`
    let cwd = substitute(getcwd(), '\\', '/', 'g')
    let cwd = escape(cwd, ' ')
    call setreg("+", "cd " . cwd)

    !start /MIN c:\MinGW\msys\1.0\msys.bat
endfunction
