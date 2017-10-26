" tex.vim	vim: ts=8 sw=4 ff=unix
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.6
" Last Change:	2017-10-23 15:36:17

let s:keepcpo= &cpo
set cpo&vim

let b:undo_ftplugin = "setl kp< sw< tw< isk< cfu<"

set keywordprg=texdoc
set sw=2 textwidth=78

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

nnoremap <buffer>   <C-F5>  :update<CR>:!pdflatex %<CR>

let s:latex_file = expand("<sfile>:p:h") . '/latex_command.txt'
if !bufloaded(s:latex_file)
    exec "vs +hide ".escape(s:latex_file, ' \')
endif
let s:basic_command = getbufline(s:latex_file, 1, "$")

function! Cmp_command(findstart, base)
    if a:findstart
	" locate the start of the \commands (control sequences)
	let line = getline('.')
	let curr = col('.') - 1
	let start = match(line, '^.*\zs\\')
	if start < 0 || start >= curr
	    " -2 To cancel silently and stay in completion mode.
	    let start = -2
	endif
	return start

    else
	" find \commands matching with "a:base"
	" \commands are come from local buffer and basic commands
	let local = []

	" reverse buffer to simulate the <C-P> behavior
	let buf = reverse(getbufline("%", 1, "$"))
	let curr= line(".")
	let buf = buf[-curr:] + buf[0:curr-1]

	call filter(buf, 'v:val =~ "\\\\\\a\\+"')
	for line in buf
	    let strpos = matchstrpos(line, '\\\a\+')
	    while strpos[0] != ""
		call add(local, strpos[0])
		let strpos = matchstrpos(line, '\\\a\+', strpos[2])
	    endwhile
	endfor

	return filter(local + s:basic_command,
		    \ 'v:val =~ "^\\\\'.a:base[1:].'"')
    endif
endfunction
set completefunc=Cmp_command


let &cpo = s:keepcpo
unlet s:keepcpo
