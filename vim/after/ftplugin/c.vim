command! -nargs=1 Cdef call search#Cdef_(<f-args>)

" C function defintion Mapping under cursor
nnoremap <silent> <leader>df :Cdef <c-r><c-w><cr>:cw<cr>

compiler gcc
