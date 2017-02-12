" Vim filetype plugin file
" Language:	c++
" Maintainer:	Joe Ding
" Last Changed: 2011-05-04 12:49:24

if exists("b:my_ftpcpp") | finish | endif
let b:my_ftpcpp = 1

" Import all set of c
runtime ftplugin/c.vim
setl path+=/usr/include/c++/4.6.3

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

