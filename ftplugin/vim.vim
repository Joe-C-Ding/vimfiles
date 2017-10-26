" vim.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.8
" Last Change:	2017-10-23 23:05:22

nnoremap <buffer>   <C-F5>  m`ggVG"ay``:@a<CR>
vnoremap <buffer>   <C-F5>  "ay:@a<CR>gv

if exists("*Vim2html")
    finish
endif

command -nargs=0  Vim2html  :call Vim2html()
function Vim2html()
    let reg_av = getreg("a")
    let reg_ao = getregtype("a")

    TOhtml

    1; /^pre {.*}/
    let sub = matchstr(getline("."), '\%(\S*:\s*\S*;\s*\)\+')
    exec '%s+^<pre .*>+<div style="'.sub.'">+'
    %s+</pre>+</div>+

    1; /\* {.*}/+1
    let begin = line(".")
    /^-->/-1
    let end = line(".")

    let lines = getline(begin, end)
    for l in lines
	let cls = matchstr(l, '^\.\zs\S*')
	let sub = matchstr(l, '\%(\S*:\s*\S*;\s*\)\+')

	exec '%s+class="'.cls.'"+style="'.sub.'"+g'
    endfor

    1; /<div .*>/-1 d_
    /<\/div>/+1,$ d_

    call setreg("a", reg_av, reg_ao)
endfunction

au BufRead *.vim	call s:Addheader(expand("<afile>:p"))
au BufWrite *.vim	call s:Writeheader(expand("<afile>:p"))

function s:Addheader(file)
    if a:file =~ substitute($VIMRUNTIME, '\\', '/', 'g')
	return
    endif

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

function s:Writeheader(file)
    if a:file =~ substitute($VIMRUNTIME, '\\', '/', 'g')
	return
    endif

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
