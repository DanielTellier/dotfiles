"" Settings
set runtimepath+=$HOME/.config/nvim
set wildignore=*.o,*.d,*.exe,*.a,*.so,*.out
set backspace=indent,eol,start
set hidden
set noswapfile
set shiftwidth=2 tabstop=2 softtabstop=2 expandtab
set autoindent smartindent smartcase
set encoding=utf-8
set hls
set wildmenu
set wildmode=list:longest,full
set number
set colorcolumn=80
set showcmd
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
filetype plugin indent on
syntax on
set t_Co=256
colorscheme monokai

let $RTP=split(&runtimepath,',')[0]
let $VRC=$HOME."/.config/nvim/init.vim"
let $MYS=$HOME."/.config/nvim/sessions"

"" Functions
function! Grep_(pattern, ext, dir)

  if a:ext == 'cc'
    let fincs = '--include="*.c" --include="*.cpp" --include="*.cu"'
  elseif a:ext == 'hh'
    let fincs = '--include="*.h" --include="*.hpp" --include="*.cuh"'
  elseif a:ext == 'mk'
    let fincs = '--include="Makefile" --include="makefile" --include="*.mk"'
  else
    let fincs = '--include="*.c" --include="*.cpp" --include="*.cu" ' .
      \ '--include="*.h" --include=*.hpp --include=*.cuh ' .
      \ '--include="Makefile" --include="makefile" --include="*.mk"'
  endif

  exe 'silent! grep! -rw ' . fincs . ' ' . a:pattern .
    \ ' ' . a:dir | cw | redraw!

endfunction

function! MkSession_()
  !ls $MYS
  let fname = input("Mk File: ")
  let $fpath = $MYS.fname.'.vim'
  mksession! $fpath
endfunction

function! SoSession_()
  !ls $MYS
  let fname = input("Mk File: ")
  let $fpath = $MYS.fname.'.vim'
  so $fpath
endfunction

function! FindIncFile_(fname)
  let $incfile = system('find . -name ' . a:fname)
  let $incfile = substitute($incfile, '\n', '\1', '')
  sp $incfile
endfunction

"" Commands
" Find C/C++ function definition
command! -nargs=1 Cdef call ft#calter#Cdef_(<f-args>)

command! -nargs=+ -complete=file Grep call Grep_(<f-args>)

command! -nargs=0 MkSession call MkSession_()

command! -nargs=0 SoSession call SoSession_()

command! -nargs=1 -complete=file FindIncFile call FindIncFile_(<f-args>)

" Spell check
autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType gitcommit setlocal spell spelllang=en_us
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType gitcommit setlocal complete+=kspell

"" Mappings
" Force use of hjkl-style movement and up(c-b)/down(c-f)
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
map <pageup> <nop>
map <pagedown> <nop>
map <home> <nop>
map <end> <nop>

imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
imap <pageup> <nop>
imap <pagedown> <nop>
imap <home> <nop>
imap <end> <nop>

" Command line mode without shift+:
noremap ; :

" Faster split window navigation
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>

" Remove highlight after search
nnoremap <leader>h :nohls<cr>

" Buffer Mappings
nnoremap <leader>b :buffers<cr>:buffer<space>
nnoremap <leader>o :sp<cr>:buffers<cr>:buffer<space>
nnoremap <leader>v :vs<cr>:buffers<cr>:buffer<space>
nnoremap <leader>t :e#<cr>

" C defintion Mapping
nnoremap <leader>d :Cdef "\b<c-r><c-w>\b"<cr>:cw<cr>

" Search word under cursor
nnoremap <leader>w :Grep all "\b<c-r><c-w>\b"<cr>:cw<cr> .
nnoremap <leader>g :Grep<space>

" Sessions
nnoremap <leader>m :MkSession<cr>
nnoremap <leader>s :SoSession<cr>

nnoremap <leader>f :FindIncFile "\b<c-r><c-w>\b"<cr>
nnoremap <leader>F :FindIncFile<space>

" Mappings for quickfix list
nmap <silent> <c-n> :cn<cr>zv
nmap <silent> <c-p> :cp<cr>zv
