" vim: fdm=marker ts=8
" Author:	Joe
" Modified:	2013-10-15 20:32:16

" colors for mystatusline.vim
" s:coloralias {{{2
if &t_Co == '' || &t_Co <= 8	    " {{{3
    let s:coloralias = {
	\ 'black'          : 'NONE',
	\ 'white'          : 'NONE',
	\
	\ 'darkestgreen'   : 'NONE',
	\ 'darkgreen'      : 'NONE',
	\ 'mediumgreen'    : 'NONE',
	\ 'brightgreen'    : 'NONE',
	\
	\ 'darkestcyan'    : 'NONE',
	\ 'mediumcyan'     : 'NONE',
	\
	\ 'darkestblue'    : 'NONE',
	\ 'darkblue'       : 'NONE',
	\
	\ 'darkestred'     : 'NONE',
	\ 'darkred'        : 'NONE',
	\ 'mediumred'      : 'NONE',
	\ 'brightred'      : 'NONE',
	\ 'brightestred'   : 'NONE',
	\
	\ 'darkestpurple'  : 'NONE',
	\ 'mediumpurple'   : 'NONE',
	\ 'brightpurple'   : 'NONE',
	\
	\ 'brightorange'   : 'NONE',
	\ 'brightestorange': 'NONE',
	\
	\ 'gray0'          : 'NONE',
	\ 'gray1'          : 'NONE',
	\ 'gray2'          : 'NONE',
	\ 'gray3'          : 'NONE',
	\ 'gray4'          : 'NONE',
	\ 'gray5'          : 'NONE',
	\ 'gray6'          : 'NONE',
	\ 'gray7'          : 'NONE',
	\ 'gray8'          : 'NONE',
	\ 'gray9'          : 'NONE',
	\ 'gray10'         : 'NONE',
\}

elseif &t_Co == 16		" {{{3
    let s:coloralias = {
	\ 'black'          : 0,
	\ 'white'          : 15,
	\
	\ 'darkestgreen'   : 2,
	\ 'darkgreen'      : 2,
	\ 'mediumgreen'    : 10,
	\ 'brightgreen'    : 10,
	\
	\ 'darkestcyan'    : 3,
	\ 'mediumcyan'     : 11,
	\
	\ 'darkestblue'    : 1,
	\ 'darkblue'       : 9,
	\
	\ 'darkestred'     : 4,
	\ 'darkred'        : 4,
	\ 'mediumred'      : 4,
	\ 'brightred'      : 12,
	\ 'brightestred'   : 12,
	\
	\ 'darkestpurple'  : 5,
	\ 'mediumpurple'   : 5,
	\ 'brightpurple'   : 13,
	\
	\ 'brightorange'   : 6,
	\ 'brightestorange': 14,
	\
	\ 'gray0'          : 0,
	\ 'gray1'          : 0,
	\ 'gray2'          : 8,
	\ 'gray3'          : 8,
	\ 'gray4'          : 8,
	\ 'gray5'          : 7,
	\ 'gray6'          : 7,
	\ 'gray7'          : 7,
	\ 'gray8'          : 15,
	\ 'gray9'          : 15,
	\ 'gray10'         : 15,
\}

elseif &t_Co >= 256	" {{{3
    let s:coloralias = {
	\ 'black'          : 16,
	\ 'white'          : 231,
	\
	\ 'darkestgreen'   : 22,
	\ 'darkgreen'      : 28,
	\ 'mediumgreen'    : 70,
	\ 'brightgreen'    : 148,
	\
	\ 'darkestcyan'    : 23,
	\ 'mediumcyan'     : 117,
	\
	\ 'darkestblue'    : 24,
	\ 'darkblue'       : 31,
	\
	\ 'darkestred'     : 52,
	\ 'darkred'        : 88,
	\ 'mediumred'      : 124,
	\ 'brightred'      : 160,
	\ 'brightestred'   : 196,
	\
	\ 'darkestpurple'  : 55,
	\ 'mediumpurple'   : 98,
	\ 'brightpurple'   : 189,
	\
	\ 'brightorange'   : 208,
	\ 'brightestorange': 214,
	\
	\ 'gray0'          : 233,
	\ 'gray1'          : 235,
	\ 'gray2'          : 236,
	\ 'gray3'          : 239,
	\ 'gray4'          : 240,
	\ 'gray5'          : 241,
	\ 'gray6'          : 244,
	\ 'gray7'          : 245,
	\ 'gray8'          : 247,
	\ 'gray9'          : 250,
	\ 'gray10'         : 252,
    \}
endif

" define the default color	{{{2
exec 'hi def g8_on_g2 ctermfg='.s:coloralias.gray8.' ctermbg='.s:coloralias.gray2.' guifg=#9e9e9e guibg=#303030'
hi link MSLdefault	g8_on_g2

" define the colors of mode indicator {{{2
exec 'hi def dg_on_bg ctermfg='.s:coloralias.darkestgreen.' ctermbg='.s:coloralias.brightgreen	.' gui=bold guifg=#006f00 guibg=#afd700'
exec 'hi def dc_on_wt ctermfg='.s:coloralias.darkestcyan .' ctermbg='.s:coloralias.white	.' gui=bold guifg=#005f5f guibg=#ffffff'
exec 'hi def dr_on_bo ctermfg='.s:coloralias.darkred     .' ctermbg='.s:coloralias.brightorange	.' gui=bold guifg=#870000 guibg=#ff8700'
exec 'hi def wt_on_br ctermfg='.s:coloralias.white	 .' ctermbg='.s:coloralias.brightred	.' gui=bold guifg=#ffffff guibg=#d70000'
exec 'hi def wt_on_gy ctermfg='.s:coloralias.white	 .' ctermbg='.s:coloralias.gray5	.' gui=bold guifg=#ffffff guibg=#626262'

hi link MSLnormal	dg_on_bg
hi link MSLinsert	dc_on_wt
hi link MSLreplac	wt_on_br
hi link MSLvisual	dr_on_bo
hi link MSLselect	wt_on_gy

" define the colors of filename {{{2
exec 'hi def wt_on_gy ctermfg='.s:coloralias.white.' ctermbg='.s:coloralias.gray4.' guifg=#ffffff guibg=#585858'
hi link MSLfname	wt_on_gy

" define the colors of file's status {{{2
exec 'hi def dr_on_gy ctermfg='.s:coloralias.brightred.' ctermbg='.s:coloralias.gray2.' guifg=#d70000 guibg=#303030'
hi link MSLro		dr_on_gy

" define the colors of cursor's position {{{2
exec 'hi def g8_on_g4 ctermfg='.s:coloralias.gray8.' ctermbg='.s:coloralias.gray4 .' guifg=#9e9e9e guibg=#585858'
exec 'hi def g2_on_g0 ctermfg='.s:coloralias.gray2.' ctermbg='.s:coloralias.gray10.' guifg=#303030 guibg=#d0d0d0'
exec 'hi def g6_on_g0 ctermfg='.s:coloralias.gray6.' ctermbg='.s:coloralias.gray10.' guifg=#808080 guibg=#d0d0d0'

hi link MSLpercent	g8_on_g4
hi link MSLposition	g2_on_g0
hi link MSLline		g2_on_g0
hi link MSLcolum	g6_on_g0
" }}}2

unlet s:coloralias

