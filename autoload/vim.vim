vim9script

# Maintainer:	Joe Ding
# Version:	0.5
# Last Change:	2025-04-16 20:54:55

const timefmt = '%Y-%m-%d %H:%M:%S'

export def Writeheader()   # {{{1
    # Don't modify system files.
    if getcwd() =~# substitute($VIMRUNTIME, '\\', '/', 'g')
	return
    endif

    const lines = getline(1, 20)
    var line: number

    const v9script = lines[0] =~# '^vim9s'
    const comment = v9script ? '#' : '"'

    line = match(lines, 'Version:\c')
    if line >= 0
	var vers = input("Version? ", matchstr(lines[line], ':\s*\zs.*'))
	setline(line + 1, $"{comment} Version:\t{vers}")
    endif

    line = match(lines, 'Last Change:\c')
    if line >= 0
	setline(line + 1, $"{comment} Last Change:\t{strftime(timefmt)}")
    endif
enddef

export def Execute(visual: bool)
    if !visual
	so
    elseif getline(1) !~# '^vim9s'
	:'<,'>so
    else
	vim9cmd :'<,'>so
    endif
enddef
#}}}

#defcompile
# vim.vim	vim: ts=8 sw=4
