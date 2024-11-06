local utils = require('utils')
local search = require('search')

-- Autocommands
vim.cmd([[
augroup status-line
    autocmd!
    autocmd BufEnter,SourcePost * lua vim.opt.statusline=require('utils').statusline()
augroup END

augroup spellcheck
    autocmd!
    autocmd FileType gitcommit,markdown setlocal spell spelllang=en_us
    autocmd FileType gitcommit,markdown setlocal complete+=kspell
    autocmd FileType tex,latex,context,plaintex setlocal spell spelllang=en_us
    autocmd FileType tex,latex,context,plaintex setlocal complete+=kspell
augroup END

augroup netrw-group
    autocmd!
    autocmd FileType netrw setlocal bufhidden=delete
    autocmd FileType netrw noremap <buffer> <c-l> <c-w>l
    autocmd FileType netrw nnoremap <buffer> <silent> <nowait> <leader>i :lua require('utils').split_netrw("edit", false)<cr>
    autocmd FileType netrw nnoremap <buffer> <silent> <nowait> <leader>o :lua require('utils').split_netrw("split", false)<cr>
    autocmd FileType netrw nnoremap <buffer> <silent> <nowait> <leader>v :lua require('utils').split_netrw("vsplit", false)<cr>
    autocmd FileType netrw nnoremap <buffer> <silent> <nowait> <leader>I :lua require('utils').split_netrw("edit", true)<cr>
    autocmd FileType netrw nnoremap <buffer> <silent> <nowait> <leader>O :lua require('utils').split_netrw("split", true)<cr>
    autocmd FileType netrw nnoremap <buffer> <silent> <nowait> <leader>V :lua require('utils').split_netrw("vsplit", true)<cr>
    autocmd FileType netrw :exe '0file!'
augroup END

augroup colors-group
    autocmd!
    autocmd VimEnter,ColorScheme * hi Comment        cterm=italic gui=italic
    autocmd VimEnter,ColorScheme * hi SpecialComment cterm=italic gui=italic
    autocmd VimEnter,ColorScheme * hi ColorColumn ctermbg=gray guibg=gray
augroup END

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* lua require('utils').remove_duplicate_quickfix_entries()
augroup END

augroup misc
    autocmd!
    autocmd FileType xml setlocal noeol
    autocmd VimEnter * silent! echo -ne "\e[2 q"
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    autocmd BufEnter * setlocal formatoptions-=cro
augroup END
]])

-- Commands
vim.api.nvim_create_user_command('Grep', function(args)
    print(vim.inspect(args.fargs))
    search.search_grep(unpack(args.fargs))
end, { nargs = '+' })
vim.api.nvim_create_user_command('SearchBuffers', function(args) utils.search_buffers_(args.args) end, { nargs = 1 })
vim.api.nvim_create_user_command('RemoveWhichBuffer', function(args) utils.remove_matching_buffers(args.args) end, { nargs = 1 })
