" Vim filetype plugin file for my own use.
" Language:	seiyu-database
" Maintainer:	Joe Ding
" Last Changed: 2012-03-07 15:29:30

if exists("b:current_syntax") | finish | endif

syn match sdvalid /^[^# \t][^　\t]*\%(\t[^\t]*\%(\t\%([^;]*;\)\{3}.*\)\=\)\=$/ contains=sdname,sdyomi,sdinfo
syn match sdname /^[^\t]*\ze\%(\t\|$\)/ contained nextgroup=sdyomi skipwhite
syn match sdyomi /\t\zs[^\t]*\ze\%(\t\|$\)/ contained nextgroup=sdinfo skipwhite
syn match sdinfo /\t\zs\S.*/ contained contains=sdsprt
syn match sdsprt /;\|, / contained

hi link sdvalid	PmenuSel
hi link sdname	Statement
hi link sdyomi	Type
hi link sdinfo	SpecialKey
hi link sdsprt	Constant

let b:current_syntax = "sydata"
