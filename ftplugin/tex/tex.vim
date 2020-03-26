" tex.vim	vim: ts=8 sw=4
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.95
" Last Change:	2020-03-26 12:36:31

let s:keepcpo= &cpo
set cpo&vim

let b:undo_ftplugin = "setl kp< sw< tw< isk< cfu< fo< cpt< indk<"

set sw=2 textwidth=78
set fo-=t   " Don't wrap
set complete-=i	" Don't complete include files

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:
" set indentkeys-=[,(,{,),},]	" should set in after/


noremap <buffer><silent>   <C-F5>  :call Go()<CR>

function! Go()
    " if running in continuous mode, updating files will trigger compilation
    update

    " else we do need to start it.
    if !b:vimtex.compiler.is_running()
	VimtexCompile
    endif
endfunction

inoremap <silent><buffer> <F3>	<C-\><C-O>:call TexInsEnv()<CR>
function! TexInsEnv()
    put ='\begin{env}'
    put =''
    put ='\end{env}'

    norm =2kj
    norm cse
    norm cc
endfunction

let s:dir = expand("<sfile>:p:h") . '/'
nnoremap <silent><buffer> ;t	:call TexTemplate()<CR>
function! TexTemplate()
    exec "0r " . s:dir .  "paper_template.tex"
    norm G
    call search('>!<', 'bW')
    norm cc

    " copy preamble.template and config files to working dir
    " and touch refs.bib
    let files = ["preamble.template", ".gitignore", ".gitattributes"]
    for f in files
	let content = readfile(s:dir . f)
	call writefile(content, f)
    endfor
    call writefile([], "refs.bib", "a")
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
