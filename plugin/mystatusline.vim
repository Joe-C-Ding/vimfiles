" vim: fdm=marker ff=unix
" Language:	Vim-script
" Maintainer:	Joe
" Version:	1.1
" Last Change:	2018-07-08 07:52:40

if exists("g:my_statusline") | finish | endif
let g:my_statusline = 1

let s:save_cpo = &cpo
set cpo&vim

runtime colors/mycolors.vim
set laststatus=2
set statusline=%!MyStatusLine(1)

augroup MyStatusLine
    au WinEnter	* setl statusline=%!MyStatusLine(1)
    au WinLeave	* setl statusline=%!MyStatusLine(0)

    " Because the change of syntax may clear all highlights.
    au Syntax	* runtime colors/mycolors.vim
augroup END

function! MyStatusLine( is_cw )
    return s:MSLmode(a:is_cw) .
	 \ s:MSLname(a:is_cw) .
	 \ s:MSLstatus(a:is_cw) . "%#MSLdefault#%=" .
	 \ s:MSLfileinfo(a:is_cw) .
	 \ s:MSLcursposi(a:is_cw)
endfunction

function! s:MSLmode( is_cw )	" {{{1
    if !a:is_cw | return '' | endif

    let l:mode = mode()
    if l:mode == "v"
	return '%#MSLvisual#%( VISUAL  %)'
    elseif l:mode == "V"
	return '%#MSLvisual#%( V-LINE  %)'
    elseif l:mode == ""
	return '%#MSLvisual#%( V-BLOCK %)'
    elseif l:mode == "s"
	return '%#MSLselect#%( SELECT  %)'
    elseif l:mode == "S"
	return '%#MSLselect#%( S-LINE  %)'
    elseif l:mode == ""
	return '%#MSLselect#%( S-BLOCK %)'
    elseif l:mode == "i"
	return '%#MSLinsert#%( INSERT  %)'
    elseif l:mode =~# 'Rv\='
	return '%#MSLreplac#%( REPLACE %)'
    else    " aka: no\=
	return '%#MSLnormal#%( NORMAL  %)'
    endif
endfunction

function! s:MSLname( is_cw )	"{{{1
    if a:is_cw
	return '%#MSLfname#> %t %a'
    else
	return '%#MSLdefault# %<%F '
    endif
endfunction

function! s:MSLstatus( is_cw )	"{{{1
    if a:is_cw
	return '%#MSLdefault#> %#MSLro#%(%R%{&ma?"":"-"}%)%)'
	    \. '%#MSLdefault#%{&mod?"+":""}%h%w%q'
    else
	return '%#MSLdefault#> %R%M%h%w%q'
    endif
endfunction

function! s:MSLfileinfo( is_cw )	"{{{1
"    if a:is_cw
	return '%<%#MSLdefault#< %{&ff} '
	    \. '< %{&fenc!=""?&fenc:&enc} < %{&ft!=""?&ft:"no ft"} '
"    else
"	return ''
"    endif
endfunction

function! s:MSLcursposi( is_cw )	"{{{1
    if a:is_cw
	if &iminsert
	    return '%#MSLpercent#< %P '
		\. '%#MSLposition#<%13(%#MSLline#%l%#MSLcolum#:%c%V %)'
	else
	    return '%#MSLpercent#< %P_%{&fdm}[%{&fdl}] '
		\. '%#MSLposition#<%13(%#MSLline#%l%#MSLcolum#:%c%V %)'
	endif
    else
	return '%#MSLdefault#< %P_%{&fdm}[%{&fdl}] <%13(%l:%c%V %)'
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
