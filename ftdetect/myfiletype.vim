" myfiletype.vim	vim: ts=8 sw=4 ff=unix
" Vim filetype-detect file.
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.3
" Last Change:	2017-08-28 09:35:00

augroup myft
    au BufNewfile,BufRead *.sy	setf sy
    if has('win32')
	au BufNewfile,BufRead ~/vimfiles/.anime/s\ 声優资料/* setf sy
    else
	au BufNewfile,BufRead ~/Documents/.about\ anime/s\ 声優资料/* setf sy
    endif

    au BufNewfile,BufRead *.ass	setf ass

    au BufRead *.vim	call s:Addheader()
    au BufWrite *.vim	call s:Writeheader()
augroup END

function s:Addheader()
    let lines = getline(1, 10)

    let m = match(lines[0], '\s\+vim:')
    if m == -1
	call append(0, '" '.expand("%:p:t")."\tvim: ts=8 sw=4 ff=unix")
    endif

    let m = match(lines, 'Language\c')
    if m == -1
	call append(1, "\" Language:\tVim-script")
    endif

    let m = match(lines, 'Maintainer\c\|Author\c')
    if m == -1
	call append(2, "\" Maintainer:\tJoe Ding")
    endif

    let m = match(lines, 'Version\c')
    if m == -1
	call append(3, "\" Version:\t0.1")
    endif

    let m = match(lines, 'Last Change\c')
    if m == -1
	call append(4, "\" Last Change:\t".strftime('%Y-%m-%d %H:%M:%S'))
    endif
endfunction

function s:Writeheader()
    let lines = getline(1, 10)

    let chng = match(lines, 'Version\c')
    if chng == -1
	call s:Addheader()
    else
	let vers = matchstr(lines[chng], ':\s*\zs.*')
	let vers = input("Version? ", vers)
	if vers < 0
	    return
	endif
	call setline(chng+1, "\" Version:\t".vers)

	let chng = match(lines, 'Last Change\c')
	call setline(chng+1, "\" Last Change:\t".strftime('%Y-%m-%d %H:%M:%S'))
    endif
endfunction
