"" Functions
function! FindIncFile_(fname)
  let $incfile = system('find . -name ' . a:fname)
  let $incfile = substitute($incfile, '\n', '\1', '')
  sp $incfile
endfunction

"" Commands
command! -nargs=1 -complete=file FindIncFile call FindIncFile_(<f-args>)

"" Mappings

" Comments
nnoremap <leader>sc :s/^\s*/\/\/<cr>:nohlsearch<cr>
nnoremap <leader>su :s/^\s*\/\//<cr>

vnoremap <leader>mc :s/^\s*/\/\/<cr>:nohlsearch<cr>
vnoremap <leader>mu :s/^\s*\/\//<cr>

" Find header files
nnoremap <leader>fg :FindIncFile "\b<c-r><c-w>\b"<cr>
nnoremap <leader>fi :FindIncFile<space>

"" Compiler
compiler gcc
