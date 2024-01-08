command! -nargs=1 Cdef call search#Cdef_(<f-args>)

" C defintion Mapping under cursor
nnoremap <silent> <leader>cg :Cdef "\b<c-r><c-w>\b"<cr>:cw<cr>

compiler gcc
