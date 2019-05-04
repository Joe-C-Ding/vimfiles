" vim: nowrap fenc=utf-8 ff=unix sw=2
" Last Change: 2017-05-05 08:18:44

if exists("g:loaded_myvimrc") | finish | endif
let g:loaded_myvimrc = 1

if v:progname =~? "evim" | finish | endif

set nocompatible 
set backspace=indent,eol,start
set mouse=a mousehide
set nobackup ruler showcmd incsearch 

let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

if has("autocmd")
  filetype plugin indent on

  augroup vimrcEx
    au!
    autocmd FileType text setlocal textwidth=78 fo=n2tM1
    autocmd BufReadPost *
	  \ if line("'\"") > 1 && line("'\"") <= line("$") |
	  \   exe "normal! g`\"" |
	  \ endif
  augroup END
else
  set autoindent		" always set auto-indenting on
endif " has("autocmd")

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
	\ | wincmd p | diffthis
endif

" ====================================
" My options ~~~
" ====================================

autocmd BufEnter * silent! lcd %:p:h

set cpoptions+=FJ	"cpo
"set cpo-=Ckvx<
set formatoptions+=M1	"fo

" go, must remove one by one, see |:set-=|
for f in split('e r R l L b h')
  exec 'set guioptions-='.f
endfor

language C
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,default,latin1
so $VIMRUNTIME/delmenu.vim | set langmenu=none | so $VIMRUNTIME/menu.vim
set fileformats=unix,dos

" spell checking
set spell spelllang=en_us,cjk
set spellsuggest=best,20

set sw=4 sts=-1
set cmdheight=2
set scrolljump=5
set wildmenu wildmode=list:full bsdir=current
set verbosefile=$HOME/vim_verbosefile.txt
set nu aw ar hidden smartcase splitright visualbell paste

set timeout timeoutlen=1000 ttimeoutlen=100
set wildignore=*.bak,*.o,*.e,*~,#*#
set listchars=eol:$,tab:>.,trail:.,extends:>,precedes:<
set viminfo='50,/100,<10,@100,f1,h,s1

set guioptions+=c
set guioptions-=T
set guioptions-=m

" this will highlight the column after 'textwidth'
set colorcolumn=+1

" When possible use + register for copy-paste 
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus 
else
  set clipboard=unnamed 
endif 

" ====================================
" My commands ~~~
" ====================================

" set fonts and useful commands for windows
try
  if has('win32')
    set guifont=Consolas:h16
    set guifontwide=MS_Gothic:h16
    set shellslash
    set pythonthreedll=python37.dll

    " call utilities#Clear()
  else
    set guifont=Monospace\ 15
  endif
endtry

if has('win32')
  let s:linkdir = "D:/Links/"

  command -nargs=1 -complete=custom,s:Ecomplete E  :call <SID>Elink(<q-args>)

  function s:Ecomplete(ArgLead, CmdLine, CursorPos)
    if !exists('s:links')
      let s:links = glob(s:linkdir.'*.lnk', 0, 1)
      call map(s:links, 'substitute(v:val, ''^.*/\(.*\)\.lnk$'', ''\1'', "")')
      let s:links = join(s:links, "\n")
    endif

    return s:links
  endfunction

  function s:Elink ( lk )
    if a:lk !~ "lnk$"
      let link = a:lk . ".lnk"
    else
      let link = a:lk
    endif

    let filename = s:linkdir . link
    if file_readable(filename)
      exec "e ".filename
    else
      echohl WarningMsg | echo "Shortcut not exists: ". a:lk | echohl None
    endif
  endfunction
endif

" useful to search files in directory
" `:3S file_name.txt'
"   to search it in `.' and subdirs with depth no more than 3.
command -nargs=1 -count=2 S  :call <SID>searchopen(<f-args>, <count>)

function s:searchopen(file, deepth)
  if a:file =~ '[\[\]*?]'
    let files = glob('**/'.a:file, 0, 1)
  else
    let files = findfile(a:file, '**'.a:deepth.'/', -1)
  endif

  let length = len(files)
  if length == 0
    echo "file \'".a:file."\' is not found!"
    return
  endif

  for i in range(1, length)
    echo i.":"  files[i-1]
  endfor

  let choice = input("edit [empty/<num>/all]? ")
  if choice > 0 && choice <= length
    exec "e " . fnameescape(files[choice-1])
  elseif choice =~? 'a\%[ll]'
    exec "0argadd ".join(map(files, 'fnameescape(v:val)'), ' ')
    rewind
  endif
endfunction

" ====================================
" My mappings ~~~
" ====================================

" <space>/<bs> to scroll down/up
nnoremap <unique>	<space>	<C-f>
nnoremap <unique>	<bs>	<C-b>

" <F2> to copy text to clipboard
if has("unix")
  nnoremap <unique> <F2>	:%!expand<CR>m`gg"+yG``
  vnoremap <unique> <F2>	"+ygv
else
  nnoremap <unique> <F2>	m`gg"+yG``
  vnoremap <unique> <F2>	"+ygv
endif

" <F3>/<F4> to jump to next/previous item
nnoremap <unique><expr> <F3>	<SID>Next(0)
nnoremap <unique><expr> <F4>	<SID>Next(1)
function s:Next ( reverse )
  if empty(getqflist())
    if empty(getloclist(0))
      return a:reverse ? ":Next\<CR>" : ":next\<CR>"
    else
      return a:reverse ? ":lNext\<CR>" : ":lnext\<CR>"
    endif
  else
      return a:reverse ? ":cNext\<CR>" : ":cnext\<CR>"
  endif
endfunction

" <F8>/<F9> to jump to next/previous file
nnoremap <unique><expr> <F8>	<SID>NextFile(0)
nnoremap <unique><expr> <F9>	<SID>NextFile(1)
function s:NextFile ( reverse )
  if empty(getqflist())
    if empty(getloclist(0))
      return a:reverse ? ":Next\<CR>" : ":next\<CR>"
    else
      return a:reverse ? ":lNfile\<CR>" : ":lnfile\<CR>"
    endif
  else
      return a:reverse ? ":cNfile\<CR>" : ":cnfile\<CR>"
  endif
endfunction

" <F5> to clear buffer
nnoremap <unique> <F5>	:%d_<CR>
" <F12> to show the syntax item name under cursor
nnoremap <unique> <F12>	:echo synIDattr(synID(line("."), col("."), 1), "name")<CR>

" smart <BS>,  Delete pairs
let s:pairs = {
      \  '"': '"',
      \  '(': ')',
      \  '[': ']',
      \  '{': '}',
      \  '<': '>',
      \}

function! Backspace ()
  let line = getline('.')
  let col = col('.') - 1
  let char = line[col-1]

  let keys = "\<BS>"
  try
    " s:pairs[char] may throw exception
    if s:pairs[char] == line[col]
      let keys .= "\<DEL>"
    endif
  finally
    return keys
  endtry
endfunction

inoremap <expr> <BS> Backspace()

nnoremap <unique> R	gR
" make a line title caps. The original function of `g~~' is switch case.
nnoremap <silent> g~~	:s/\v<(.)(\w*)/\u\1\L\2/g<CR>

" \e to start Emacs at cwd
" if has('win32')
"   nnoremap <unique> \e	:exec "!start runemacs ".shellescape(getcwd())." &"
" else
"   nnoremap <unique> \e	:exec "!emacs ".shellescape(getcwd())." &"
" endif

" some useful :setlocal mappings
nnoremap <unique> \l	:setl list!<CR>
nnoremap <unique> \w	:setl wrap!<CR>
nnoremap <unique> \h	:nohlsearch<CR>
nnoremap <unique> Y	y$

inoremap <unique><expr> <M-;>	"<C-R>=strftime(\'%Y-%m-%d\')<CR>"
cnoremap <unique><expr> <M-;>	"<C-R>=strftime(\'%Y-%m-%d\')<CR>"
inoremap <unique><expr> <M-:>	"<C-R>=strftime(\'%H:%M:%S\')<CR>"
cnoremap <unique><expr> <M-:>	"<C-R>=strftime(\'%Y-%m-%d\')<CR>"

nnoremap <unique> \c	:setl ft=c<CR>
nnoremap <unique> \C	:setl ft=cpp<CR>
nnoremap <unique> \v	:setl ft=vim<CR>

" move a line or a block up or down
nnoremap <C-j> m`:m +1<CR>``
vnoremap <C-j> :m '>+1<CR>gv
nnoremap <C-k> m`:m -2<CR>``
vnoremap <C-k> :m '<-2<CR>gv


" ======= simulate Emacs' keybinding ======
" <A-d> and <A-BS> delete forward or backward a word
inoremap <unique> <M-d>	<C-o>de
cnoremap <unique> <M-d>	<C-o>de
inoremap <unique> <M-<BS>>	<C-w>
cnoremap <unique> <M-<BS>>	<C-w>
" <M-f> and <M-b> move cursor forward or backward a word
inoremap <unique> <M-b>	<C-left>
cnoremap <unique> <M-b>	<C-left>
inoremap <unique> <M-f>	<C-right>
cnoremap <unique> <M-f>	<C-right>
" <M-<> and <M->> move cursor to the begin or end of buffer
nnoremap <unique> <M->>	G
nnoremap <unique> <M-<>	gg
nnoremap <unique> <M-{>	{
nnoremap <unique> <M-}>	}

cnoremap <unique> <M-g>  <C-\><C-N>
inoremap <unique> <M-g>  <C-\><C-N>
" =========================================

" spell correcting
iabbr teh the

"====================================
" setting for plugins/packages
"====================================

" NETRW:
let g:netrw_keepdir = 0

" SOLARIZED:
if has('unix') || has('win32') && has('gui_running')
  set t_Co=256
  set background=dark
  colorscheme solarized
endif

" FENCVIEW:
let g:fencview_autodetect = 1

" SKK:
" packadd! skk
"let s:jisyou = '~/vimfiles/pack/skk/opt/skk/plugin/SKK-JISYO.L'
"let g:skk_large_jisyo = s:jisyou
"let g:skk_auto_save_jisyo = 1
"let g:skk_show_candidates_count = 3
"
"let g:eskk#large_dictionary = {
"      \ 'path': s:jisyou,
"      \ 'sorted': 1,
"      \ 'encoding': 'euc-jp',
"      \}
" let skk_jisyo = "path to private dictionary"

" VIMIM:
let g:vimim_map = 'c-bslash'
let g:vimim_cloud = -1
let g:vimim_toggle = 'wubi'

" CALENDAR:
let g:calendar_mark = 'left-fit'
let g:calendar_navi = 'both'
let g:calendar_weeknm = 1 " WK01
" let g:calendar_weeknm = 2 " WK 1
" let g:calendar_weeknm = 3 " KW01
" let g:calendar_weeknm = 4 " KW 1
" let g:calendar_weeknm = 5 " 1

" vim-latex:
" packadd! vim-latex
" let g:Tex_Debug = 1
"set grepprg=grep\ -nH\ $*
let g:tex_flavor = 'latex'
"let g:Tex_CompileRule_pdf = 'xelatex -interaction=nonstopmode $*'
"let g:Tex_ViewRule_pdf = 'sumatrapdf'
"let g:Tex_ViewRule_dvi = 'sumatrapdf'

" MATCHIT:
packadd! matchit
let loaded_matchit = 1


" Vimtex:
packadd! vimtex
let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'jobs',
    \ 'background' : 1,
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
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

set conceallevel=1
let g:tex_conceal='abdmgs'


" UltiSnips:
packadd! ultisnips
packadd! vim-snippets

let g:UltiSnipsUsePythonVersion = 3

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" My packages:
packadd! bmk
