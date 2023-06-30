" Make gvim span whole window on gvim open
set lines=999 columns=9999

" Set font settings
if has("gui_gtk2") || has("gui_gtk3")
    " Linux
    set guifont=Andale\ Mono\ 13
elseif has("gui_macvim")
    " Mac OSX
    set guifont=Monaco:h13
endif

" Disable beep and flash
set vb t_vb=

" Open planner folder in explorer on gvim open
augroup autoopen
    autocmd!
    autocmd VimEnter * :Ex ~/.local/share/planner
augroup END
