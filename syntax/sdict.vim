" Vim filetype plugin file for my own use.
" Language:	word-book
" Maintainer:	Joe Ding
" Last Changed: 2011-06-07 22:49:02

if exists("b:current_syntax") | finish | endif

syn match sdictWord	/^[^\t（]\+/	nextgroup=sdictKanji
syn match sdictKanji	/（.\{-\}）/	contained contains=sdictSptor
syn match sdictTrans	/\t\zs[^\t]\+/	nextgroup=sdictComment skipwhite contains=sdictSptor,sdictRef
syn match sdictComment	+\t\zs// .*+	contained
syn match sdictSptor	/\%(；\|・\)/	contained
syn match sdictRef	/（.\{-\}）/	contained contains=sdictOriginal
syn match sdictOriginal	/「.\{-\}」/	contained

hi link sdictWord	NonText
hi link sdictKanji	Identifier
hi link sdictTrans	Special
hi link sdictComment	Comment
hi link sdictSptor	Normal
hi link sdictRef	Statement
hi link sdictOriginal	Type

let b:current_syntax = "sdict"
