" Vim filetype plugin file for my own use.
" Language:	grep's output
" Maintainer:	Joe Ding
" Last Changed: 2011-06-13 21:56:52

if exists("b:current_syntax") | finish | endif

syn match grepFileName /^.\{-\}:/
syn match grepModeName /^# grep mode -- key: .*/
syn match grepKeyword /unknown/

hi link grepFileName Identifier
hi link grepModeName Comment

let b:current_syntax = "sy"
