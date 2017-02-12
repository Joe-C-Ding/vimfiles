" Vim filetype plugin file
" Language:	grep's output
" Maintainer:	Joe Ding
" Last Changed: 2012-01-10 15:00:14

if exists("b:jd_ftpgrep") | finish | endif
let b:jd_ftpgrep =  1

setl bt=nofile nowrap ft=grep
let s:keyword = matchstr(getline(1), '# grep mode -- key: \zs.*')
exec "match grepKeyword /" . s:keyword . "/"
hi link grepKeyword Constant

" Mappings. 
nnoremap <buffer> q	ZQ
