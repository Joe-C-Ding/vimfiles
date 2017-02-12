" Author:	Joe
" Modified:	2015/07/29 08:54:33

let s:dowload_dir = "E:/Downloads/"
function utilities#Clear()
    let cwd = fnameescape(getcwd())
    exec "lcd " . fnameescape(s:dowload_dir)

    let files = glob('5MB_file*', 0, 1)
    call extend(files, glob('**/*.torrent', 0, 1))

    for f in files
	call delete(f)
    endfor

    exec "lcd " . cwd
endfunction
