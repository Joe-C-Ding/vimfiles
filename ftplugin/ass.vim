" Vim filetype plugin file for ass.
" Maintainer:	Joe Ding
" Last Changed: 2012-08-09 00:01:21

if exists("b:my_ftpass") | finish | endif
let b:my_ftpass= 1

" to convert ass to srt.
nnoremap <silent><buffer> \c	:argdo call <SID>ass#Convert2Srt()<CR>

function! s:ass2srt#Convert() abort
    f %:p:r.srt
    g!/Dialogue/d
    g+\\+d
    g/0:00:00\.00/d

    %s/[^,]*,\([^,]*\),\([^,]*\).*,/\10 --> 0\20###/
    %s/\./,/g

    let l:text = getline(1,'$')->map({i,v -> string(i+1).'###0'.v})
    call setline(1, l:text)

    g/^/norm o
    %s/###/\r/g

    w ++enc=utf-8
endfunction
