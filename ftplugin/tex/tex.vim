" tex.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.95
" Last Change:	2020-06-22 10:23:56

" Vimtex: {{{1
let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'jobs',
    \ 'background' : 1,
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

if has('win32')
  let g:vimtex_view_general_viewer = 'SumatraPDF'
  let g:vimtex_view_general_options =
	\'-reuse-instance -forward-search @tex @line @pdf'
  let g:vimtex_view_general_options_latexmk = '-reuse-instance'
else
  let g:vimtex_view_general_viewer = 'okular'
  let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
  let g:vimtex_view_general_options_latexmk = '--unique'
endif

let g:tex_conceal='abdmgs'

packadd vimtex
runtime PACK ftplugin/tex.vim
" }}}1

let s:keepcpo= &cpo
set cpo&vim

let s:undo_cmd = "setl sw< tw< isk< fo< cpt< | silent! unmap ;t | silent! unmap <C-F5>"
if get(b:, 'undo_ftplugin', '') != ''
    let b:undo_ftplugin .= '| ' .. s:undo_cmd
else
    let b:undo_ftplugin = s:undo_cmd
endif

set sw=2 textwidth=78
set fo-=t   " Don't wrap
set complete-=i	" Don't complete include files

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:


noremap <buffer><silent>   <C-F5>  :call Go()<CR>

function! Go()
    " if running in continuous mode, updating files will trigger compilation
    update

    if get(b:, 'vimtex.compiler', {}) == {}
	echohl WarningMsg
	echo vimtex compiler not exist.
	echohl None

    " else if the compiler is not running, start it.
    else !b:vimtex.compiler.is_running()
	VimtexCompile
    endif

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
