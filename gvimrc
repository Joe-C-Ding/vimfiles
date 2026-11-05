" Make external commands work through a pipe instead of a pseudo-tty
set noguipty

" if the fonts are not available, just ignore it and use the default.
if has('win32')
    try
	set guifont=DejaVu_Sans_Mono_for_Powerline:h14
    catch
	let g:airline_powerline_fonts = 0
	sil! set guifont=DejaVu_Sans_Mono:h14
    endtry
    sil! set guifontwide=MS_Gothic:h14

    " set double width characters.
    "	circled 1 -- 9 (①--⑨)
    "	horizontal ellipsis (…)
    "	black & white star (★, ☆)
    "	reference mark (※)
    call setcellwidths([
		\ [0x2460, 0x2468, 2],
		\ [0x2026, 0x2026, 2],
		\ [0x2605, 0x2606, 2],
		\ [0x203b, 0x203b, 2],
		\])

elseif has('mac')
    " MacVim seems to remember the window size of last use, so it's good to
    " set the default size here.
    set lines=27 columns=85

    try
	set guifont=DejaVuSansMonoPowerline:h18
    catch
	let g:airline_powerline_fonts = 0
	sil! set guifont=DejaVuSansMono:h18
    endtry
else
    sil! set guifont=Monospace\ 14
endif

set cmdheight=2		" Make command line two lines high
set mousehide		" Hide the mouse when typing text

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500 && !exists("syntax_on")
    syntax on
endif
