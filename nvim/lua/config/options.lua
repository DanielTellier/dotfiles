local opt = vim.opt

-- Variables
vim.g.fugitive_git_executable = "/usr/bin/git"
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.rehash256 = 1
-- Setting g:netrw_keepdir to 0 tells netrw to make vim's current directory
-- track netrw's browsing directory.
vim.g.netrw_keepdir = 0

-- Colorscheme and syntax
if vim.fn.has("termguicolors") == 1 then
    opt.termguicolors = true
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
-- Move comma separated parameters to own line for a function call/definition
vim.fn.setreg('f', 'f,lli\b\r\027')

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
-- The following global variables stored must:
--  * Start with an uppercase letter and contain at least one lowercase letter.
--  * Only String and Number types are stored.
opt.backspace = "start,eol,indent"
if os.getenv("SSH_TTY") then
    vim.cmd("let g:clipboard = 'osc52'")
else
    opt.clipboard = "unnamedplus"
end
opt.colorcolumn = "90"
opt.complete = ".,w,b,u,t"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0
opt.confirm = true
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true
opt.foldenable = false
opt.foldlevel = 2
opt.foldmethod = "indent"
opt.foldnestmax = 10
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,t:block"
opt.ignorecase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true
opt.listchars = { tab = ">-", precedes = ".", trail = ".", extends = ".", eol = "$" }
opt.mouse = ""
opt.number = true
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.redrawtime = 10000
opt.relativenumber = true
opt.scrolloff = 8
opt.sessionoptions= { "blank", "buffers", "curdir", "folds", "globals", "help", "tabpages", "winsize", "winpos", "terminal", "localoptions" }
opt.shiftwidth = 4
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true
opt.smartindent = true -- Insert indents automatically
opt.softtabstop = 4
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true
opt.swapfile = false
opt.switchbuf = "split"
opt.tabstop = 4
opt.timeoutlen = 1000
opt.title = true
opt.ttimeoutlen = 100
opt.ttyfast = true
opt.undolevels = 100
opt.updatetime = 1000
opt.viminfo:append("n~/.nviminfo")
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildignore = "*/__pycache__/*,*.o,*.d,*.exe,*.a,*.so,*.out,*.pyc"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false
opt.writebackup = true
