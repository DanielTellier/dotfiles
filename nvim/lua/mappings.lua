local utils = require('utils')
local rtp = vim.split(vim.o.runtimepath, ",")[1]
local vrc = rtp .. '/init.lua'
local sesh_dir = "~/.vim-sessions"
local home = os.getenv('HOME')

-- Key mappings
vim.g.mapleader = ' '

-- Quit vim
utils.map('n', '<leader>qq', ':qa<cr>')

-- Close window
utils.map('n', '<leader>qc', ':q<cr>')

-- Closes all open folds
utils.map('n', 'zC', 'zM', { silent = false })

-- Open Explore
utils.map('n', '<leader>xe', ':e .<cr>')
utils.map('n', '<leader>xv', ':vs<space>', { silent = false })

-- Open docs
utils.mapfunc('n', '<leader>ed', function() utils.open_path(rtp .. '/doc/common-maps.txt') end)

-- Open key mappings
utils.map('n', '<leader>k', ':tabnew ~/.config/nvim/lua/mappings.lua<cr>')

-- Open vimrc
utils.mapfunc('n', '<leader>ev', function() utils.open_path(vrc) end)

-- Open my after file type if exists
utils.mapfunc('n', '<leader>ea', function() utils.open_after_ft() end)

-- Open bashrc
utils.mapfunc('n', '<leader>eb', function() utils.open_path(home .. '/.bashrc') end)

-- Toggle highlights
utils.mapfunc('n', '<leader>th', function() utils.toggle_highlights() end)
utils.map('n', '/', ':set hlsearch<cr>/', { silent = false})

-- Toggle listchars and numbers
utils.mapfunc('n', '<leader>ta', function() utils.toggle_all() end)

-- Toggle listchars
utils.map('n', '<leader>tl', ':if (&list) | set nolist | else | set list | endif<cr>')

-- Toggle numbers
utils.mapfunc('n', '<leader>tn', function() utils.toggle_numbers() end)

-- Global substitution
utils.map('n', '<leader>sg', ':%s/<c-r><c-w>//g' .. string.rep('<left>', 2), { silent = false })
utils.map('v', '<leader>sg', '"zy:%s/<c-r>z//g' .. string.rep('<left>', 2), { silent = false })
utils.map('n', '<leader>sc', ':%s/<c-r><c-w>//gc' .. string.rep('<left>', 3), { silent = false })
utils.map('v', '<leader>sc', '"zy:%s/<c-r>z//gc' .. string.rep('<left>', 3), { silent = false })
utils.map('n', '<leader>ag', ':%s/\\(<c-r><c-w>\\)/\\1/g' .. string.rep('<left>', 4), { silent = false })
utils.map('v', '<leader>ag', '"zy:%s/\\(<c-r>z\\)/\\1/g' .. string.rep('<left>', 4), { silent = false })
utils.map('n', '<leader>ac', ':%s/\\(<c-r><c-w>\\)/\\1/gc' .. string.rep('<left>', 5), { silent = false })
utils.map('v', '<leader>ac', '"zy:%s/\\(<c-r>z\\)/\\1/gc' .. string.rep('<left>', 5), { silent = false })

-- Global Buffers Replace
-- :bufdo %s/pancake/waffle/g | update
-- Global Args Replace
-- :argdo %s/method_a/method_b/g | update

-- Count instances in line or globally
utils.map('n', '<leader>cl', ':s///gn' .. string.rep('<left>', 4), { silent = false })
utils.map('n', '<leader>cg', ':%s///gn' .. string.rep('<left>', 4), { silent = false })

-- Search word under cursor
utils.map('n', '<leader>ws', ':Grep all "\\b<c-r><c-w>\\b"<cr>:cw<cr>')

-- Search word user input
utils.map('n', '<leader>is', ':Grep all ')

-- Search exact match
utils.map('n', '<leader>em', '/\\<<c-r><c-w>\\>', { silent = false })

-- Paste last thing yanked, not deleted
utils.map('n', ',p', '"0p', { noremap = false, silent = false })
utils.map('n', ',P', '"0P', { noremap = false, silent = false })

-- Yank to system clipboard if using the default OSC 52 clipboard
local yanks = {'yy', 'yw', 'y^', 'y$', 'yiw', 'yaw'}
for _, key in ipairs(yanks) do
    if os.getenv("SSH_TTY") then
        utils.map('n', "<leader>" .. key, '"+' .. key, { silent = false })
    end
end
if os.getenv("SSH_TTY") then
    utils.map('v', '<leader>y', '"+y', { silent = false })
end

-- Git commands
utils.map('n', '<leader>gs', ':Git status<cr>')
utils.map('n', '<leader>gl', ':Git log<cr>')
utils.map('n', '<leader>gd', ':Git diff<cr>')
utils.map('n', '<leader>ga', ':Git add --all<cr>')
utils.map('n', '<leader>gc', ':Git commit ', { silent = false })
utils.map('n', '<leader>gu', ':Git pull<cr>')
utils.map('n', '<leader>gp', ':Git push<cr>')

-- Terminal access
utils.map('n', '<leader>me', ':terminal<cr>')
utils.map('n', '<leader>mv', ':vertical terminal<cr>')
utils.map('n', '<leader>mo', ':split | terminal<cr>')
utils.map('n', '<leader>mt', ':tab terminal<cr>')

-- Terminal modes
utils.map('t', '<esc>', '<c-\\><c-n>', { silent = false })
utils.map('t', '<c-h>', '<c-w><c-h>', { silent = false })
utils.map('t', '<c-j>', '<c-w><c-j>', { silent = false })
utils.map('t', '<c-k>', '<c-w><c-k>', { silent = false })
utils.map('t', '<c-l>', '<c-w><c-l>', { silent = false })
utils.mapfunc('t', '<c-w>p', function() utils.paste_to_terminal() end)


-- Surround mappings
utils.surround_mappings("word")
utils.surround_mappings("line")
utils.surround_mappings("change")
utils.surround_mappings("delete")
utils.surround_mappings("visual")

-- Move cursor in front of closing pair symbol
-- Referenced from here: https://github.com/jiangmiao/auto-pairs/blob/master/plugin/auto-pairs.vim#L576
utils.mapbuf('i', '<c-p>', [=[<esc>:call search('["\]'')}]','W')<cr>a]=])

-- Compiler make
utils.map('n', '<leader>cm', ':make % <bar> redraw!<cr><cr>')

-- Make Y behave like other capitals
utils.map('n', 'Y', 'y$', { silent = false })

-- Keep it centered
utils.map('n', 'n', 'nzzzv', { silent = false })
utils.map('n', 'N', 'Nzzzv', { silent = false })
utils.map('n', 'J', 'mzJ`z', { silent = false })

-- Command line mode without shift+;
utils.map('n', ';', ':', { silent = false })
utils.map('v', ';', ':', { silent = false })

-- Faster split window navigation
utils.map('n', '<c-h>', '<c-w>h', { silent = false })
utils.map('n', '<c-j>', '<c-w>j', { silent = false })
utils.map('n', '<c-k>', '<c-w>k', { silent = false })
utils.map('n', '<c-l>', '<c-w>l', { silent = false })

-- Move window
utils.map('n', '<leader>wu', '<c-w>R')
utils.map('n', '<leader>wd', '<c-w>r')
utils.map('n', '<leader>wh', '<c-w>H')
utils.map('n', '<leader>wj', '<c-w>J')
utils.map('n', '<leader>wk', '<c-w>K')
utils.map('n', '<leader>wl', '<c-w>L')
utils.map('n', '<leader>wt', '<c-w>T')
utils.map('n', '<leader>wc', ':exe "tabnew " .. expand("%")<cr>')
utils.map('n', '<leader>wp', ':exe "vs " .. expand("#")<cr>')

-- Force use of hjkl-style movement and up(c-b)/down(c-f)
local keys_to_nop = { '<up>', '<down>', '<left>', '<right>', '<pageup>', '<pagedown>', '<home>', '<end>' }
for _, key in ipairs(keys_to_nop) do
    utils.map('', key, '<nop>', { noremap = false, silent = false })
    utils.map('i', key, '<nop>', { noremap = false, silent = false })
end

-- Remap these keys to work with hjkl-style movement
utils.map('', '$', '<nop>', { noremap = false, silent = false })
utils.map('', '^', '<nop>', { noremap = false, silent = false })
utils.map('', '{', '<nop>', { noremap = false, silent = false })
utils.map('', '}', '<nop>', { noremap = false, silent = false })
utils.map('', 'K', '{', { silent = false })
utils.map('', 'J', '}', { silent = false })
utils.map('', 'H', '^', { silent = false })
utils.map('', 'L', '$', { silent = false })

-- Tabbing
utils.map('n', '<tab>', '>><esc>', { silent = false })
utils.map('n', '<s-tab>', '<<<esc>', { silent = false })
utils.map('v', '<tab>', '>><esc>', { silent = false })
utils.map('v', '<s-tab>', '<<<esc>', { silent = false })

-- Change file indent size
utils.mapfunc('n', '<leader>24i', function() utils.change_file_indent_size(2, 4) end)
utils.mapfunc('n', '<leader>42i', function() utils.change_file_indent_size(4, 2) end)

-- Yank file name
utils.map('n', '<leader>fy', ':let @f = expand("%:t")<cr>')
utils.map('n', '<leader>Fy', ':let @f = expand("%:p")<cr>')
-- Paste file name
utils.map('n', '<leader>fp', '"fp')

-- Buffer commands
-- SearchBuffers defined in commands.lua
utils.map('n', '<leader>sb', ':SearchBuffers ', { silent = false })
utils.map('n', '<leader>bl', ':buffers<cr>', { silent = false })
utils.map('n', '<leader>bb', ':buffer ', { silent = false })
utils.map('n', '<leader>bs', ':sbuffer ', { silent = false })
utils.map('n', '<leader>bv', ':vertical sbuffer ', { silent = false })

-- Remove buffers
-- RemoveWhichBuffer defined in commands.lua
utils.map('n', '<leader>rb', ':RemoveWhichBuffer ', { silent = false })
utils.mapfunc('n', '<leader>rB', function() utils.remove_all_buffers() end, { silent = false })
utils.map('n', '<leader>rm', ':delm! ', { silent = false })
utils.mapfunc('n', '<leader>rM', function() utils.remove_all_global_marks() end, { silent = false })

-- Quickfix List
utils.map('n', '<leader>co', ':copen<cr>')
utils.map('n', '<leader>cq', ':cclose<cr>')

-- Sessions
-- We used backspaces (<bs>) to remove the "*.vim" suffix after filtering files,
-- allowing us to type a new filename post-remap.
utils.map('n', '<leader>ms', ':Obsession ' .. sesh_dir .. '/*.vim<c-d>' .. string.rep('<bs>', 5), { silent = false })
utils.map('n', '<leader>ss', ':source ' .. sesh_dir .. '/*.vim<c-d>' .. string.rep('<bs>', 5), { silent = false })
utils.map('n', '<leader>os', ':Obsession<cr>', { silent = false })

-- Copilot
utils.map("i", "<c-j>", 'copilot#Accept("<cr>")', { expr = true, replace_keycodes= false, script = true })

-- Allow saving of files as sudo when I forgot to start vim using sudo
vim.cmd('cmap w!! w !sudo tee > /dev/null %')
vim.cmd('cmap <c-p> <c-r>*')
