" Vim autoload script for convert ass to srt
" Maintainer:	Joe Ding
" Last Changed: 2014-06-06 12:27:56

function! ass2srt#Convert()
    f %:p:r.srt
    g!/Dialogue/d
    g+\\+d
    g/0:00:00\.00/d

    %s/[^,]*,\([^,]*\),\([^,]*\).*,/\10 --> 0\20###/
    %s/\./,/g

    for i in range(1, line('$'))
	call setline(i, string(i)."###0".getline(i))
    endfor

    g/^/norm o
    %s/###//g

    w ++ff=unix ++enc=utf-8
endfunction
