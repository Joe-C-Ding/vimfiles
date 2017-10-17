" sy.vim	vim: ts=8 sw=4
" Vim filetype plugin file for my own use.
" Language:	seiyu-record
" Maintainer:	Joe Ding
" Version:	3.5
" Last Change:	2017-09-20 07:39:39

if exists("b:my_ftpsy") | finish | endif
let b:my_ftpsy = 1

"let b:undo_ftplugin = "setl ai< fdm< cot< ofu<"
setl ai fdm=marker

"autocmd to touch the time-stamp	{{{1
augroup syAutocmd
    au BufWinEnter <buffer>	call <SID>Modify()
    au BufWrite <buffer>	call <SID>Modify()
augroup END

" Variable for those functions		{{{2
let s:LM = "# Last modify:\t"
let s:ML = "# modification log: "

function! s:Modify()
    if &ft != 'sy' | return | endif

    " If there is no time stamp, add it.
    if getline(2) !~ s:LM
	call append(0, ["# Seiyu record.  This file is owned by Joe Ding.",
	    \ s:LM . "Create\t{{"."{1", ""])
	call append(line("$"), ["", "# vim: ft=sy ai"])
    endif

    call append(line("$")-1, s:ML . matchstr(getline(2), ':\t\zs.*'))
    call setline(2, s:LM . strftime('%Y-%m-%d %H:%M:%S', localtime()))

    " Consider this change not modifies the buffer.
    setl nomodified
endfunction	" }}}2

" some convenience map		{{{1
nnoremap <buffer> \m	:marks<CR>
nnoremap <buffer><silent> \d	:if !bufloaded(bufnr("dic.txt")) <bar> tabedit ~/dic.txt <bar> endif <CR>
nnoremap <buffer><silent> \s	:<C-u>call <SID>Grep("")<CR>
vnoremap <buffer><silent> \s	y:call <SID>Grep(getreg('"'))<CR>

function! s:Grep( keyword )	" {{{2
    if a:keyword == ""
	let l:key = matchstr(getline('.'), '：\s*\zs\S[^（]*\S\@<=')
	if l:key == ""    " means the above match failed.
	    let l:key = input("Search pattern? ", expand('<cword>'))
	endif
    else
	let l:key = a:keyword
    endif

    rightbelow vnew
    call append(0, "# grep mode -- key: " . l:key)
    call setline(line('$')+1, sycomplete#Grep(l:key))
    setl ft=grep
endfunction	" }}}2

" move around			{{{1
nnoremap <buffer><silent> <M-m> :call search('^歌\t', 'bsw')<CR>
nnoremap <buffer><silent> <M-l> :call search('^\t.* ---- ', 'bsw')<CR>
nnoremap <buffer><silent> <M-f> m':keepjumps norm G<CR>:call <SID>EpisodeMotion(3, 0)<CR>zt
nnoremap <buffer><silent> <M-g> :call CopyCast()<CR>
 noremap <buffer><silent> ]]	:<C-U>call <SID>EpisodeMotion(1, 1)<CR>
 noremap <buffer><silent> ][	:<C-U>call <SID>EpisodeMotion(2, 1)<CR>
 noremap <buffer><silent> [[	:<C-U>call <SID>EpisodeMotion(3, 1)<CR>
 noremap <buffer><silent> []	:<C-U>call <SID>EpisodeMotion(4, 1)<CR>

function! s:EpisodeMotion( direction, savepos )	" {{{2
    let l:open = '^\s*\n\zs' . repeat('=', 36)
    let l:close = '^\s*\n' . repeat('=', 36)
    let l:pattern = open
    let l:flags = 'W'

    if a:savepos == 1
	let l:flags .= 's'
    endif

    if ( a:direction == 3 || a:direction == 4 )	" [[ & []
	let l:flags .= 'b'
    endif
    if ( a:direction == 2 || a:direction == 4 )	" ][ & []
	let l:pattern = close
    endif

    call search(l:pattern, l:flags)
endfunction

function! CopyCast()	"{{{2
    if getline(".") !~ '^\s*$'
	keepjumps norm }
    endif

    let start = search('^\s*\n\zs' . repeat('=', 36), 'bnW')
    if start == 0 | return | endif

    let list = getbufline("%", start, line("."))

    " remove additional information with casts.
    call map(list, "substitute(v:val, '（.*）$', '', '')")

    " remove titles but not the number of this episode
    let list[1] = substitute(list[1], '^# \=\S\+\s\+\zs.*', '', '')
    let i = 2
    while list[i] !~ '^'.repeat('=', 36).'$'
	let i = i + 1
    endwhile
    if i > 2
	call remove(list, 2, i-1)
    endif

    let cast = join(list, "\n") . "\n"
    call setreg('*', cast, "V")
endfunction	" }}}2

" fill text			{{{1
" hit enter at the end of line trigger to fill character name as well as
" re-indent this line, so that the colon of each line will be aligned
inoremap <silent><buffer> ：	：<ESC>:call <SID>DoFillLine(0)<CR>a
inoremap <silent><buffer> <ESC>	<ESC>:call <SID>DoFillLine(0)<CR>

let s:charWidth = 8
let s:syRecorde = '^\s*\zs\([^：]\+\)\ze：'

function! s:DoFillLine (colpos)
    if a:colpos == 0
	let colpos = s:LastColonPos()
    else
	let colpos = a:colpos
    endif

    let line = getline('.')
    let char = matchstr(line, s:syRecorde)
    if char == ""
	return
    endif

    " save which character is under cursor
    " use strpart() to working on wchars
    let cursor = strpart(line, col('.')-1)

    " fill character to a desired width
    let width = strdisplaywidth(char)
    if width < s:charWidth
	let char = s:Adjust(char)
	let width = strdisplaywidth(char)
    endif

    " calculate indentation
    let indent = repeat(' ', colpos - width)
    let line = substitute(line, '^[^：]*', indent . char, "")
    call setline(line('.'), line)

    " jump to saved character
    call search(cursor, 'c', line('.'))
endfunction

function! s:LastColonPos ()
    "find the last line that contains character's record
    let line = search(s:syRecorde, 'bnWz')
    if line == 0
	return 12   " default position
    else
	" and return at which display-column the colon is
	let line = getline(line)
	let col = strdisplaywidth(matchstr(line, '^[^：]*'))
	return col
    endif
endfunction

function! s:Adjust (char)
    let length = strchars(a:char)
    let width = strdisplaywidth(a:char)

    if length == 1  " A_____
	let rslt = a:char . repeat(' ', s:charWidth - width)

    elseif length == 2	" A____A
	let rslt = strcharpart(a:char, 0, 1)
		\. repeat(' ', s:charWidth - width)
		\. strcharpart(a:char, 1, 1)

    elseif length == 3	" A_A__A
	let blank = (s:charWidth - width) / 2
	let rslt = strcharpart(a:char, 0, 1)
		\. repeat(' ', blank)
		\. strcharpart(a:char, 1, 1)
		\. repeat(' ', s:charWidth - width - blank)
		\. strcharpart(a:char, 2, 1)

    else    " AAA__
	let rslt = a:char . repeat(' ', s:charWidth - width)
    endif

    return rslt
endfunction


" insert text			{{{1
nnoremap <buffer><expr> ;a "I# <ESC>:put =repeat('=', 36)<CR>YkPjA"
nnoremap <buffer><silent> ;t	:call <SID>Touch()<CR>

function! s:Touch()	" {{{2
    update  " that will also trigger the autocmd for Modify()
    let l:pos = getpos('.')
    call cursor(line('$'), 1)
    call search('\t#\s*[0-9]\+', 'bW')
    let l:eps = str2nr(matchstr(getline('.'), '\t#\zs.*')) + 1
    let l:eps = input("episode? ", l:eps)
    if l:eps =~? '^\s*c\%[ontinue]$'
	let l:eps = " continue"
    elseif l:eps =~? '^\s*b\%[reak]$'
	let l:eps = " break"
    else
	let l:eps = printf("%02d", l:eps)
    endif
    call setline(2, s:LM . strftime('%Y-%m-%d %H:%M:%S', localtime()) . "\t#" . l:eps)
    call setpos('.', pos)
endfunction	" }}}2


inoremap <buffer><expr>   ;	col('.') == 1 ? "<C-o>:call <SID>InsertMusicHeader(';')<CR>" : ';'
inoremap <buffer><expr>   :	col('.') == 1 ? "<C-o>:call <SID>InsertMusicHeader(':')<CR>" : ':'
nnoremap <silent><buffer> ;m	:call <SID>InsertMusicHeader(';')<CR>i

function! s:InsertMusicHeader( pattern )	    " {{{2
    let l:save_cursor = getpos('.')
    if a:pattern == ';'
	put ='==== music ===='
	put =''
	put ='オープニングテーマ (01～)'
	put ='「>!<」'
	put ='作詞	'
	put ='作曲	'
	put ='編曲	'
	put ='歌	'
	put =''
	put ='エンディングテーマ (01～)'
	put ='「」'
	put ='作詞	'
	put ='作曲	'
	put ='編曲	'
	put ='歌	'
	put =''
    elseif a:pattern == ':'
	put ='挿入歌 (>!<)'
	put ='「」'
	put ='作詞	'
	put ='作曲	'
	put ='編曲	'
	put ='歌	'
	put =''
    else
	return setpos('.', l:save_cursor)
    endif
    call setpos('.', l:save_cursor)

    call search('>!<', 'cW', line('.')+7)
    norm 3x
endfunction	" }}}2


" set omni-completion		{{{1
setl completeopt=menuone
setl omnifunc=sycomplete#Complete
nnoremap <buffer> <M-a>	:<C-u>call sycomplete#Addinfo()<CR>
inoremap <buffer> <M-a>	<Esc>:call sycomplete#Addinfo()<CR>
nnoremap <buffer> <M-p>	:<C-u>call sycomplete#Preview()<CR>
inoremap <buffer> <M-p>	<Esc>:call sycomplete#Preview()<CR>
nnoremap <buffer> <M-c>	:<C-u>call sycomplete#Check()<CR>

" load buffers for completion commands. {{{2
let s:pdir = expand("%:p:h")
if fnamemodify(s:pdir, ":t") !~ '^\%(TVs\|Movies\|s 声優资料\)$'
    let s:files = glob(s:pdir."/*", 0, 1)
    for f in s:files
	if !filereadable(f) || bufexists(f) | continue | endif
	exe "badd ". fnameescape(f)
    endfor
endif


" vim: fdm=marker
