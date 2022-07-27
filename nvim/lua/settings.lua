-- Setting options
vim.cmd('set runtimepath=' .. vim.env.HOME .. ',' .. vim.env.HOME .. 
        '/.config/nvim,$VIMRUNTIME')
vim.opt.colorcolumn = '80'
vim.cmd('colorscheme monokai')
vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.opt.statusline = '%02n:%<%f %h%m%r%=%-14.(%l,%c%V%) %P'
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.textwidth = 79
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.title = true
vim.opt.fcs = 'eob: '
vim.opt.wildmode = 'list:longest,list:full'
vim.opt.wildignore = '*.o,*.d,*.exe,*.a,*.so,*.out,*.bin,*.pyc'
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = 'eol:$,tab:>-,trail:~,nbsp:+,extends:>,precedes:<'
vim.opt.mouse = 'a'
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.joinspaces = false
vim.opt.splitright = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.confirm = true
vim.opt.backup = true
vim.opt.backupdir = vim.env.HOME .. '/.local/share/nvim/backup/'
vim.opt.updatetime = 300 -- Highlight time
vim.opt.redrawtime = 10000 -- Loading syntax in files

-- Setting environment variables
vim.env.RTP = vim.env.HOME .. '/.config/nvim'
vim.env.VRC = vim.env.HOME .. '/.config/nvim/init.lua'
vim.env.MYS = vim.env.HOME .. '/.config/nvim/sessions'

-- Spell check
vim.cmd("autocmd FileType markdown setlocal spell spelllang=en_us")
vim.cmd("autocmd FileType gitcommit setlocal spell spelllang=en_us")
vim.cmd("autocmd FileType markdown setlocal complete+=kspell")
vim.cmd("autocmd FileType gitcommit setlocal complete+=kspell")
