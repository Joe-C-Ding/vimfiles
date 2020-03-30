" vim: nowrap fenc=utf-8 sw=2 fdm=marker
" Last Change: 2020-03-19 13:32:47

" set go at the very beginning, since it affects many behaviors
" and adjust cpo and fo here too
set cpo+=FJ fo+=M1j go=Mcdg

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
set fileformats=unix,dos

set viminfo='50,/100,<10,@100,f1,h,s1

" display settings
set nu visualbell conceallevel=1
set listchars=eol:$,tab:>.,trail:.,extends:>,precedes:<,nbsp:+

" auto-read/write & indentation
set aw ar hidden ts=8 sw=4 sts=-1
" using habits
set smartcase paste splitright autochdir
set bsdir=current wildignore=*.bak,*.o,*.e,*~,#*#

" this will highlight the column after 'textwidth'
set colorcolumn=+1

" spell checking
set spelllang=en_us,cjk spell
set spellsuggest=best,20
" and correcting
iabbr teh the

" using terminal
set shellslash noshelltemp

" When possible use + register for copy/paste 
if has('unnamedplus')
  set clipboard=unnamedplus 
else
  set clipboard=unnamed 
endif 

" My commands	{{{1
if has('win32')	" commad E for windows	{{{2
  set pythonthreedll=python37.dll

  let s:linkdir = "D:/Links/"

  command -nargs=? -complete=custom,s:Ecomplete E  :call <SID>Elink(<q-args>)

  function s:Ecomplete(ArgLead, CmdLine, CursorPos) abort	" {{{3
    if !exists('s:links')
      let s:links = glob(s:linkdir.'*.lnk', 0, 1)
      call map(s:links, 'substitute(v:val, ''^.*/\(.*\)\.lnk$'', ''\1'', "")')
      let s:links = join(s:links, "\n")
    endif

    return s:links
  endfunction

  function s:Elink ( lk ) abort	" {{{3
    if empty(a:lk)
      exec "!start " .. getcwd()
      return

    elseif a:lk !~? '\.lnk$'
      let l:link = a:lk .. ".lnk"
    else
      let l:link = a:lk
    endif

    let filename = s:linkdir .. l:link
    if filereadable(filename)
      exec "e ".filename
    else
      echohl WarningMsg | echom "Shortcut not exists: ". a:lk | echohl None
    endif
  endfunction
  " }}}3
endif
" }}}2
" :S, useful to search files in directory	{{{2
" `:3S file_name.txt'
"   to search it in `.' and subdirs with depth no more than 3.
command -nargs=1 -count=7 -bang S  :call <SID>searchopen(<f-args>, <count>, <q-bang>)

function s:searchopen(file, depth, with_dir) abort	" {{{3
  let l:file = substitute(a:file, '\*', '.*', 'g')
  let l:file = substitute(l:file, '?', '.', 'g')
  let l:file = substitute(l:file, '\.', '.', 'g')
  let files = s:FindFiles([], l:file, '.', a:depth, a:with_dir)->map({_,v -> fnamemodify(v, ':.')})

  let length = len(files)
  if length == 0
    echo 'file '''.a:file.''' is not found! (within '.a:depth.' levels of depth)'
    return
  endif

  for i in range(1, length)
    echo i.":"  files[i-1]
  endfor

  let choice = input("edit [^C/<num>/all]? ", 1)
  if choice > 0 && choice <= length
    exec "e " . fnameescape(files[choice-1])
  elseif choice =~? 'a\%[ll]'
    exec "0argadd ".join(map(files, 'fnameescape(v:val)'), ' ')
    rewind
  endif
endfunction

function! s:FindFiles(list, file, dir, depth, with_dir) abort	" {{{3
  if a:depth > 0
    for f in readdir(a:dir)
      if f =~ '^\.' | continue | endif
      let fullf = a:dir..'/'..f
      if isdirectory(fullf)
	if !empty(a:with_dir) && f =~ a:file
	  call add(a:list, fullf)
	endif
	sil call s:FindFiles(a:list, a:file, fullf, a:depth-1, a:with_dir)
      elseif f =~? a:file
	call add(a:list, fullf)
      end
    endfor
  endif
  return a:list
endfunction

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

" <F3>/<F4> to jump to next/previous item
" <F8>/<F9> to jump to next/previous file
nnoremap <F3>	:call <SID>Next(0, 0)<CR>
nnoremap <F4>	:call <SID>Next(1, 0)<CR>
nnoremap <F8>	:call <SID>Next(0, 1)<CR>
nnoremap <F9>	:call <SID>Next(1, 1)<CR>

" <F11> toggle diff mode
nnoremap <silent> <F11>	:exec 'windo diff'.(&diff ? 'off' : 'this')<CR>

function s:Next(reverse, file) abort	" {{{3
  " location list > quickfix list > arguments
  if getloclist(0, #{size: 0}).size > 0
    let l:prefix = 'l'
  elseif getqflist(#{size: 0}).size > 0
    let l:prefix = 'c'
  else
    let l:prefix = ''
  end

  if a:reverse
    let l:cmd = 'N'
  else
    let l:cmd = 'n'
  end

  if a:file
    let l:suffix = 'file'
  else
    let l:suffix = 'ext'
  end

  exec l:prefix..l:cmd..l:suffix
endfunction

" <F5> to clear buffer
nnoremap <F5>	:%d_<CR>

" <F12> echo syntax stack
nnoremap <F12>	:echo synstack(line('.'), col('.'))->map({_,v -> synIDattr(v, "name")})<CR>

" smart <BS>, Delete pairs
inoremap <expr> <BS> <SID>Backspace()
let s:pairs = {
      \  '"': '"',
      \  '(': ')',
      \  '[': ']',
      \  '{': '}',
      \  '<': '>',
      \}

function! s:Backspace ()
  let line = getline('.')
  let col = col('.') - 1
  let char = line[col-1]

  let keys = "\<BS>"
  if get(s:pairs, char, 'xx') == line[col]
    let keys .= "\<DEL>"
  endif
  return keys
endfunction

" Some useful :setlocal mappings  {{{1
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

" setting for plugins/packages	{{{1
" NETRW:
" let g:netrw_keepdir = 0

" SOLARIZED:
if has('unix') || has('win32') && has('gui_running')
  set t_Co=256	" this also affects the definition of mycolor
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
" let g:vimim_map = 'c-bslash'
" let g:vimim_cloud = -1
" let g:vimim_toggle = 'wubi'

" CALENDAR:
let g:calendar_mark = 'left-fit'
let g:calendar_navi = 'both'
let g:calendar_weeknm = 1 " WK01
" let g:calendar_weeknm = 2 " WK 1
" let g:calendar_weeknm = 3 " KW01
" let g:calendar_weeknm = 4 " KW 1
" let g:calendar_weeknm = 5 " 1

" Vimtex:
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

" Fugitive:
packadd! fugitive

" My packages:
packadd! bmk
let g:vbookmarks_omitpath = 1

packadd! sy
