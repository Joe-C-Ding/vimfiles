vim9script

# Language:	Vim-script
# Maintainer:	Joe Ding
# Version:	0.1  
# Last Change:	2025-05-03 09:47:08

# Elink()	{{{1
if get(g:, 'Elinkdir', '') is ''
    g:Elinkdir = 'D:/Links/'
endif

export def Elink(lk: string)
    if !has('win32')
	echohl WarningMsg
	echo 'Elink() is only supported on Windows.'
	echohl NONE
	return
    endif

    var link = lk
    if empty(lk)
	exec $"!start {getcwd()}"
	return
    elseif lk !~? '\.lnk$'
	link ..= '.lnk'
    endif

    const filename = g:Elinkdir .. link
    if filereadable(filename)
	exec "e" filename
    else
	echohl WarningMsg | echom "Shortcut not exists:" lk | echohl None
    endif
enddef

export def Ecomplete(L: string, C: string, P: string): string	# {{{2
    return glob(g:Elinkdir .. '*.lnk', 0, 1)
	->map((k, v): string => fnamemodify(v, ':t:r'))
	->join("\n")
enddef

export def SearchOpen(pattern: string,	# {{{1
	depth: number, with_dir: bool)
    # find files whose name matches `pattern` under current and sub-directory
    # within `depth`.
    var pat = substitute(pattern, '\*', '.*', 'g')
	->substitute('?', '.', 'g')
	->substitute('\.', '.', 'g')
    var result = FindFiles([], pat, '.', depth, with_dir)
	->map((k, v) => fnamemodify(v, ':.'))

    var length = len(result)
    if length == 0
	echo $"file '{pattern}' is not found! (within {depth} levels of depth)"
	return
    endif

    for i in range(1, length)
	echo $'{i}: {result[i - 1]}'
    endfor

    var choice: string = input("edit [^C/<num>/all]? ", '1')
    var nr: number = str2nr(choice)
    if nr > 0 && nr <= length
	exec "e" fnameescape(result[nr - 1])
    elseif choice =~? 'a\%[ll]'
	exec $"0argadd {map(result, (k, v) => fnameescape(v))->join()}"
	rewind
    endif
enddef

def FindFiles(result: list<string>, pattarn: string,		# {{{2
	dir: string, depth: number, with_dir: bool): list<string>
    if depth > 0
	for f in readdir(dir)
	    if f[0] == '.' | continue | endif

	    const fullf = $'{dir}/{f}'
	    if isdirectory(fullf)
		if with_dir && f =~ pattarn
		    add(result, fullf)
		endif
		sil FindFiles(result, pattarn, fullf, depth - 1, with_dir)
	    elseif f =~? pattarn
		add(result, fullf)
	    endif
	endfor
    endif
    return result
enddef

export def BuildHelp()	# {{{1
    # Copy package docs to ./doc, and build help tags for them.  
    var save_dir = chdir($"$HOME/{has('win32') ? 'vimfiles' : '.vim'}")
    if empty(save_dir)
	return
    endif

    echo 'Building help tags for packages...'
    for txt in glob('pack/**/doc/*.txt', false, true)
	if filecopy(txt, $'doc/{fnamemodify(txt, ":t")}')
	    echo "\t" txt
	else
	    echo " skip!" txt
	endif
    endfor
    sil! helptags doc
    echo 'done.'

    chdir(save_dir)
enddef

export def SortRegion(beg: string, end: string,	# {{{1
	keepcase: bool = false)
    def SortCmp(a: string, b: string, kc: bool): number
	var trim_a = trim(a)->iconv(&enc, 'chinese')
	var trim_b = trim(b)->iconv(&enc, 'chinese')

	if !kc
	    trim_a = toupper(trim_a)
	    trim_b = toupper(trim_b)
	endif

	return trim_a <= trim_b ? -1 : 1
    enddef

    getline(beg, end)
	->sort((a, b) => SortCmp(a, b, keepcase))
	->setline(beg)
enddef

export def Next(reverse: bool, file: bool)	# {{{1
    # priority: location list > quickfix list > arguments
    var prefix = ''
    if getloclist(0, {size: 0}).size > 0
	prefix = 'l'
    elseif getqflist({size: 0}).size > 0
	prefix = 'c'
    endif

    var cmd = reverse ? 'N' : 'n'
    var suffix = file ? 'file' : 'ext'

    try
	exec $'{prefix}{cmd}{suffix}'
    catch /^Vim\%((\a\+)\)\=:E/
	echohl WarningMsg | echom v:exception | echohl None
    endtry
enddef

# Backspace()	{{{1
var pairs = {
    '"': '"',
    "'": "'",
    '(': ')',
    '[': ']',
    '{': '}',
    '<': '>',
    '（': '）',
    '「': '」',
}

export def Backspace(): string	# {{{2
    var line = getline('.')
    var col = col('.') - 1
    var char = line[col - 1]

    var keys = "\<BS>"
    if get(pairs, char, 'xx') == line[col]
	keys ..= "\<DEL>"
    endif
    return keys
enddef

defcompile
# utilities.vim	vim: ts=8 sw=4 fdm=marker
