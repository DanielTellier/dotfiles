"" Settings
set runtimepath+=$HOME/.config/nvim
set colorcolumn=80
colorscheme monokai
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set expandtab shiftwidth=4 tabstop=4 softtabstop=4
set textwidth=79
set ignorecase smartcase
set noswapfile
set number
set termguicolors
set undofile
set title
set wildmode=longest:full,full
set wildignore=*.o,*.d,*.exe,*.a,*.so,*.out
set nowrap
set list
set mouse=a
set scrolloff=8
set sidescrolloff=8
set nojoinspaces
set splitright
set clipboard=unnamedplus
set confirm
set exrc
set backup
set backupdir=~/.local/share/nvim/backup/
set updatetime=300 " Highlight time
set redrawtime=10000 " Loading syntax in files

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

"" Commands

" Find C/C++ function definition
command! -nargs=1 Cdef call ft#calter#Cdef_(<f-args>)

command! -nargs=+ -complete=file Grep call Grep_(<f-args>)

command! -nargs=0 MkSession call MkSession_()

command! -nargs=0 SoSession call SoSession_()


"" Spell check

autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType gitcommit setlocal spell spelllang=en_us
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType gitcommit setlocal complete+=kspell

"" Mappings

let mapleader = "\\"

" Deal with vimrc (init.vim)
nmap <leader>ve :edit $VRC<cr>
nmap <leader>vr :source $VRC<cr>

" Delete buffer
nmap <leader>qq :bufdo q<cr>

" Remove highlight after search
nnoremap <leader>nh :nohlsearch<cr>

" Buffer Mappings
nnoremap <leader>be :buffers<cr>:buffer<space>
nnoremap <leader>bo :sp<cr>:buffers<cr>:buffer<space>
nnoremap <leader>bv :vs<cr>:buffers<cr>:buffer<space>
nnoremap <leader>bt :e#<cr>

" C defintion Mapping
nnoremap <leader>cd :Cdef "\b<c-r><c-w>\b"<cr>:cw<cr>

" Search word under cursor
nnoremap <leader>ws :Grep all "\b<c-r><c-w>\b"<cr>:cw<cr> .
nnoremap <leader>gs :Grep<space>

" Sessions
nnoremap <leader>mk :MkSession<cr>
nnoremap <leader>so :SoSession<cr>

" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

" Paste replace visual selection without copying it
vnoremap <leader>p "_dP

" Make Y behave like the other capitals
nnoremap Y y$

" Keep it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Easy insertion of a trailing ; or , from insert mode
imap ;; <Esc>A;<Esc>
imap ,, <Esc>A,<Esc>

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

" Escape to normal mode
imap jj <esc>

" Command line mode without shift+:
noremap ; :

" Faster split window navigation
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>

" Mappings for quickfix list
nmap <silent> <c-n> :cn<cr>zv
nmap <silent> <c-p> :cp<cr>zv

cmap w!! %!sudo tee > /dev/null %
