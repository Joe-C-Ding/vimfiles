" Vim filetype plugin file for my own use.
" Language:	anime-list
" Maintainer:	Joe Ding
" Last Changed: Mon May  2 2011

if exists("b:current_syntax") | finish | endif

syn match listTarget	/^__ [#A-Z] __/
syn match listFolder	/\s*{{{\d\+/
syn match listWarning	/^[^ \t_].*/

hi link listTarget	Constant
hi link listFolder	col_black
hi link listWarning	PmenuSel

let b:current_syntax = "sy"
