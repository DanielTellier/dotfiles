" Functions
function! FindIncFile_(fname)
  let $incfile = system('find . -name ' . a:fname)
  let $incfile = substitute($incfile, '\n', '\1', '')
  sp $incfile
endfunction

" Commands
command! -nargs=1 Cdef call ft#calter#Cdef_(<f-args>)
command! -nargs=1 -complete=file FindIncFile call FindIncFile_(<f-args>)

" Mappings
"" C defintion Mapping under cursor
nnoremap <leader>cg :Cdef "\b<c-r><c-w>\b"<cr>:cw<cr>

"" Find header files
nnoremap <leader>fg :FindIncFile "\b<c-r><c-w>\b"<cr>
nnoremap <leader>fi :FindIncFile<space>

"" Comments
nnoremap <leader>cc :s/^\s*/\/\/<cr>:nohlsearch<cr>
nnoremap <leader>uc :s/^\s*\/\//<cr>
vnoremap <leader>cc :s/^\s*/\/\/<cr>:nohlsearch<cr>
vnoremap <leader>uc :s/^\s*\/\//<cr>

"" Compiler
compiler gcc
