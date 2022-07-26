--- Functions
function map(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command,
  {noremap = true, silent = true})
end

function nsmap(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command,
  {noremap = true, silent = false})
end

function remap(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command,
  {noremap = false, silent = true})
end

function rensmap(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command,
  {noremap = false, silent = false})
end

--- Mappings
vim.g.mapleader = '\\'

-- init.lua
map('n', '<leader>ei', ':edit $VRC<cr>')
map('n', '<leader>sl', ':luafile $VRC<cr>')

-- Remove highlight
map('n', '<leader>nh', ':nohlsearch<cr>')

-- Buffers
map('n', '<leader>be', ':buffers<cr>:buffer<space>')
map('n', '<leader>bo', ':sp<cr>:buffers<cr>:buffer<space>')
map('n', '<leader>bv', ':vs<cr>:buffers<cr>:buffer<space>')
map('n', '<leader>bt', ':e#<cr>')

-- C defintion Mapping
nsmap('n', '<leader>cd', ':FindCDef <c-r><c-w><cr>:cw<cr>')

-- Search word under cursor
nsmap('n', '<leader>ws', ':Grep all <c-r><c-w><cr>:cw<cr> .')

-- Search word provided
nsmap('n', '<leader>gs', ':Grep<space>')

-- Sessions
nsmap('n', '<leader>mk', ':MkSession<cr>')
nsmap('n', '<leader>so', ':SoSession<cr>')

-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
map('v', 'y', 'myy`y')
map('v', 'Y', 'myY`y')

-- Paste replace visual selection without copying it
map('v', '<leader>p', '"_dP')

-- Make Y behave like the other capitals
map('n', 'Y', 'y$')

-- Keep it centered
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', 'J', 'mzJ`z')

-- Force use of hjkl-style movement and up(c-b)/down(c-f)
remap({'n','v','o','i'}, '<up>', '<nop>')
remap({'n','v','o','i'}, '<down>', '<nop>')
remap({'n','v','o','i'}, '<left>', '<nop>')
remap({'n','v','o','i'}, '<right>', '<nop>')
remap({'n','v','o','i'}, '<pageup>', '<nop>')
remap({'n','v','o','i'}, '<pagedown>', '<nop>')
remap({'n','v','o','i'}, '<home>', '<nop>')
remap({'n','v','o','i'}, '<end>', '<nop>')

-- Command line mode without <s-:>
rensmap({'n','v','o'}, ';', '<s-:>')

-- Faster split window navigation
map({'n','v','o'}, '<c-h>', '<c-w><c-h>')
map({'n','v','o'}, '<c-j>', '<c-w><c-j>')
map({'n','v','o'}, '<c-k>', '<c-w><c-k>')
map({'n','v','o'}, '<c-l>', '<c-w><c-l>')

-- Mappings for quickfix list
remap('n', '<c-n>', ':cn<cr>zv')
remap('n', '<c-p>', ':cp<cr>zv')

remap('c', 'w!!', '%!sudo tee > /dev/null %')

-- Moving between panes
map('n', '<a-k>', ':wincmd k<cr>')
map('n', '<a-j>', ':wincmd j<cr>')
map('n', '<a-h>', ':wincmd h<cr>')
map('n', '<a-l>', ':wincmd l<cr>')
map('n', '<leader>vs', ':vsplit<cr>')
map('n', '<leader>hs', ':split<cr>')

-- Exit terminal insert mode
map('t', 'jj', '<c-\\><c-n>') 

-- Toggle terminal
map("t", "<leader>tt", '<c-\\><c-n> :FloatermToggle <cr>')
map("n", "<leader>tt", ":FloatermToggle <cr>")

-- Switch terminals
map("t", "<leader>t[", '<c-\\><c-n> :FloatermPrev <cr>') 
map("t", "<leader>t]", '<C-\\><C-n> :FloatermNext <CR>')
map("n", "<leader>t[", ':FloatermPrev <CR>')
map("n", "<leader>t]", ':FloatermNext <CR>')

-- Open new terminal
map("n", "<leader>tn", ":FloatermNew <CR>")

-- Kill terminal
map("n", "<leader>td", ":FloatermKill <CR>")
