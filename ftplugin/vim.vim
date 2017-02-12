" vim.vim	vim: ts=8 sw=4
" Vim filetype plugin
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.8
" Last Change:	2016-10-26 16:39:27

nnoremap <buffer>   <C-F5>  m`ggVG"ay``:@a<CR>

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
