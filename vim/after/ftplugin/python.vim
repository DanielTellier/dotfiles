setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

command! -nargs=+ Pydef call search#Pydef_(<q-args>, 'def')
command! -nargs=+ Pyclass call search#Pydef_(<q-args>, 'class')

" Python function defintion Mapping under cursor
nnoremap <silent> <leader>df :Pydef <c-r><c-w><cr>:cw<cr>
" Python class defintion Mapping under cursor
nnoremap <silent> <leader>dc :Pyclass <c-r><c-w><cr>:cw<cr>

compiler python
