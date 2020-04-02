" cterm_color.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-04-02 12:25:28

let s:save_cpo = &cpo
set cpo&vim

let s:cterm_color =<< END
0	Black
1	DarkBlue
2	DarkGreen
3	DarkCyan
4	DarkRed
5	DarkMagenta
6	Brown, DarkYellow
7	LightGray, LightGrey, Gray, Grey
8	DarkGray, DarkGrey
9	Blue, LightBlue
10	Green, LightGreen
11	Cyan, LightCyan
12	Red, LightRed
13	Magenta, LightMagenta
14	Yellow, LightYellow
15	White
Black
DarkBlue
Blue
LightBlue
DarkCyan
Cyan
LightCyan
DarkGray
Gray
LightGray
DarkGreen
Green
LightGreen
DarkMagenta
Magenta
LightMagenta
DarkRed
Red
LightRed
Brown
DarkYellow
Yellow
LightYellow
White
END

if line("$") != 1 || getline(1) != ""
  noswapfile vnew
endif

setl bt=nofile bh=wipe noswf ts=16 nospell
f cterm_color

syntax clear

%d_

for i in range(0, len(s:cterm_color)-1)
    let s:color = split(s:cterm_color[i], "\t")
    let s:name = printf('color%02d', i)
    let s:line = s:color[0].."\t"..s:name
    let s:guifg = s:color[0]
    if len(s:color) > 1
	let s:line ..= "\t"..s:color[1]
	let s:guifg=split(s:color[1], ', ')[0]
    end

    call setline(i+1, s:line)
    exec 'syn keyword '.s:name.' '.s:name
    exec 'hi '.s:name.' ctermfg='.s:color[0].' guifg='s:guifg
endfor

let &cpo = s:save_cpo
unlet s:cterm_color s:color s:save_cpo
