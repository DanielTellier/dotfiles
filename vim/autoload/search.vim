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

  exe 'silent! grep! -r ' . fincs . ' ' . a:pattern .
    \ ' ' . a:dir | cw | redraw!
endfunction
