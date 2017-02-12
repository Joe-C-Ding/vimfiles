" vim-script: spectrum.vim
" Last change:	2014/04/08 10:43:36

if exists("*Spect") | finish | endif

" 定义文件名的前缀。
" NOTE: 注意，两端的引号不要去掉。
let s:prefix = '12'

" 定义要复制的通道。
" 要想复制非连续通道，请写： range(1, 5) + range(11, 16)
" NOTE: 注意，所有标点均为英文模式下的半角标点。
let s:range = range(1, 10)

let s:dir_pattern = '.*'
function! s:CheckDir ( dir )
    let l:dir = (empty(a:dir) ?  expand('%:p') : a:dir)
    if getftype(l:dir) != "dir"
	let l:dir = fnamemodify(l:dir, ":h")
    endif

    if l:dir !~? s:dir_pattern
	let l:dir = input("dir: ", expand('%:p'), "file")
    endif

    return l:dir
endfunction

let s:perfix_pattern = '*.csv'
function! spectrum#Cmpl(A, L, P)
    let l:list = glob(s:perfix_pattern, 0, 1)

    call map(l:list, 'substitute(v:val, "\\(.*\\)_\\d*\\.csv", "\\1", "")' )
    return s:Uniq(l:list)
endfunction

function! s:Uniq( list )
    call sort( a:list )

    let i = 0
    while ( i < len(a:list) )
	let ii = i + 1
	while (ii < len(a:list) && (a:list[ii] == a:list[i]))
	    call remove(a:list, ii)
	endwhile
	let i += 1
    endwhile

    if !empty(a:list) && empty(a:list[0])
	call remove(a:list, 0)
    endif
    return a:list
endfunction

function! s:Trans(a)
    let l:b = []
    let l:r = len(a:a)
    let l:l = 16	"len(a:a[0])

    for i in range(1, l:l)
	call add(l:b, repeat([0], l:r))
    endfor

    for i in range(0, l:r-1)
	for j in range(0, l:l-1)
	    let l:b[j][i] = a:a[i][j]
	endfor
    endfor

    return b
endfunction

function! spectrum#Spect ( dir )
    let l:dir = s:CheckDir( a:dir )
    exec "lcd ". l:dir

    let s:prefix = input("perfix? ", "", "customlist,spectrum#Cmpl")

    let regsav = getreg('a')
    let regmod = getregtype('a')
    call setreg('a', '')

    for i in s:range
	let l:filename = s:prefix . printf("_%02d", i) . ".csv"
        if !filereadable(l:filename)
	    let @a .= repeat(repeat("\t", 15)."\n", 2)
        else
            silent exe "pedit +set\\ noswapfile\\ bh=wipe\\ bt=nowrite ".l:filename
            wincmd P

            silent 1,10d _
            silent 2,4d _
	    %s/^0\?,//

            let line1 = split(getline(1), ',')
            call map(line1, 'printf("%f", str2float(v:val)/2)')
            call setline(1, join(line1, "\t"))

            let line2 = split(getline(2), ',')
            call map(line2, 'printf("%d", float2nr(str2float(v:val)))')
            call setline(2, join(line2, "\t"))

            silent %d A
        endif
    endfor

    " transfer the contents of `@a'
    let a = split(@a, "\n")
    call map(a, 'split(v:val, "\t", 1)')
    let a = s:Trans(a)
    call map(a, 'join(v:val, "\t")')
    let @a = join(a, "\n")

    call setreg('+', @a)
    call setreg('a', regsav, regmod)
    close
endfunction
