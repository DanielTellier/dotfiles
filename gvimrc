" Make gvim span whole window on gvim open
set lines=999 columns=9999

" Open planner folder in explorer on gvim open
augroup autoopen
    autocmd!
    autocmd VimEnter * :Ex ~/.local/share/planner
augroup END
