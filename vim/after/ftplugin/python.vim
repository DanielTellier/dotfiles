setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

command! -nargs=1 Pydef call search#Pydef_(<f-args>)

" Python defintion Mapping under cursor
nnoremap <silent> <leader>cg :Pydef "\b<c-r><c-w>\b"<cr>:cw<cr>

compiler python
