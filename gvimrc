" Make external commands work through a pipe instead of a pseudo-tty
set noguipty

try
  if has('win32')
    set guifont=DejaVu_Sans_Mono:h16
    set guifontwide=MS_Gothic:h16
  else
    set guifont=Monospace\ 15
  endif
endtry

set cmdheight=2		" Make command line two lines high
set mousehide		" Hide the mouse when typing text

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500 && !exists("syntax_on")
    syntax on
endif
