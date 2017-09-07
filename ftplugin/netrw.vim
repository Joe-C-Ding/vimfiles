" netrw.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.2
" Last Change:	2017-08-26 22:33:21

" nmap ,s	:call spectrum#Spect("")<CR>

nnoremap <buffer><silent>   <	:call Jumpdir(1)<CR>
nnoremap <buffer><silent>   >	:call Jumpdir(2)<CR>

nnoremap <buffer><silent>   e	:exec '!explorer "'.getcwd().'"'<CR>

function Jumpdir ( dir )
    let l:flags = 'sW'
    if a:dir == 1 | let l:flags .= 'b' | endif

    call search('^.*\%(\.\.\=\)\@<!/$', l:flags)
endfunction
