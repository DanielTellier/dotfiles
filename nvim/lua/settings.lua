local utils = require('utils')

-- Variables
local sesh_dir = "~/.nvim-sessions"
vim.g.fugitive_git_executable = "/usr/bin/git"
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.rehash256 = 1

-- Colorscheme and syntax
if vim.fn.has("termguicolors") == 1 then
    vim.opt.termguicolors = true
end
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- Macros
-- NOTE: ASCII representation of keys
-- \032 -> <Space>
-- \027 -> <Esc>
-- To save a macro run `:registers` to copy the macro you ran
-- https://this/is/a/link --> [link](https://this/is/a/link)
-- Assumes does not end with a slash
vim.fn.setreg('l', '0LT/vLhy0i[]\027hplli(\027La)\027j')
-- Fix line to 75 + up to next space
vim.fn.setreg('n', '075lf\032a\b\r\027j')

-- Highlight settings
vim.cmd([[
    highlight Visual cterm=NONE ctermbg=yellow ctermfg=white
    highlight Visual gui=NONE guibg=yellow guifg=white
    highlight IncSearch cterm=NONE ctermbg=blue ctermfg=white
    highlight IncSearch gui=NONE guibg=blue guifg=white
    highlight Search cterm=NONE ctermbg=green ctermfg=white
    highlight Search gui=NONE guibg=green guifg=white
]])

-- General settings
vim.opt.writebackup = true
vim.opt.backspace = "start,eol,indent"
vim.opt.colorcolumn = "90"
vim.opt.complete = ".,w,b,u,t"
vim.opt.confirm = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
vim.opt.foldenable = false
vim.opt.foldlevel = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = ">-", precedes = ".", trail = ".", extends = ".", eol = "$" }
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.redrawtime = 10000
vim.opt.viminfo:append("n~/.nviminfo")
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.statusline = utils.statusline()
vim.opt.switchbuf = "split"
vim.opt.title = true
vim.opt.ttyfast = true
vim.opt.timeoutlen = 3000
vim.opt.ttimeoutlen = 100
vim.opt.undolevels = 100
vim.opt.updatetime = 1000
vim.opt.wildignore = "*/__pycache__/*,*.o,*.d,*.exe,*.a,*.so,*.out,*.pyc"
vim.opt.wildmode = "longest:full,full"
vim.opt.sessionoptions:remove("options")
vim.opt.sessionoptions:remove("folds")
