" Vim filetype plugin file for ass.
" Maintainer:	Joe Ding
" Last Changed: 2012-08-09 00:01:21

if exists("b:my_ftpsrt") | finish | endif
let b:my_ftpsrt= 1

" to convert ass to srt.
nnoremap <silent><buffer> \c	:argdo call ass2srt#Convert()<CR>
