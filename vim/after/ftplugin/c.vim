function! FindIncFile_(fname)
  let $incfile = system('find . -name ' . a:fname)
  let $incfile = substitute($incfile, '\n', '\1', '')
  sp $incfile
endfunction

command! -nargs=1 Cdef call ft#calter#Cdef_(<f-args>)
command! -nargs=1 -complete=file FindIncFile call FindIncFile_(<f-args>)

" C defintion Mapping under cursor
nnoremap <leader>cg :Cdef "\b<c-r><c-w>\b"<cr>:cw<cr>

" Find header files
nnoremap <leader>fg :FindIncFile "\b<c-r><c-w>\b"<cr>
nnoremap <leader>fi :FindIncFile<space>

compiler gcc
