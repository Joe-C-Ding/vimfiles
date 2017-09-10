" cpp.vim	vim: ts=8 sw=4 ff=unix
" Vim filetype plugin file
" Language:	c++
" Version:	0.7
" Maintainer:	Joe Ding
" Last Change:	2017-09-10 09:08:21

if exists("b:my_ftpcpp") | finish | endif
let b:my_ftpcpp = 1

" Import all set of c
runtime ftplugin/c.vim
if has("win32")
    let s:mingw_root = 'C:/MinGW/'
    if isdirectory(s:mingw_root)
	let s:libgcc = finddir('c++', s:mingw_root.'lib/gcc/mingw32/*/include/', -1)
	if len(s:libgcc) > 0
	    " only include the newest one (the last version number)
	    let s:libgcc = s:mingw_root[0:1] . s:libgcc[-1]
	endif

	exec "setl path+=" . s:libgcc
    endif
else	" unix-like
    " setl path+=/usr/include/c++/4.6.3
end

" The followed `let' command seems no use, because it will soon be
" overwritten by `$VIMRUNTIME/ftplugin/c.vim'.  But I'm not sure.
let b:undo_ftplugin = "unlet my_ftpcpp"


" Overwrite those abbreviations
inoreab <buffer> ioh		#include <cstdio>
inoreab <buffer> libh		#include <cstdlib>
inoreab <buffer> defh		#include <cstddef>
inoreab <buffer> strh		#include <cstring>
inoreab <buffer> sigh		#include <csignal>
inoreab <buffer> errh		#include <cerrno>
inoreab <buffer> mathh		#include <cmath>
inoreab <buffer> timeh		#include <ctime>
inoreab <buffer> asserth	#include <cassert>
inoreab <buffer> ctypeh		#include <cctype>
inoreab <buffer> limitsh	#include <climits>

" And add those abbreviations.
inoreab <buffer> iosh		#include <iostream>
inoreab <buffer> iomh		#include <iomanip>
inoreab <buffer> vech		#include <vector>
inoreab <buffer> vectorh	#include <vector>
inoreab <buffer> lsh		#include <list>
inoreab <buffer> listh		#include <list>
inoreab <buffer> queh		#include <queue>
inoreab <buffer> deqh		#include <deque>
inoreab <buffer> maph		#include <map>
inoreab <buffer> stringh	#include <string>
inoreab <buffer> algoh		#include <algorithm>
inoreab <buffer> numh		#include <numeric>

inoreab <buffer> ustd		using namespace std;

