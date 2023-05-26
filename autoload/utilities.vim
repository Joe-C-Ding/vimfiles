" vim: ts=8 sw=4 fdm=marker
" Author:	Joe Ding
" Last Change:	2023-01-09 21:03:19

function! utilities#CleanDownload() abort	" {{{1
    let l:save_cwd = fnameescape(getcwd())
    exec "lcd " .. (has('win32') ? 'E:/Downloads/' : '$HOME/Downloads')

    let l:files = glob('5MB_file*', 0, 1)
    call extend(files, glob('**/*.torrent', 0, 1))

    for f in l:files
	sil! call delete(f)
    endfor

    exec "lcd " . l:save_cwd
endfunction

" utilities#Elink()	{{{1
if get(g:, 'Elinkdir', '') is ''
    let g:Elinkdir = 'D:/Links/'
endif

function utilities#Elink(lk) abort
    if !has('win32')
	echo 'Elink() is only supported on Windows.'
	return
    endif

    if empty(a:lk)
	exec "!start " .. getcwd()
	return

    elseif a:lk !~? '\.lnk$'
	let l:link = a:lk .. ".lnk"
    else
	let l:link = a:lk
    endif

    let filename = g:Elinkdir .. l:link
    if filereadable(filename)
	exec "e ".filename
    else
	echohl WarningMsg | echom "Shortcut not exists:" a:lk | echohl None
    endif
endfunction

function utilities#Ecomplete(ArgLead, CmdLine, CursorPos) abort	" {{{2
    if !exists('s:links')
	let s:links = glob(g:Elinkdir.'*.lnk', 0, 1)
	call map(s:links, 'fnamemodify(v:val, ":t:r")')
	let s:links = join(s:links, "\n")
    endif

    return s:links
endfunction

function! utilities#SearchOpen(file, depth, with_dir) abort	" {{{1
    let l:file = substitute(a:file, '\*', '.*', 'g')
    let l:file = substitute(l:file, '?', '.', 'g')
    let l:file = substitute(l:file, '\.', '.', 'g')
    let files = s:FindFiles([], l:file, '.', a:depth, a:with_dir)->map({_,v -> fnamemodify(v, ':.')})

    let length = len(files)
    if length == 0
	echo 'file '''.a:file.''' is not found! (within '.a:depth.' levels of depth)'
	return
    endif

    for i in range(1, length)
	echo i.":"  files[i-1]
    endfor

    let choice = input("edit [^C/<num>/all]? ", 1)
    if choice > 0 && choice <= length
	exec "e " . fnameescape(files[choice-1])
    elseif choice =~? 'a\%[ll]'
	exec "0argadd ".join(map(files, 'fnameescape(v:val)'), ' ')
	rewind
    endif
endfunction

function! s:FindFiles(list, file, dir, depth, with_dir) abort	" {{{2
    if a:depth > 0
	for f in readdir(a:dir)
	    if f =~ '^\.' | continue | endif
	    let fullf = a:dir..'/'..f
	    if isdirectory(fullf)
		if !empty(a:with_dir) && f =~ a:file
		    call add(a:list, fullf)
		endif
		sil call s:FindFiles(a:list, a:file, fullf, a:depth-1, a:with_dir)
	    elseif f =~? a:file
		call add(a:list, fullf)
	    end
	endfor
    endif
    return a:list
endfunction

function! utilities#BuildHelp() abort	" {{{1
    let l:save_cwd = getcwd()
    exec 'lcd '.expand('$HOME/') .. (has('win32') ? 'vimfiles' : '.vim')

    echo 'Building help tags for packages...'
    sil! helptags doc
    for l:dir in glob('pack/*/*/*/doc', 0, 1)
	try
	    exec "helptags " .. l:dir
	    echo "\t" .. l:dir
	catch /^Vim\%((\a\+)\)\=:E/
	    echo " skip!" matchstr(v:exception, 'E\d*:') l:dir
	endtry
    endfor
    echo 'done.'

    echo 'Copying ftdetect files from packages...'
    let l:ftdetect = glob('pack/*/*/*/ftdetect/*.vim', 0, 1)
    for l:file in l:ftdetect
	echo "\t" .. l:file
	let l:content = readfile(l:file)
	call writefile(l:content, 'ftdetect/' .. fnamemodify(l:file, ':t'))
    endfor
    echo 'done.'

    exec 'lcd ' .. fnameescape(l:save_cwd)
endfunction

function! utilities#SortRegion(beg, end, keepcase='') abort	" {{{1
    function! s:SortCmp(a, b, keepcase) abort
	let l:a = trim(a:a)
	let l:b = trim(a:b)

	if empty(a:keepcase)
	    let l:a = toupper(l:a)
	    let l:b = toupper(l:b)
	endif

	return iconv(l:a, &enc, 'chinese') <= iconv(l:b, &enc, 'chinese') ? -1 : 1
    endfunction

    let l:text = getline(a:beg, a:end)->sort({a, b -> s:SortCmp(a,b,a:keepcase)})
    call setline(a:beg, l:text)
endfunction

function utilities#Next(reverse, file) abort	" {{{1
    " priority: location list > quickfix list > arguments
    if getloclist(0, #{size: 0}).size > 0
	let l:prefix = 'l'
    elseif getqflist(#{size: 0}).size > 0
	let l:prefix = 'c'
    else
	let l:prefix = ''
    end

    let l:cmd = a:reverse ? 'N' : 'n'
    let l:suffix = a:file ? 'file' : 'ext'

    try
	exec l:prefix..l:cmd..l:suffix
    catch /^Vim\%((\a\+)\)\=:E/
	echohl WarningMsg
	echom v:exception
	echohl None
    endtry
endfunction

" utilities#Backspace()	{{{1
let s:pairs = {
	\  '"': '"',
	\  "'": "'",
	\  '(': ')',
	\  '[': ']',
	\  '{': '}',
	\  '<': '>',
	\  '（': '）',
	\  '「': '」',
	\}

function! utilities#Backspace() abort	" {{{2
    let line = getline('.')
    let col = col('.') - 1
    let char = line[col-1]

    let keys = "\<BS>"
    if get(s:pairs, char, 'xx') == line[col]
	let keys .= "\<DEL>"
    endif
    return keys
endfunction

