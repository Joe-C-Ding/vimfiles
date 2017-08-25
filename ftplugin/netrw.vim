" netrw.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2017-08-22 10:32:07

" nmap ,s	:call spectrum#Spect("")<CR>

nnoremap <silent>   <	:call Jumpdir(1)<CR>
nnoremap <silent>   >	:call Jumpdir(2)<CR>

nnoremap <silent>   e	:exec '!explorer "'.getcwd().'"'<CR>

function Jumpdir ( dir )
    let l:flags = 'sW'
    if a:dir == 1 | let l:flags .= 'b' | endif

    call search('^.*\%(\.\.\=\)\@<!/$', l:flags)
endfunction
