if exists('g:autoloaded_search')
  finish
endif
let g:autoloaded_search = 1

function! search#Grep_(dir, ext, pattern)
  if a:ext == 'cc'
    let fincs = '--include="*.c" --include="*.cpp" --include="*.cu"'
  elseif a:ext == 'hh'
    let fincs = '--include="*.h" --include="*.hpp" --include="*.cuh"'
  elseif a:ext == 'mk'
    let fincs = '--include="Makefile" --include="makefile" --include="*.mk"'
  elseif a:ext == 'py'
    let fincs = '--include="*.py"'
  elseif a:ext == 'sh'
    let fincs = '--include="*.sh"'
  elseif a:ext == 'all'
    let fincs = ''
  else
    let exts = split(a:ext, ",")
    let fincs = ""
    for e in exts
      let fincs = '--include="' . e . '" ' . fincs
    endfor
  endif

  exe 'silent grep! -r ' . fincs . ' ' . a:pattern .
    \ ' ' . a:dir | split | cw | redraw!
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

    call s:CheckQFlist(newqfLst)

    return
endfunction

" Find a function definition for Python
function! search#Pydef_(funcName)
    exe 'silent grep! -wr --include="*.py" ' . a:funcName . ' .' | redraw!

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

        if match(lineStr, 'def') != -1
            let newqfLst += [qfi] 
        endif
    endfor

    call s:CheckQFlist(newqfLst)

    return
endfunction
