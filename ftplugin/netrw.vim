" netrw.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.4
" Last Change:	2018-05-02 16:19:48

" nmap ,s	:call spectrum#Spect("")<CR>

nnoremap <buffer><silent>   <	:call <SID>Jumpdir(1)<CR>
nnoremap <buffer><silent>   >	:call <SID>Jumpdir(2)<CR>

if has('win32')
    nnoremap <buffer><silent>   e	:exec '!start /b explorer '.substitute(getcwd(), '/', '\', 'g')<CR>
else
    nnoremap <buffer><silent>   e	:exec '!start /b explorer '.shellescape(getcwd())<CR>
endif
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
