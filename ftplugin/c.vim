" c.vim	vim: ts=8 sw=4
" Vim filetype plugin file
" Language:	c
" Version:	0.5
" Maintainer:	Joe Ding
" Last Change:	2017-02-07 15:12:43

if exists("b:my_ftpc") | finish | endif
let b:my_ftpc = 1

" The followed `let' command seems no use, because it will soon be
" overwritten by `$VIMRUNTIME/ftplugin/c.vim'.  But I'm not sure.
let b:undo_ftplugin = "setl cin< et< ts< path< | unlet b:my_ftpc"

setl cindent
"setl expandtab
"setl tabstop=8

setl path=.,/usr/include,/usr/local/include,C:/MinGW/include,F:/bbndk/target_10_3_1_995/qnx6/usr/include,F:/bbndk/target_10_3_1_995/qnx6/usr/include/qt4

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

