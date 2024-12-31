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
vim.opt.backspace = "start,eol,indent"
-- Attempt to enable clipboard support only if SSH_TTY is unset
if not os.getenv("SSH_TTY") then
    vim.opt.clipboard:append("unnamedplus")
end
vim.opt.colorcolumn = "90"
vim.opt.complete = ".,w,b,u,t"
vim.opt.confirm = false
vim.opt.expandtab = true
vim.opt.foldenable = false
vim.opt.foldlevel = 2
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = { tab = ">-", precedes = ".", trail = ".", extends = ".", eol = "$" }
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.redrawtime = 10000
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sessionoptions:remove("folds")
vim.opt.sessionoptions:remove("options")
vim.opt.shiftwidth = 4
vim.opt.sidescrolloff = 8
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitright = true
vim.opt.statusline = utils.statusline()
vim.opt.swapfile = false
vim.opt.switchbuf = "split"
vim.opt.tabstop = 4
vim.opt.timeoutlen = 3000
vim.opt.title = true
vim.opt.ttimeoutlen = 100
vim.opt.ttyfast = true
vim.opt.undolevels = 100
vim.opt.updatetime = 1000
vim.opt.viminfo:append("n~/.nviminfo")
vim.opt.wildignore = "*/__pycache__/*,*.o,*.d,*.exe,*.a,*.so,*.out,*.pyc"
vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = true
vim.opt.writebackup = true
