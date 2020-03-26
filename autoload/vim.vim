" vim.vim	vim: ts=8 sw=4
" Maintainer:	Joe Ding
" Version:	0.5
" Last Change:	2020-03-26 12:50:28

let s:cpo_save = &cpo
set cpo&vim

function! vim#Writeheader(file) abort
    if a:file =~# substitute($VIMRUNTIME, '\\', '/', 'g')
	return
    endif
    let lines = getline(1, 20)

    let chng = match(lines, 'Version:\c')
    if chng >= 0
	let vers = matchstr(lines[chng], ':\s*\zs.*')
	let vers = input("Version? ", vers)
	call setline(chng+1, "\" Version:\t".vers)
    endif

    let chng = match(lines, 'Last Change:\c')
    if chng >= 0
	call setline(chng+1, "\" Last Change:\t".strftime('%Y-%m-%d %H:%M:%S'))
    endif
endfunction

function! vim#InsertTemplate() abort
    let plugin = expand('%:t:r')

    put ='\" '.expand('%:t').'	vim: ts=8 sw=4 fdm=marker'
    put ='\" Language:	Vim-script'
    put ='\" Maintainer:	Joe Ding'
    put ='\" Version:	0.1'
    put ='\" Last Change:	'.strftime('%Y-%m-%d %H:%M:%S')
    put =''
    put ='if &cp \|\| exists(\"g:loaded_'.plugin.'\")'
    put ='    finish'
    put ='endif'
    put ='let g:loaded_'.plugin.' = 1'
    put =''
    put ='let s:save_cpo = &cpo'
    put ='set cpo&vim'
    put =''
    put ='>!<'
    put =''
    put ='let &cpo = s:save_cpo'
    put ='unlet s:save_cpo'

    1d_	" remove the blank 1st line
    norm! G
    call search('>!<', 'bW')
    norm "_d3l
endfunction

function! vim#Vim2html()
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
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
