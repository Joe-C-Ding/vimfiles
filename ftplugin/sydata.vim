" Vim filetype plugin file for my own use.
" Language:	seiyu-database
" Maintainer:	Joe Ding
" Last Changed: 2012-03-07 15:35:51

if exists("b:my_ftpsd") | finish | endif
let b:my_ftpsd = 1

let b:undo_ftplugin = "setl wrap< ts< sts<"
setl ts=24 sts=0 nowrap

"abbrevation
inoreabbr	， , 
"inoreabbr	； ;|" it seems that we cannot use `;' as a abbr.

" some covenience map
nnoremap <buffer> \m	:marks<CR>


" set omni-completion
" setl omnifunc=sycomplete#Complete
" nnoremap <buffer> <M-a>	:<C-u>call sycomplete#Addinfo()<CR>
" inoremap <buffer> <M-a>	<Esc>:call sycomplete#Addinfo()<CR>
" nnoremap <buffer> <M-p>	:<C-u>call sycomplete#Preview()<CR>
" inoremap <buffer> <M-p>	<Esc>:call sycomplete#Preview()<CR>
" nnoremap <buffer> <M-c>	:<C-u>call sycomplete#Check()<CR>
