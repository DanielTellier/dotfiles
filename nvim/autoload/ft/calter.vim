" Find a function definition for C/Cpp/Cu
function! ft#calter#Cdef_(funcName)

  exe 'silent grep! -wr --include="*.c" --include="*.cpp" ' .
     \ '--include="*.cu" ' . a:funcName . ' .' | redraw!
  
  let newqfLst = []
  let qfLst = getqfiist()
  for qfi in qfLst
    let fpath = bufname(qfi.bufnr)
    let _ = bufload(fpath)

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
      
    if match(lineStr, '{') != -1
      let newqfLst += [qfi] 
    endif
  endfor

  if len(newqfLst) > 0
    let qfi = newqfLst[0]
    let fpath = bufname(qfi.bufnr)
    if len(foundqfLst) == 1
      setqflist([], 'r')
    else
      setqflist(newqfLst, 'r')
    endif
    exe 'new +' . qfi.lnum . ' ' . fpath
    echo "File Found at " . qfi.lnum
  else
    echo "File Not Found"
  endif

  return

endfunction
