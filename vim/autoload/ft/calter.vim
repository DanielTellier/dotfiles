if exists('g:autoloaded_calter')
    finish
endif
let g:autoloaded_calter = 1

" Find a function definition for C/Cpp/Cu
function! ft#calter#Cdef_(funcName)
    exe 'silent grep! -wr --include="*.c" --include="*.cpp" ' .
         \ '--include="*.c[cu]" ' . a:funcName . ' .' | redraw!

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

    if len(newqfLst) > 0
        let qfi = newqfLst[0]
        let fpath = bufname(qfi.bufnr)
        if len(newqfLst) == 1
            call setqflist([], 'r')
        else
            call setqflist(newqfLst, 'r')
        endif
        exe 'sp +' . qfi.lnum . ' ' . fpath
        echo "File Found at " . qfi.lnum
    else
        echo "File Not Found"
    endif

    return
endfunction
