" c.vim	vim: ts=8 sw=4
" Vim filetype plugin file
" Language:	c
" Version:	0.7
" Maintainer:	Joe Ding
" Last Change:	2017-09-10 09:08:28

if exists("b:my_ftpc") | finish | endif
let b:my_ftpc = 1

" The followed `let' command seems no use, because it will soon be
" overwritten by `$VIMRUNTIME/ftplugin/c.vim'.  But I'm not sure.
let b:undo_ftplugin = "setl cin< et< ts< path< | unlet b:my_ftpc"

setl cindent
"setl expandtab
"setl tabstop=8

" set include path
setl path=.
if has("win32")
    let s:mingw_root = 'C:/MinGW/'
    if isdirectory(s:mingw_root)
	let s:mingw = s:mingw_root . 'include'
	let s:libgcc = finddir('include', s:mingw_root.'lib/gcc/mingw32/*/', -1)
	if len(s:libgcc) > 0
	    " only include the newest one (the last version number)
	    let s:libgcc = s:mingw_root[0:1] . s:libgcc[-1]
	    let s:mingw .= ',' . s:libgcc
	endif

	exec "setl path+=" . s:mingw
    endif

    let s:gnuwin_root = 'C:/GnuWin32/'
    if isdirectory(s:gnuwin_root)
	let s:gnuwin = s:gnuwin_root . 'include'
	exec "setl path+=" . s:gnuwin
    endif
else	" unix-like
    setl path+=/usr/include,/usr/local/include
end

nnoremap <buffer> <F3> :cn<CR>
nnoremap <buffer> <F4> :cp<CR>
nnoremap <buffer> <F5> :make<CR>
nnoremap <buffer> <F6> :call <SID>Execute()<CR>

" spell correcting
inoreab <buffer> itn	int

" abbrs.
inoreab <buffer> #d		#define
inoreab <buffer> #i		#include
inoreab <buffer> ioh		#include <stdio.h>
inoreab <buffer> libh		#include <stdlib.h>
inoreab <buffer> defh		#include <stddef.h>
inoreab <buffer> memh		#include <memory.h>
inoreab <buffer> strh		#include <string.h>
inoreab <buffer> sigh		#include <signal.h>
inoreab <buffer> errh		#include <errno.h>
inoreab <buffer> mathh		#include <math.h>
inoreab <buffer> timeh		#include <time.h>
inoreab <buffer> asserth	#include <assert.h>
inoreab <buffer> ctypeh		#include <ctype.h>
inoreab <buffer> limitsh	#include <limits.h>

inoreab <buffer> mainf		int main(int argc, char *argv[])<CR>

if !exists("*s:Execute")
    function s:Execute()
	let exename = system("ls -F | sed -n -e '/\\*$/{s/\\*$//p;q}'")
	let exename = input("execute: ", exename, "file")
	if exename !~ "^[~.]\?/" | let exename = "./" . exename | endif
	exe "!" . exename
    endfunction
endif

