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

function! s:FoundSymbol(bufnr, lnum, search_pattern)
    let fpath = bufname(a:bufnr)
    let isLoaded = bufloaded(fpath)
    if isLoaded == 0
        exe 'tabnew ' . fpath
    endif

    let lineNum = a:lnum
    let lineStr = getbufline(fpath, lineNum)[0]
    let patMatch = match(lineStr, a:search_pattern)
    if isLoaded == 0
        exe 'bdelete ' . fpath
    endif

    return patMatch
endfunction

function! s:Decrement(num)
    return a:num - 1
endfunction

function! s:Increment(num)
    return a:num + 1
endfunction

function! s:FoundBufferMatch(bufnr, lnum, search_pattern, found_pattern, search_type)
    " a:search_type either 'forward' or 'backward'
    let fpath = bufname(a:bufnr)
    let isLoaded = bufloaded(fpath)
    if isLoaded == 0
        exe 'tabnew ' . fpath
    endif

    let lineStop = getbufline(fpath, '$')[0]
    let IterLine = function('s:Increment')
    if a:search_type == 'backward'
        let lineStop = getbufline(fpath, 1)[0]
        let IterLine = function('s:Decrement')
    endif
    let lineNum = a:lnum
    let lineStr = getbufline(fpath, lineNum)[0]
    let patMatch = match(lineStr, a:search_pattern)
    while patMatch == -1
        if lineStop == lineStr
            break
        endif

        let lineNum = IterLine(lineNum)
        let lineStr = getbufline(fpath, lineNum)[0]
        let patMatch = match(lineStr, a:search_pattern)
    endwhile

    if isLoaded == 0
        exe 'bdelete ' . fpath
    endif

    if match(lineStr, a:found_pattern) != -1
        return lineNum
    endif

    return -1
endfunction

" Find a function definition for C/Cpp/Cu
" Still searches if commented out
function! search#Cfunc_(name)
    call s:RunGrep('c,cc,cpp,cu', a:name, 'exact')

    let newqfLst = []
    let qfLst = getqflist()
    for qfi in qfLst
        if s:FoundBufferMatch(qfi.bufnr, qfi.lnum, '[{;]', '{', 'forward') != -1
            let newqfLst += [qfi]
        endif
    endfor

    call s:CheckQFlist(newqfLst)
endfunction

" Find a class definition for C/Cpp/Cu
" Still searches if commented out
function! search#Cclass_(name)
    call s:RunGrep('c,cc,cpp,cu,h,hh,hpp,hcu,cuh', a:name, 'exact')

    let newqfLst = []
    let qfLst = getqflist()
    for qfi in qfLst
        if s:FoundBufferMatch(qfi.bufnr, qfi.lnum, ';\|{\|class', 'class', 'backward') != -1
            let newqfLst += [qfi]
        endif
    endfor

    call s:CheckQFlist(newqfLst)
endfunction

" Find a struct definition for C/Cpp/Cu
" Still searches if commented out
function! search#Cstruct_(name)
    call s:RunGrep('c,cc,cpp,cu,h,hh,hpp,hcu,cuh', a:name, 'exact')

    let newqfLst = []
    let qfLst = getqflist()
    for qfi in qfLst
        let found = -1
        let foundCol = s:FoundSymbol(qfi.bufnr, qfi.lnum, '[;}]')
        if foundCol != -1
            let foundLine = s:FoundBufferMatch(qfi.bufnr, qfi.lnum, '[;}]', '}', 'backward')
            if foundLine == -1
                continue
            endif
            let curr_path = bufname('%')
            " Make found buffer current opened buffer
            let fpath = bufname(qfi.bufnr)
            let isLoaded = bufloaded(fpath)
            exe 'norm! e ' . fpath
            " Put cursor at the found line
            let moveToLine = foundLine - 1
            exe 'norm! gg'
            exe 'norm! ' . moveToLine . 'j'
            " Know foundLine has '}' in it's line number
            let foundCol = s:FoundSymbol(qfi.bufnr, foundLine, '}')
            " Move cursor to column where '}' is located
            exe 'norm! ' . foundCol . '|'
            " Move cursor to corresponding '{'
            exe 'norm! %'
            " Get line number where cursor is located
            let foundLine = line('.')
            let found = s:FoundBufferMatch(
                qfi.bufnr, foundLine, ';\|struct', 'struct', 'backward'
            )
            exe 'norm! e ' . curr_path
            if isLoaded == 0
                exe 'bdelete ' . fpath
            endif
        else
            let found = s:FoundBufferMatch(qfi.bufnr, qfi.lnum, ';\|struct', 'struct', 'backward')
        endif
        if found != -1
            let newqfLst += [qfi]
        endif
    endfor

    call s:CheckQFlist(newqfLst)
endfunction


" Find a function/class definition for Python
" Still searches if commented out
function! search#Pydef_(name, def_type)
    " a:def_type either 'def' or 'class'
    call s:RunGrep('py', a:name, 'exact')

    let newqfLst = []
    let qfLst = getqflist()
    for qfi in qfLst
        if s:FoundBufferMatch(qfi.bufnr, qfi.lnum, a:def_type, a:def_type, 'forward') != 1
            let newqfLst += [qfi]
        endif
    endfor

    call s:CheckQFlist(newqfLst)
endfunction
