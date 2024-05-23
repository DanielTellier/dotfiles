if exists('g:autoloaded_search')
  finish
endif
let g:autoloaded_search = 1

function! s:RunGrep(exts, pattern, gtype)
    " a:exts example: py or py,sh,c
    let l:exts = split(a:exts, ",")
    " a:gtype either 'exact' or 'nonexact'
    let git_dir = FugitiveExtractGitDir('.')
    " Check if in git repo so able to run Ggrep else run vimgrep
    if git_dir != ''
        let fincs = ''
        if a:exts != 'all'
            for e in l:exts
                let fincs = fincs . " '*.'" . e
            endfor
            let fincs = ' --' . fincs
        endif
        let cmd = 'silent! Ggrep! -r'
        if a:gtype == 'exact'
            let cmd = cmd . ' -w'
        else
            let cmd = cmd . ' -i'
        endif
        let cmd = cmd . ' "' . a:pattern . '"' . fincs
        exe cmd
        echom 'Ran ' . cmd
    else
        let fincs = ''
        if a:exts == 'all'
            let fincs = ' --include=*'
        else
            for e in l:exts
                let fincs = fincs . ' --include="*.' . e . '"'
            endfor
        endif
        let cmd = 'silent! grep! -r'
        if a:gtype == 'exact'
            let cmd = cmd . ' -w'
        else
            let cmd = cmd . ' -i'
        endif
        let cmd = cmd . fincs . ' ' . a:pattern . ' .'
        exe cmd
        echom 'Ran ' . cmd
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
