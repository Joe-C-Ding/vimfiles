nmap ,s	:call spectrum#Spect("")<CR>

nnoremap <silent>   <	:call Jumpdir(1)<CR>
nnoremap <silent>   >	:call Jumpdir(2)<CR>

function Jumpdir ( dir )
    let l:flags = 'sW'
    if a:dir == 1 | let l:flags .= 'b' | endif

    call search('^.*\%(\.\.\=\)\@<!/$', l:flags)
endfunction
