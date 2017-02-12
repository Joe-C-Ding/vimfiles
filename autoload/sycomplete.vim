" Vim completion script for sy-rec
" Language:	seiyu-record
" Maintainer:	Joe Ding
" Version:	2.3
" Last Changed: 2016-02-25 08:30:43

let s:data_base = '~/vimfiles/.about anime/data/seiyu'
let s:search_root = '~/vimfiles/.about anime/s 声優资料/'

if !exists("*s:Cons_db")
    let s:db = {}

    function s:Cons_db()
	" Only construct for empty dictionary.
	" This dictionary may be modified during editing, so rebuilt it may
	" lose those informations.
	if !empty(s:db) | return | endif

	if bufloaded(s:data_base) == 0
	    silent exe "vs +hide " . escape(s:data_base, ' \')
	endif

	" the 1st line of the data_base is the `vim: modelines'.
	let ls = getbufline(s:data_base, 2, "$")
	for item in ls
	    if item == "" | continue | endif
	    let t = split(item, "\t", 1)
	    let s:db[t[0]] = t
	endfor
    endfunction

    call s:Cons_db()  " Construct this table right now.
endif

" Omni-function for sy-recoder
" It can do more than completing the names, but also lists the 
" yomikata for each cadidate (if it exist in database).
let s:name	= '^\%([^：]*：\s*\)\@>\zs[^（]*\S\@<='
let s:lines	= '^\t\S[^-]* ---- \%([^(＆]*＆\)*\zs.*'
let s:posit	= '^\%(作詞\|作曲\|詞曲\|作編曲\|編曲\)\t$'
let s:type	= 'unknown'

function! sycomplete#Complete(findstart, base)
    if a:findstart
	let line = getline('.')

	" Check what category is completing for
	if line[col('.')-2] == '*'
	    let s:type = 'symbol' | return col('.')-2

	elseif line =~ s:name
	    let s:type = 'name' | return match(line, s:name)

	elseif line =~ s:lines
	    if col('$') - col('.') < 3
		let s:type = 'lines_no'
	    else
		let s:type = 'lines'
	    endif
	    return match(line, s:lines)

	elseif line =~ s:posit
	    let s:type = 'position' | return 0

	else
	    let s:type = 'unknown' | return -1
	endif
    endif

    " Completing for each category.
    if s:type == 'name'
	" If base is empty string, do noting.
	" Becase there are more than thousands candidates for it.
	if a:base == "" | return [] | endif

	let items = []
	for [key, value] in items(s:db)
	    if key =~ "^" . a:base
		call add(items, {'word': value[0], 'menu': get(value, 1, "")})
	    endif
	endfor
	return items

    elseif s:type =~ 'lines'	" Handle both 'lines' and 'lines_no'
	let items = getbufline(bufnr('%'), 1, '$')
	" This pattern is extremely complex. But it is just two parts.
	" to filter name from characters list and characters' lines.
	" TODO: for extracting char's name from lines, now can only extract
	"	the first name. (In most case, this is not a matter.)
	let l:pat = '^\s*\zs' . a:base . '[^：]*\S\@<=\ze.*：'
		\ . '\|^\t\S[^-]*---- \zs' . a:base . '[^(＆]*\S\@<='
	call map(items, "matchstr(v:val, \'".l:pat."\')")
	call s:Unique(items)
	if s:type == 'lines_no'
	    let num = substitute(getline(2), '^#[^#]*#\s*\(\d\+\%(\.5\)\=\).*', '\1', '')
	    if getline(2) != num	" if substitution has performed
		call map(items, 'v:val . "(" . num . ")"')
		call add(items, a:base . "(" . num . ")")
	    endif
	endif
	return items

    elseif s:type == 'position'
	return ["詞曲\t", "作編曲\t", "作詞\t", "作曲\t", "編曲\t"]

    elseif s:type == 'symbol'
	return ["～", "々", "・", "·", "＆", "／", "♡", "☆", "★", "♪", "♫", "∞"]

    else
	return []
    endif
endfunction

" TODO: This functions seems no useful.
function! sycomplete#Addinfo()
    "extract the name, then open db and jump to that line.
    let who = "^" . matchstr(getline('.'), s:name)
    if who == "^" | return | endif
    exec 'rightbelow vs +/' . escape(who, ' ') . ' ' . escape(s:data_base, ' ')
endfunction

function! sycomplete#Preview()
    let name = matchstr(getline('.'), s:name)

    if name == ""	" this line not contains seiyu's name
	echohl Error
	echo "Can't locate seiyu's name in this line"
	echohl None
	return
    endif

    " else search the name in database
    let found = 0
    for [key, value] in items(s:db) " Handling the case of namesake
	if key =~ "^" . name
	    let found = 1
	    if len(value) < 3
		echo key . ": No more informations.\n\n"
	    else
		echo value[0] . "（" . value[1] . "）"
		let value = split(value[2], ';')
		echo "本名：" . value[0] . "\t誕生日：" . value[1]
		echo "曾用名或愛称：" . value[2]
		echo value[3] . "\n\n"
	    endif
	endif
    endfor

    if found == 0
	echohl Error
	echo "Can't find `" . name . "' in database. "
	echohl None
    endif
endfunction

function! s:Unique( list )
    " Usually the parameters of a function cannot be changed, but this
    " functions changes the contents of them. (which means change in-place)
    call sort(a:list)
    let i = 0
    " The lenth of the list may be shortened in the loop
    while i < len(a:list)
	while ( i+1 < len(a:list) && a:list[i] == a:list[i+1] )
	    call remove(a:list, i+1)
	endwhile
	let i += 1
    endwhile
    " if there is a empty item, remove it.
    if !empty(a:list) && a:list[0] == ""
       	call remove(a:list, 0)
    endif
    return a:list
endfunction


function! s:Aux_cmp (x, y)
    let lx = len(a:x)
    let ly = len(a:y)

    if lx == 0 | return ly == 3 ? -1 : 1 | endif
    if ly == 0 | return lx == 3 ? 1 : -1 | endif

    if lx != ly
	return lx < ly ? -1 : 1
    else
	return a:x[0] < a:y[0] ? -1 : 1
    endif
endfunction

function! s:Checkin()
    " Change to the buffer of db, and make a backup of it.
    let ls = getbufline(bufnr('%'), 1, '$')
    exe "buf " . escape(s:data_base, ' \')
    silent exe "w! " . escape(s:data_base, ' \') . "~"
    1,$d _

    for item in ls
	if item == "" || item[0] == '#'
	    continue
       	endif
	let t = split(item, "\t", 1)
	let s:db[t[0]] = t
    endfor
    let s:db["-"] = []

    let i = 1
    for value in sort(values(s:db), "s:Aux_cmp")
	call setline(i, join(value, "\t"))
	let i += 1
    endfor
    " The "# vim" and the ":" must be separate or it will confuse vim.
    call append(0, "# vim". ": ft=sydata ts=24 sts=0 nowrap")

    write
endfunction

function! sycomplete#Check()
    let add = []
    let cpl = []
    let mod = []

    let ln = getbufline(bufnr('%'), 1, '$')
    call map(ln, "matchstr(v:val, \'" . s:name . "\')")
    call s:Unique(ln)

    for name in ln
	if !has_key(s:db, name)
	    call add(add, name)
	elseif len(s:db[name]) < 3
	    call add(cpl, join(s:db[name], "\t"))
	else
	    call add(mod, join(s:db[name], "\t"))
	endif
    endfor

    leftabove new
    setl buftype=nofile ft=temp
    so ~/vimfiles/ftplugin/sydata.vim
    so ~/vimfiles/syntax/sydata.vim
    nnoremap <buffer> q :call <SID>Checkin()<CR>

    call append(line('0'), insert(add, "# Those didn't find in database:"))
    call append(line('$'), insert(cpl, "# Those of which the informations are not complete:"))
    call append(line('$'), insert(mod, "# Those you may need to check the correctness of the informations:"))
endfunction

function! sycomplete#Grep( name )
    let l:result = []
    "for [key, value] in items(s:db)
    "    if key =~ "^" . a:name
    "        call add(l:result, key)
    "        if len(s:db[key]) >= 3
    "    	let t = split(split(value[2], ';')[2], '　')
    "    	call extend(l:result, t)
    "        endif
    "    endif
    "endfor
    "if l:result == [] | call add(l:result, a:name) | endif

    "call s:Unique(l:result)
    "exe "lvimgrep /".join(l:result, '\|')."/j ".escape(s:search_root, ' \')."/**/*"
    "
    exe "lvimgrep /".a:name."/j ".escape(s:search_root, ' \')."**"

    exe "lcd ".escape(s:search_root, ' \')
    let l:result = getloclist(0)
    call map(l:result, 'fnamemodify(bufname(v:val.bufnr), ":.").":".substitute(v:val.text, "^\\s*", "", "")')
    return s:Unique(l:result)
endfunction
