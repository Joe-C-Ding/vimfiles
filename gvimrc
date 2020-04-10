" Make external commands work through a pipe instead of a pseudo-tty
set noguipty

" if the fonts are not available, just ignore it and use the default.
if has('win32')
    try
	set guifont=DejaVu_Sans_Mono_for_Powerline:h16
    catch /^Vim(set):/
	let g:airline_powerline_fonts = 0
	sil! set guifont=DejaVu_Sans_Mono:h16
    endtry
    sil! set guifontwide=MS_Gothic:h16
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
