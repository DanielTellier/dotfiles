-- Vim globals
vim.g.mapleader = '<space>'
vim.g.maplocalleader = '<space>s'

-- Vim cmds
vim.cmd('set runtimepath=' .. vim.env.HOME .. ',' .. vim.env.HOME .. 
        '/.config/nvim,$VIMRUNTIME')
vim.cmd('hi ColorColumn ctermbg=grey guibg=grey')

--- Spell check
vim.cmd([[
  augroup spellcheck
    autocmd!
    autocmd FileType gitcommit,markdown setlocal spell spelllang=en_us
    autocmd FileType gitcommit,markdown setlocal complete+=kspell
    autocmd FileType tex,latex,context,plaintex setlocal spell spelllang=en_us
    autocmd FileType tex,latex,context,plaintex setlocal complete+=kspell
  augroup end
]])

-- Functions
function pack_setup()
  vim.cmd('PackerClean')
  vim.cmd('PackerInstall')
  vim.cmd('PackerCompile')
end

-- Vim Options
vim.opt.colorcolumn = '80'
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
vim.opt.relativenumber = true
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

-- Environment variables
vim.env.RTP = vim.env.HOME .. '/.config/nvim/'
vim.env.VRC = vim.env.HOME .. '/.config/nvim/init.lua'
vim.env.MKS = vim.env.HOME .. '/.config/nvim/sessions'

-- Mappings
local opts = {
  nrsil = { noremap = true, silent = true },
  nr = { noremap = true, silent = false },
  sil = { noremap = false, silent = true },
  nops = { noremap = false, silent = false },
}
--- init.lua
vim.keymap.set('n', '<localleader>e', ':edit $VRC<cr>', opts.nrsil)

--- Sessions
---- Handle recent session
vim.keymap.set('n', '<localleader>mr', ':mksession! $MKS/recent.vim<cr>',
  opts.nrsil)
vim.keymap.set('n', '<localleader>sr', ':so $MKS/recent.vim<cr>', opts.nrsil)

---- Handle specific session
vim.keymap.set('n', '<localleader>ms', ':mksession! $MKS/',
  opts.nr)
vim.keymap.set('n', '<localleader>ss', ':so $MKS/', opts.nr)

--- Packer setup
vim.keymap.set('n', '<localleader>ps', ':lua pack_setup()<cr>', opts.nrsil)

--- Toggle highlight
vim.keymap.set('n', '<localleader>h',
  ':if (&hls && v:hlsearch) | nohlsearch | else | set hlsearch | endif<cr>',
  opts.nrsil)

--- Buffers
vim.keymap.set('n', '<localleader>be',
  ':buffers<cr>:buffer<space>', opts.nr)
vim.keymap.set('n', '<localleader>bo',
  ':sp<cr>:buffers<cr>:buffer<space>', opts.nr)
vim.keymap.set('n', '<localleader>bv',
  ':vs<cr>:buffers<cr>:buffer<space>', opts.nr)
vim.keymap.set('n', '<localleader>bt',
  ':e#<cr>', opts.nrsil)
vim.keymap.set('n', '<localleader>bn',
  ':bnext<cr>', opts.nrsil) -- next buffer
vim.keymap.set('n', '<localleader>bp',
  ':bprevious<cr>', opts.nrsil) -- previous buffer
vim.keymap.set('n', '<localleader>bq',
  ':Bdelete<cr>', opts.nrsil) -- close buffer

--- Paste replace visual selection without copying it
vim.keymap.set('v', '<localleader>p', '"_dP', opts.nrsil)

--- Maintain the cursor position when yanking a visual selection
--- http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.keymap.set('v', 'y', 'myy`y', opts.nrsil)
vim.keymap.set('v', 'Y', 'myY`y', opts.nrsil)

--- Make Y behave like the other capitals
vim.keymap.set('n', 'Y', 'y$', opts.nrsil)

--- Keep it centered
vim.keymap.set('n', 'n', 'nzzzv', opts.nrsil)
vim.keymap.set('n', 'N', 'Nzzzv', opts.nrsil)
vim.keymap.set('n', 'J', 'mzJ`z', opts.nrsil)

--- Command line mode without <s-:>
vim.keymap.set({'n','v','o'}, ';', '<s-:>', opts.nops)

--- Faster split window navigation
vim.keymap.set({'n','v','o'}, '<c-h>', '<c-w><c-h>', opts.nrsil)
vim.keymap.set({'n','v','o'}, '<c-j>', '<c-w><c-j>', opts.nrsil)
vim.keymap.set({'n','v','o'}, '<c-k>', '<c-w><c-k>', opts.nrsil)
vim.keymap.set({'n','v','o'}, '<c-l>', '<c-w><c-l>', opts.nrsil)

--- Resize windows
vim.keymap.set('n', '<localleader>we',
  '<c-w>=', opts.nrsil) -- set all equal
vim.keymap.set('n', '<localleader>wvd',
  '1<c-w>-', opts.nrsil) -- decrease vertical by 1
vim.keymap.set('n', '<localleader>wvi',
  '1<c-w>+', opts.nrsil) -- increase vertical by 1
vim.keymap.set('n', '<localleader>whd',
  '1<c-w><', opts.nrsil) -- decrease horizontal by 1
vim.keymap.set('n', '<localleader>whi',
  '1<c-w>>', opts.nrsil) -- increase horizontal by 1

--- Split windows
vim.keymap.set('n', '<localleader>vs', ':vsplit<space>', opts.nr)
vim.keymap.set('n', '<localleader>sp', ':split<space>', opts.nr)

--- Quickfix list
vim.keymap.set('n', '<localleader>qn', ':cn<cr>zv', opts.sil)
vim.keymap.set('n', '<localleader>qp', ':cp<cr>zv', opts.sil)

-- vim.keymap.set('c', 'w!!', '%!sudo tee > /dev/null %', opts.sil)

--[[
-- Force use of hjkl-style movement and up(c-b)/down(c-f)
vim.keymap.set({'n','v','o','i'}, '<up>', '<nop>', opts.sil)
vim.keymap.set({'n','v','o','i'}, '<down>', '<nop>', opts.sil)
vim.keymap.set({'n','v','o','i'}, '<left>', '<nop>', opts.sil)
vim.keymap.set({'n','v','o','i'}, '<right>', '<nop>', opts.sil)
vim.keymap.set({'n','v','o','i'}, '<pageup>', '<nop>', opts.sil)
vim.keymap.set({'n','v','o','i'}, '<pagedown>', '<nop>', opts.sil)
vim.keymap.set({'n','v','o','i'}, '<home>', '<nop>', opts.sil)
vim.keymap.set({'n','v','o','i'}, '<end>', '<nop>', opts.sil)
--]]
