" sy.vim	vim: ts=8 sw=4
" Vim syntax file for *.sy
" Language:	seiyu-record
" Maintainer:	Joe Ding
" Version:	1.9.0
" Last Change:	2016-10-26 09:51:26

if exists("b:current_syntax") | finish | endif

let s:save_cpo = &cpo
set cpo&vim

" Syntax elements {{{1
" Titles {{{2
syn region syEpisodeName matchgroup=syEpSptor contains=syEpisodeNo
	\ start=/^====================================$/ end=/^====================================$/ 
syn match  syEpisodeNo display /^# \=\S\+/ contained contains=NONE


" Main body {{{2
syn match syCastLine	display /^[^：]*：[^-（]*\%(（.*）\)\=$/ contains=syCharacter,sySeiyu,syDescription
syn match syCharacter	display /^\s*\zs[^：]*\S\@<=/ contained contains=syError
syn match sySeiyu	display /：\s*\zs[^-（：]*\S\@<=/ contained contains=syError
syn match syDescription	display /（.*）/ contained contains=syDscSptor,syOriginal
syn match syDscSptor	display /；/ contained
syn match syOriginal	display /「.\{-}」/ contained
syn match syError	display /　\|\t/ contained


" Information of Music {{{2
syn match  syMuSptor display /^==== music ====$/

syn match  syMuCategry	display /^\S*\%( [0-9１-９]\+\)\=\ze.*\n「/ nextgroup=syMuComment skipwhite
syn match  syMuComment	display /(.*)/ contains=syMCSptor,syMCTrans contained
syn match  syMCSptor	display /, \|\d\zs～/ contained
syn match  syMCTrans	display / \%(OP\|ED\|IN\|TM\)/ contained

syn region syMuTitle	display oneline matchgroup=syMuParen start=/^「/ end=/」/
syn match  syMuPosition	display /^\%(作詞\|作曲\|詞曲\|編曲\|作編曲\)\t/ nextgroup=syMuStuff
syn match  syMuStuff	display /\S.*$/ contains=syMSSptor contained
syn region syMuStuff	matchgroup=syMuPosition start=/^歌\t/ matchgroup=NONE end=/^$/ contains=syMSSptor
syn match  syMSSptor	display +:\|&\|, \|/\|、\|＆\|／\|・\|\<and\>+ contained


" Information of Lines {{{2
syn match  syLnType	display /^\t\zs\S[^-]* ---- \S.*/ contains=syLines,sySpeaker
syn match  syLines	display /\S[^-]*\ze ---- / contained contains=syLnSptor
syn match  sySpeaker	display / ---- \zs[^(]*\S\@<=/ contained contains=syLnSptor nextgroup=syLnEpno skipwhite
syn match  syLnEpno	display /(.*)/ contained
syn match  syLnSptor	display /＆\|　/ contained
" TODO: when the comment contains a full-width colon, it will be considered as a
"	syDescription. This is not right.
syn match  syLnComment	display /^\t\t\zs（.*）/

" Comment {{{2
syn match  syComment	/^\s*#.*/
syn match  syLocation	/^\t\+#.*/


" Highlight {{{1

" Titles & Comment {{{2
hi	syComment	ctermfg=11 guifg=#268bd2
hi link syLocation	syComment

hi	syEpisodeName	cterm=bold ctermfg=11 gui=bold guifg=#85aa00
hi	syEpSptor	ctermfg=11 guifg=#2aa198
hi	syEpisodeNo	cterm=bold ctermfg=13 gui=bold guifg=#b58900


" Main body {{{2
hi	syCharacter	cterm=underline ctermfg=13 gui=underline guifg=#ff22ee
hi	sySeiyu		cterm=bold guifg=#cccccc
hi	syDescription	ctermfg=11 guifg=#268bff
hi	syDscSptor	ctermfg=darkred guifg=red
hi	syOriginal	cterm=bold ctermfg=darkgreen gui=bold guifg=#2acc98
hi link	syError		Error


" Information of Music {{{2
hi link syMuSptor	syComment
hi	syMuCategry	ctermfg=red guifg=#ff322f
hi link syMuComment	syEpisodeNo
hi link	syMCSptor	syDscSptor
hi	syMCTrans	ctermfg=darkgray guifg=#2aa198

hi link	syMuTitle	syEpisodeName
hi link	syMuParen	Normal
hi	syMuPosition	ctermfg=11 guifg=#2aa198
hi	syMuStuff	ctermfg=2 guifg=#ff8033
hi link	syMSSptor	syMCSptor


" Information of Lines {{{2
hi	syLnType	ctermfg=green guifg=green
hi	syLines		ctermfg=lightblue guifg=#99ccff
hi link	sySpeaker	syCharacter
hi link	syLnEpno	syEpisodeNo
hi	syLnComment	ctermfg=red guifg=red
hi link	syLnSptor	syComment


" Synchronizing {{{1
syn sync fromstart
" }}}1

let &cpo = s:save_cpo
unlet s:save_cpo

let b:current_syntax = "sy"

" vim: ts=8 fdm=marker
