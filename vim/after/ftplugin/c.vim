command! -nargs=1 Cfunc call search#Cfunc_(<f-args>)
command! -nargs=1 Cclass call search#Cclass_(<f-args>)
command! -nargs=1 Cstruct call search#Cstruct_(<f-args>)

" C func defintion Mapping under cursor
nnoremap <silent> <leader>cfu :Cfunc <c-r><c-w><cr>:cw<cr>
" C class defintion Mapping under cursor
nnoremap <silent> <leader>css :Cclass <c-r><c-w><cr>:cw<cr>
" C struct defintion Mapping under cursor
nnoremap <silent> <leader>cst :Cstruct <c-r><c-w><cr>:cw<cr>

compiler gcc
