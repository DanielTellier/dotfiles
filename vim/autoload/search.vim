if exists('g:autoloaded_search')
  finish
endif
let g:autoloaded_search = 1

function! s:RunGrep(exts, pattern, gtype)
    " a:gtype either 'exact' or 'nonexact'
    let git_dir = FugitiveExtractGitDir('.')
    " Check if in git repo so able to run Ggrep else run vimgrep
    if git_dir != ''
        let l:exts = split(a:exts, ",")
        let fincs = ''
        if a:exts != 'all'
            let fincs = ''
            for e in l:exts
                let fincs = fincs . " '*.'" . e
            endfor
            let fincs = ' --' . fincs
        endif
        let cmd = 'silent Ggrep! '
        if a:gtype == 'exact'
            let cmd = cmd . '-wr'
        else
            let cmd = cmd . '-r'
        endif
        exe cmd . ' "' . a:pattern . '"' . fincs
        echom 'Ran Ggrep!'
    else
        if a:exts == 'all'
            let fincs = '*'
        else
            " a:exts example: py,sh,c
            " Need ',' at end in case only provide one extension
            let fincs = '{' . a:exts . ',}'
        endif
        " Without the 'g' flag each line is added only once.
        " With 'g' every match is added.
        " With 'j' only the quickfix list is updated. With the [!] any changes
        " in the current buffer are abandoned.
        " Need *.{exts} **/*.{exts} since the latter does not search the top directory
        let cmd = 'silent vimgrep! '
        if a:gtype == 'exact'
            let cmd = cmd . '/\<' . a:pattern . '\>/gj'
        else
            let cmd = cmd . '/' . a:pattern . '/gj'
        endif
        exe cmd . ' *.' . fincs . ' **/*.' . fincs
        echom 'Ran vimgrep!'
    endif
endfunction

function! search#Grep_(exts, pattern)
    call s:RunGrep(a:exts, a:pattern, 'nonexact')
    cw | redraw!
endfunction

function! s:CheckQFlist(qflist)
    if len(a:qflist) > 0
        let qfi = a:qflist[0]
        let fpath = bufname(qfi.bufnr)
        if len(a:qflist) == 1
            call setqflist([], 'r')
        else
            call setqflist(a:qflist, 'r')
        endif
        exe 'sp +' . qfi.lnum . ' ' . fpath
        echo "File Found at " . qfi.lnum
    else
        echo "File Not Found"
    endif
endfunction

" Find a function definition for C/Cpp/Cu
function! search#Cdef_(funcName)
    call s:RunGrep('c,cc,cpp,cu', a:funcName, 'exact')

    let newqfLst = []
    let qfLst = getqflist()
    for qfi in qfLst
        let fpath = bufname(qfi.bufnr)
        let isLoaded = bufloaded(fpath)
        if isLoaded == 0
            exe 'tabnew ' . fpath
        endif

        let lineEOF = getbufline(fpath, '$')[0]
        let lineNum = qfi.lnum
        let lineStr = getbufline(fpath, lineNum)[0]
        let matches = match(lineStr, '[/{;]')
        while matches == -1
            if lineEOF == lineStr
                break
            endif

            let lineNum += 1
            let lineStr = getbufline(fpath, lineNum)[0]
            let matches = match(lineStr, '[/{;]')
        endwhile

        if isLoaded == 0
            exe 'bdelete ' . fpath
        endif

        if match(lineStr, '{') != -1
            let newqfLst += [qfi] 
        endif
    endfor

    call s:CheckQFlist(newqfLst)
endfunction

" Find a function/class definition for Python
function! search#Pydef_(funcName, def_type)
    " a:def_type either 'def' or 'class'
    call s:RunGrep('py', a:funcName, 'exact')

    let newqfLst = []
    let qfLst = getqflist()
    for qfi in qfLst
        let fpath = bufname(qfi.bufnr)
        let isLoaded = bufloaded(fpath)
        if isLoaded == 0
            exe 'tabnew ' . fpath
        endif

        let lineEOF = getbufline(fpath, '$')[0]
        let lineNum = qfi.lnum
        let lineStr = getbufline(fpath, lineNum)[0]
        if isLoaded == 0
            exe 'bdelete ' . fpath
        endif

        if match(lineStr, a:def_type) != -1
            let newqfLst += [qfi] 
        endif
    endfor

    call s:CheckQFlist(newqfLst)
endfunction
