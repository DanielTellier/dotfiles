if exists('g:autoloaded_search')
  finish
endif
let g:autoloaded_search = 1

function! search#Grep_(ext, pattern)
    if a:ext == 'cc'
        let fincs = '{c,cc,cpp,cu}'
    elseif a:ext == 'hh'
        let fincs = '{h,hpp,cuh}'
    elseif a:ext == 'mk'
        let fincs = '{Makefile,makefile,mk}'
    elseif a:ext == 'py'
        let fincs = 'py'
    elseif a:ext == 'sh'
        let fincs = 'sh'
    elseif a:ext == 'all'
        let fincs = '*'
    else
        " a:ext example: py,sh,c
        " Need ',' at end in case only provide one extension
        let fincs = '{' . a:ext . ',}'
    endif

    " With 'j' only the quickfix list is updated. With the [!] any changes
    " in the current buffer are abandoned.
    " Need *.{exts} **/*.{exts} since the latter does not search the top directory
    exe 'silent vimgrep! /' . a:pattern . '/j *.' . fincs . ' **/*.' . fincs | cw | redraw!
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

    return
endfunction

" Find a function definition for C/Cpp/Cu
function! search#Cdef_(funcName)
    let fincs = '{c,cc,cpp,cu}'
    exe 'silent vimgrep! /\<' . a:funcName . '\>/j *.' . fincs
        \ . ' **/*.' . fincs | redraw!

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

    return
endfunction

" Find a function/class definition for Python
function! search#Pydef_(funcName, def_type)
    " a:def_type either 'def' or 'class'
    exe 'silent vimgrep! /\<' . a:funcName . '\>/j *.py **/*.py' | redraw!

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

    return
endfunction
