" vim: nowrap fenc=utf-8 sw=2 fdm=marker
" Last Change: 2020-03-19 13:32:47

" set go at the very beginning, since it affects many behaviors
" and adjust cpo and fo here too
set cpo+=FJ fo+=M1j go=Mcdg

" source vimrc_example.vim	{{{1
" For vim-8.2, all affected options in vimrc_example.vim are:
"   backup, undofile, hlsearch, textwidth, and matchit
" it will source default.vim, and further affects:
"   backspace, history, ruler, showcmd, wildmenu
"   ttimeout, ttimeoutlen, display, scrolloff,
"   incsearch, nrformats, guioptions, mouse, langremap
"   syntax on & filetype on
" if gvimrc will be sourced after vimrc files, gvimrc_example.vim affects:
"   cmdheight, mousehide, <S-Insert>
"   syntax on and defines several highlights
source $VIMRUNTIME/vimrc_example.vim

" something I don't like in default	{{{1
" no backup is needed
set nobackup noundofile

" do not use scrolloff, scrolljump is more intuitive, but sidescrolloff is
" good.  scrollfocus makes Windows scrolling like other system.
set scrolloff=0 scrolljump=5 sidescrolloff=5 scrollfocus

language C
" if menu present, change its language to English
" so $VIMRUNTIME/delmenu.vim | set langmenu=none | so $VIMRUNTIME/menu.vim


" My options	 {{{1
" encoding & file format
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,default,latin1

set viminfo='50,/100,<10,@100,f1,h,s1

" display settings
set nu visualbell conceallevel=1 colorcolumn=+1
set listchars=eol:$,tab:>.,trail:.,extends:>,precedes:<,nbsp:+

" for Windows DirectX
set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1

" auto-read/write & indentation
set aw ar hidden ts=8 sw=4 sts=-1
" using habits
set smartcase paste splitright autochdir
set bsdir=current wildignore=*.bak,*.o,*.e,*~,#*#

" spell checking
set spelllang=en_us,cjk spell
set spellsuggest=best,20
" and correcting
iabbr teh the

" using terminal with pipe
set noshelltemp

" When possible use + register for copy/paste 
if has('unnamedplus')
  set clipboard=unnamedplus 
else
  set clipboard=unnamed 
endif 


" My commands	{{{1
" :E open a shortcut (Windows only).
if has('win32')
  set pythonthreedll=python37.dll
  set rubydll=x64-msvcrt-ruby270

  let g:Elinkdir = 'D:/Links/'
  command -nargs=? -complete=custom,utilities#Ecomplete E :call utilities#Elink(<q-args>)
endif

" :S, useful to search files in directory
"   ':3S file_name.txt' will search 'file_name.txt' in current and subdirs 
"   with depth no more than 3.
command -nargs=1 -count=7 -bang S  :call utilities#SearchOpen(<f-args>, <count>, <q-bang>)

" Sort sort chinese
command -nargs=0 -range=% -bang Sort	:call utilities#SortRegion(<line1>, <line2>, <q-bang>)
"
" BuildLocalHelp will generate helptag for all packages
command -nargs=0  BuildPackHelp	:call utilities#BuildHelp()


" My mappings	{{{1
" let keys do the intuitive work
nnoremap Y	y$
nnoremap R	gR
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" <space>/<bs> to scroll down/up
nnoremap <space>	<C-f>
nnoremap <bs>	<C-b>
" move one char is too little, using half screen instead.
nnoremap zl	zL
nnoremap zh	zH

" make a line title caps. The original function of `g~~' is switch case.
nnoremap <silent> g~~	:s/\v<(.)(\w*)/\u\1\L\2/g<CR>

" <F2> to copy text to clipboard
nnoremap <F2>	m`gg"+yG``
vnoremap <F2>	"+ygv
" <F5> to clear buffer
nnoremap <F5>	:%d_<CR>

" <F3>/<F4> to jump to next/previous item
" <F7>/<F8> to jump to next/previous file
nnoremap <F3>	:call utilities#Next(0, 0)<CR>
nnoremap <F4>	:call utilities#Next(1, 0)<CR>
nnoremap <F7>	:call utilities#Next(0, 1)<CR>
nnoremap <F8>	:call utilities#Next(1, 1)<CR>

" <F11> toggle diff mode
nnoremap <silent> <F11>	:exec 'windo diff'.(&diff ? 'off' : 'this')<CR>
" <F12> echo syntax stack
nnoremap <F12>	:echo synstack(line('.'), col('.'))->map({_,v -> synIDattr(v, "name")})<CR>

" smart <BS>, Delete pairs
inoremap <expr> <BS> utilities#Backspace()

" Some useful :setlocal mappings
nnoremap \c	:setl ft=c<CR>
nnoremap \C	:setl ft=cpp<CR>
nnoremap \v	:setl ft=vim<CR>

nnoremap \l	:setl list!<CR>
nnoremap \w	:setl wrap!<CR>
nnoremap \m	:marks<CR>

inoremap <expr> <M-;>	"<C-R>=strftime(\'%Y-%m-%d\')<CR>"
cnoremap <expr> <M-;>	"<C-R>=strftime(\'%Y-%m-%d\')<CR>"
inoremap <expr> <M-:>	"<C-R>=strftime(\'%H:%M:%S\')<CR>"
cnoremap <expr> <M-:>	"<C-R>=strftime(\'%H:%M:%S\')<CR>"

" move a line or a block up or down
nnoremap <C-j> m`:m +1<CR>``
vnoremap <C-j> :m '>+1<CR>gv
nnoremap <C-k> m`:m -2<CR>``
vnoremap <C-k> :m '<-2<CR>gv


" settings for plugins	{{{1
" standard plugins
" NETRW:	{{{2
let g:netrw_keepdir = 0

" }}}2
" others
" SOLARIZED:	{{{2
if has('unix') || has('win32') && has('gui_running')
  set t_Co=256	" this also affects the definition of mycolor
  set background=dark
  colorscheme solarized
endif

" VIM_AIRLANE:	{{{2
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.paste = 'Ꝓ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.dirty = '!'

" FENCVIEW:	{{{2
let g:fencview_autodetect = 1

" CALENDAR:	{{{2
let g:calendar_mark = 'left-fit'
let g:calendar_navi = 'both'
let g:calendar_weeknm = 1 " WK01
" let g:calendar_weeknm = 2 " WK 1
" let g:calendar_weeknm = 3 " KW01
" let g:calendar_weeknm = 4 " KW 1
" let g:calendar_weeknm = 5 " 1

" Vimtex:	{{{2
packadd! vimtex
let g:tex_flavor = 'latex'
let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'jobs',
    \ 'background' : 1,
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

if has('win32')
  let g:vimtex_view_general_viewer = 'SumatraPDF'
  let g:vimtex_view_general_options = 
	\ '-reuse-instance -forward-search @tex @line @pdf'
  let g:vimtex_view_general_options_latexmk = '-reuse-instance'
else
  let g:vimtex_view_general_viewer = 'okular'
  let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
  let g:vimtex_view_general_options_latexmk = '--unique'
endif

let g:tex_conceal='abdmgs'


" UltiSnips:	{{{2
packadd! ultisnips
packadd! vim-snippets

let g:UltiSnipsUsePythonVersion = 3

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Fugitive:	{{{2
packadd! fugitive

"Vader:	{{{2
packadd! vader
"}}}2


" My packages:	{{{1
packadd! bmk
let g:vbookmarks_omitpath = 1

"packadd! sy
