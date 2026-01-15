local utils = require('utils')
local search = require('search')
local wk = require("which-key")
local rtp = vim.split(vim.o.runtimepath, ",")[1]
local home = os.getenv('HOME')

wk.add({
  { "<leader>d", group = "delete", mode = "n" }
})
wk.add({
  { "<leader>e", group = "edit", mode = "n" }
})
wk.add({
  { "<leader>f", group = "find", mode = "n" }
})
wk.add({
  { "<leader>m", group = "terminal", mode = "n" }
})
wk.add({
  { "<leader>q", group = "close", mode = "n" }
})
wk.add({
  { "<leader>r", group = "replace", mode = { "n", "v" } }
})
wk.add({
  { "<leader>s", group = "session", mode = "n" }
})
wk.add({
  { "<leader>u", group = "surround", mode = { "n", "v" } }
})
wk.add({
  { "<leader>t", group = "toggle", mode = "n" }
})
wk.add({
  { "<leader>w", group = "window", mode = "n" }
})
wk.add({
  { "<leader>y", group = "yank", mode = { "n", "v" } }
})

-- Navigation
utils.map(
  'n', 'n', 'nzzzv',
  { silent = false, desc = "Keep it centered when searching for next" }
)
utils.map(
  'n', 'N', 'Nzzzv',
  { silent = false, desc = "Keep it centered when searching for previous" }
)
utils.map(
  'n', 'J', 'mzJ`z',
  { silent = false, desc = "Join lines and keep cursor position" }
)
utils.map(
  'n', '<c-d>', '<c-d>zz',
  { silent = false, desc = "Go down half a page and center." }
)
utils.map(
  'n', '<c-u>', '<c-u>zz',
  { silent = false, desc = "Go up half a page and center." }
)
utils.map(
  'n', '<c-f>', '<c-f>zz',
  { silent = false, desc = "Go down a page and center." }
)
utils.map(
  'n', '<c-b>', '<c-b>zz',
  { silent = false, desc = "Go up a page and center." }
)
utils.map(
  "n", "<leader>oo", "o<esc>o<esc>o<esc>k",
  { desc = "Create a new line with 2 spaces around it" }
)
-- Referenced from here: https://github.com/jiangmiao/auto-pairs/blob/master/plugin/auto-pairs.vim#L576
-- <buffer> (utils.mapbuf in my case) is not working for neovim so cannot do:
-- vim.g.AutoPairsShortcutJump = "<c-p>"
utils.map(
  { 'i', 'n' }, '<c-p>', [=[<esc>:call search('["\]'')}]','W')<cr>a]=],
  { desc = "Move cursor after closing pair symbol" }
)
utils.map('n', 'Y', 'y$', { silent = false, desc = "Yank to end of line" })
-- Force use of hjkl-style movement and up(c-b)/down(c-f)
local keys_to_nop = {
  '<up>', '<down>', '<left>', '<right>', '<pageup>', '<pagedown>', '<home>', '<end>'
}
for _, key in ipairs(keys_to_nop) do
  utils.map('', key, '<nop>', { noremap = false, silent = false })
  utils.map('i', key, '<nop>', { noremap = false, silent = false })
end
-- Remap these keys to work with hjkl-style movement
utils.map('', '$', '<nop>', { noremap = false, silent = false })
utils.map('', '^', '<nop>', { noremap = false, silent = false })
utils.map('', '{', '<nop>', { noremap = false, silent = false })
utils.map('', '}', '<nop>', { noremap = false, silent = false })
utils.map('', 'K', '{', { silent = false, desc = "Move up a paragraph" })
utils.map('', 'J', '}', { silent = false, desc = "Move down a paragraph" })
utils.map('', 'H', '^', { silent = false, desc = "Move to start of line" })
utils.map('', 'L', '$', { silent = false, desc = "Move to end of line" })

-- Edit
utils.map('n', '<leader>ed', function()
  utils.open_path(rtp .. '/doc/mydocs.txt')
end, { desc = "Open my docs" })
utils.map('n', '<leader>ev', function()
  utils.open_path(rtp .. '/init.lua')
end, { desc = "Open init.lua" })
utils.map('n', '<leader>ea', function()
  utils.open_after_ft()
end, { desc = "Open custom after file type if exists" })
utils.map('n', '<leader>er', function()
  utils.open_path(home .. '/.bashrc')
end, { desc = "Open bashrc" })
utils.map('n', '<leader>ef', ':copen<cr>', { desc = "Open quickfix list" })
utils.map('n', '<leader>qf', ':cclose<cr>', { desc = "Close quickfix list" })
utils.map(
  'n', '<leader>et', ':exe "tabnew " .. expand("%")<cr>',
  { desc = "Open current buffer in a new tab" }
)
utils.map(
  'n', '<leader>ep', ':exe "vs " .. expand("#")<cr>',
  { desc = "Open previous window to vertical split" }
)
vim.api.nvim_create_user_command(
  'BufAddDir',
  function(opts)
    local args = vim.split(opts.args, '%s+')
    if #args < 2 then
      vim.notify("Usage: :BufAddDir <file_pattern> <directory>", vim.log.levels.ERROR)
      return
    end
    local pattern = args[1]
    local dir = args[2]
    utils.buf_add_dir(pattern, dir)
  end,
  {
    nargs = '+',
    complete = 'dir',
    desc = 'Add certain files under a directory to the buffer list'
  }
)
utils.map(
  'n', '<leader>eb', ':BufAddDir ',
  { silent = false, desc = 'Add certain files under a directory to the buffer list' }
)

-- Toggle
utils.map('n', '<leader>th', function()
  utils.toggle_highlights()
end, { desc = "Toggle highlights" })
utils.map(
  'n', '/', ':set hlsearch<cr>/',
  { silent = false, desc = "Ensure highlighting is on when searching" }
)
utils.map('n', '<leader>tn', function()
  utils.toggle_numbers()
end, { desc = "Toggle numbers" })
utils.map(
  'n', '<leader>tl', ':if (&list) | set nolist | else | set list | endif<cr>',
  { desc = "Toggle listchars" }
)
utils.map('n', '<leader>ta', function()
  utils.toggle_all()
end, { desc = "Toggle listchars and numbers" })
utils.map(
  "n", "<leader>tw", "<cmd>set wrap!<CR>",
  { desc = "Toggle line wrap" }
)

-- Replace
utils.map(
  { 'n', 'v' }, '<leader>rg', ':%s///g' .. string.rep('<left>', 3),
  { silent = false, desc = "Global replace" }
)
utils.map(
  { 'n', 'v' }, '<leader>rc', ':%s///gc' .. string.rep('<left>', 4),
  { silent = false, desc = "Global replace with confirmation" }
)
utils.map(
  { 'n', 'v' }, '<leader>rw', ':%s/<c-r><c-w>//g' .. string.rep('<left>', 2),
  { silent = false, desc = "Global replace with word under cursor" }
)
utils.map(
  { 'n', 'v' }, '<leader>rW', ':%s/<c-r><c-w>//gc' .. string.rep('<left>', 3),
  {
    silent = false,
    desc = "Global replace with word under cursor and confirmation",
  }
)
utils.map(
  { 'n', 'v' }, '<leader>rr', ':%s/\\(<c-r><c-w>\\)/\\1/g' .. string.rep('<left>', 4),
  { silent = false, desc = "Global prefix with word under cursor" }
)
utils.map(
  { 'n', 'v' }, '<leader>rR', ':%s/\\(<c-r><c-w>\\)/\\1/gc' .. string.rep('<left>', 5),
  {
    silent = false,
    desc = "Global prefix with word under cursor and confirmation",
  }
)
utils.map(
  { 'n', 'v' }, '<leader>ro', ':%s/\\(<c-r><c-w>\\)/\\1/g' .. string.rep('<left>', 3),
  { silent = false, desc = "Global postfix with word under cursor" }
)
utils.map(
  { 'n', 'v' }, '<leader>rO', ':%s/\\(<c-r><c-w>\\)/\\1/gc' .. string.rep('<left>', 4),
  {
    silent = false,
    desc = "Global postfix with word under cursor and confirmation",
  }
)
utils.map(
  { 'n', 'v' }, '<leader>rb',
  ':bufdo %s/<c-r><c-w>//g | update' .. string.rep('<left>', 11),
  {
    silent = false,
    desc = "Global replace across buffers with word under cursor",
  }
)
-- Can add files to arg list via `:args *.txt` or `:args file1.txt file2.txt ...`
utils.map(
  { 'n', 'v' }, '<leader>ra',
  ':argdo %s/<c-r><c-w>//g | update' .. string.rep('<left>', 11),
  {
    silent = false,
    desc = "Global replace across file in argument " ..
    "list with word under cursor",
  }
)
utils.map(
  'n', '<leader>rs', ':%s/\\s\\+$//g<cr>',
  { desc = "Remove trailing spaces" }
)
utils.map(
  'n', '<leader>r2', function()
    utils.transform_indent_buffer(4, 2)
  end,
  { desc = "Change file indent size from 4 to 2" }
)
utils.map(
  'n', '<leader>r4', function()
    utils.transform_indent_buffer(2, 4)
  end,
  { desc = "Change file indent size from 2 to 4" }
)
-- Create user commands for recursive indent transformation
vim.api.nvim_create_user_command('IndentTo2', function(opts)
  local args = vim.split(opts.args, '%s+')
  if #args < 2 then
    vim.notify("Usage: :IndentTo2 <directory> <file_pattern>", vim.log.levels.ERROR)
    return
  end
  utils.transform_indent_files(args[1], args[2], 4, 2)
end, {
  nargs = '+',
  desc = 'Convert 4-space indent to 2-space for files matching pattern in directory (recursive)',
  complete = 'file'
})
utils.map(
  'n', '<leader>r@',
  ':IndentTo2 ',
  {
    silent = false,
    desc = 'Convert 4-space indent to 2-space for files matching pattern in directory (recursive)'
  }
)
vim.api.nvim_create_user_command('IndentTo4', function(opts)
  local args = vim.split(opts.args, '%s+')
  if #args < 2 then
    vim.notify("Usage: :IndentTo4 <directory> <file_pattern>", vim.log.levels.ERROR)
    return
  end
  utils.transform_indent_files(args[1], args[2], 2, 4)
end, {
  nargs = '+',
  desc = 'Convert 2-space indent to 4-space for files matching pattern in directory (recursive)',
  complete = 'file'
})
utils.map(
  'n', '<leader>r$',
  ':IndentTo4 ',
  {
    silent = false,
    desc = 'Convert 2-space indent to 4-space for files matching pattern in directory (recursive)'
  }
)

-- Find
vim.api.nvim_create_user_command('Mgrep', function(args)
  print(vim.inspect(args.fargs))
  search.search_grep(unpack(args.fargs))
end, { nargs = '+' })
utils.map(
  'n', '<leader>fl', ':s///gn' .. string.rep('<left>', 4),
  { silent = false, desc = "Count instances in the current line" }
)
utils.map(
  'n', '<leader>fg', ':%s///gn' .. string.rep('<left>', 4),
  { silent = false, desc = "Count instances globally" }
)
utils.map(
  'n', '<leader>fw', ':Mgrep all "\\b<c-r><c-w>\\b"<cr>:cw<cr>',
  { desc = "Search word under cursor in current directory" }
)
utils.map(
  'n', '<leader>fi', ':Mgrep all ',
  { silent = false, desc = "Search word given input in current directory" }
)
utils.map(
  'n', '<leader>fm', '/\\<<c-r><c-w>\\>',
  { silent = false, desc = "Search exact match in current buffer" }
)

-- Terminal
utils.map('n', '<leader>me', ':terminal<cr>', { desc = "Open terminal" })
utils.map(
  'n', '<leader>mv', ':vertical terminal<cr>', { desc = "Open vertical terminal" }
)
utils.map(
  'n', '<leader>mo', ':split | terminal<cr>', { desc = "Open horizontal terminal" }
)
utils.map(
  'n', '<leader>mt', ':tab terminal<cr>', { desc = "Open terminal in new tab" }
)
utils.map('n', '<leader>tt', function()
  utils.toggle_terminal()
end, { desc = "Toggle the last terminal buffer" })
utils.map('t', '<esc>', '<c-\\><c-n>', { silent = false, desc = "Exit terminal mode" })
utils.map('t', '<c-w>p', function()
  utils.paste_to_terminal()
end, { desc = "Paste yanked text into terminal" })
utils.map('n', '<leader>mq', '<cmd>q!<cr>', { desc = "Exit terminal" })
utils.map('n', '<leader>mz', "<c-[>", { desc = "Exit insert mode in inner terminal" })

-- Surround
utils.surround_mappings("word")
utils.surround_mappings("line")
utils.surround_mappings("change")
utils.surround_mappings("delete")
utils.surround_mappings("visual")

-- Window
utils.map('n', '<c-h>', '<c-w>h', { silent = false, desc = "Move to left window" })
utils.map('n', '<c-j>', '<c-w>j', { silent = false, desc = "Move to bottom window" })
utils.map('n', '<c-k>', '<c-w>k', { silent = false, desc = "Move to top window" })
utils.map('n', '<c-l>', '<c-w>l', { silent = false, desc = "Move to right window" })
utils.map('t', '<c-h>', '<c-\\><c-n><c-w>h', { silent = false, desc = "Move to left window" })
utils.map('t', '<c-j>', '<c-\\><c-n><c-w>j', { silent = false, desc = "Move to bottom window" })
utils.map('t', '<c-k>', '<c-\\><c-n><c-w>k', { silent = false, desc = "Move to top window" })
utils.map('t', '<c-l>', '<c-\\><c-n><c-w>l', { silent = false, desc = "Move to right window" })
utils.map('n', '<leader>wu', '<c-w>R', { desc = "Rotate window upwards or leftwards" })
utils.map(
  'n', '<leader>wd', '<c-w>r', { desc = "Rotate window downwards or rightwords" }
)
utils.map('n', '<leader>wh', '<c-w>H', { desc = "Move window to left" })
utils.map('n', '<leader>wj', '<c-w>J', { desc = "Move window to bottom" })
utils.map('n', '<leader>wk', '<c-w>K', { desc = "Move window to top" })
utils.map('n', '<leader>wl', '<c-w>L', { desc = "Move window to right" })
utils.map('n', '<leader>wt', '<c-w>T', { desc = "Move window to new tab" })
utils.map(
  'n',
  '<leader>wo',
  function()
    utils.move_to_tab({ direction = 'next', split = 'horizontal' })
  end, { desc = 'Move buffer to Next tab h[o]rizontally' }
)
utils.map(
  'n',
  '<leader>wv',
  function()
    utils.move_to_tab({ direction = 'next', split = 'vertical' })
  end, { desc = 'Move buffer to Next tab [v]ertically' }
)
utils.map(
  'n',
  '<leader>wO',
  function()
    utils.move_to_tab({ direction = 'prev', split = 'horizontal' })
  end, { desc = 'Move buffer to Previous tab h[O]rizontally' }
)
utils.map(
  'n',
  '<leader>wV',
  function()
    utils.move_to_tab({ direction = 'prev', split = 'vertical' })
  end, { desc = 'Move buffer to Previous tab [V]ertically' }
)
for i = 1, 9 do
  utils.map('n', string.format('<leader>w%d', i), function()
    utils.move_to_tab({ tab_number = i, split = 'horizontal' })
  end, { desc = string.format('Move buffer to tab %d', i) })
end
utils.map(
  "n",
  "<leader>wz",
  "<c-w>=z12<cr>",
  { desc = "Sets window size = ideal size for 2 buffers and 2 terms" }
)
utils.map(
  "n",
  "<leader>w=",
  "<cmd>vertical resize +5<cr>",
  { desc = "Increase window size vertically" }
)
utils.map(
  "n",
  "<leader>w-",
  "<cmd>vertical resize -5<cr>",
  { desc = "Decrease window size vertically" }
)

-- Path Info
utils.map(
  'n', '<leader>yf', ':let @f = expand("%:t")<cr>', { desc = "Yank file name" }
)
utils.map(
  'n', '<leader>yF', ':let @f = expand("%:p")<cr>', { desc = "Yank full file path" }
)
utils.map('n', '<leader>yp', '"fp', { desc = "Paste file name" })

-- Delete
utils.map(
  'n', '<leader>dm', ':delmarks ', { silent = false, desc = "Delete mark from list" }
)
utils.map('n', '<leader>dM', function()
  utils.delete_all_global_marks()
end, { silent = false, desc = "Delete all global marks" })
utils.map('n', '<leader>db', function()
  utils.delete_all_buffers()
end, { silent = false, desc = "Delete all buffers from list" })

-- Sessions
vim.api.nvim_create_user_command(
  'MakeSession',
  function(opts)
    local name = opts.args
    if not name:match("%.vim$") then
      name = name .. ".vim"
    end
    local session_path = vim.g.session_dir .. "/" .. name
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
    print("Session saved as: " .. name)
  end,
  {
    desc = "Make a session defined by the user",
    nargs = 1,
    complete = function(arg_lead, cmd_line, cursor_pos)
      local files = vim.fn.glob(vim.g.session_dir .. '/' .. arg_lead .. '*', false, true)
      local results = {}
      for _, file in ipairs(files) do
        table.insert(results, vim.fn.fnamemodify(file, ':t'))
      end
      return results
    end
  }
)
utils.map(
  'n',
  '<leader>sm',
  ':MakeSession ',
  { silent = false, desc = "Make a session defined by the user" }
)
vim.api.nvim_create_user_command(
  'LoadSession',
  function(opts)
    local name = opts.args
    if not name:match("%.vim$") then
      name = name .. ".vim"
    end
    local session_path = vim.g.session_dir .. "/" .. name
    if vim.fn.filereadable(session_path) == 0 then
      print("Session file not found: " .. name)
      return
    end
    vim.cmd("source " .. vim.fn.fnameescape(session_path))
    print("Session loaded: " .. name)
  end,
  {
    desc = "Load a session specified by the user",
    nargs = 1,
    complete = function(arg_lead, cmd_line, cursor_pos)
      local files = vim.fn.glob(vim.g.session_dir .. '/' .. arg_lead .. '*', false, true)
      local results = {}
      for _, file in ipairs(files) do
        table.insert(results, vim.fn.fnamemodify(file, ':t'))
      end
      return results
    end
  }
)
utils.map(
  'n',
  '<leader>sl',
  ':LoadSession ',
  { silent=false, desc = "Load a session specified by the user" }
)

-- Misc
utils.map('n', '<leader>qw', ':q<cr>', { desc = "Close current window"})
utils.map('n', '<leader>x', ':qa<cr>', { desc = "Quit neovim" })
utils.map({'n', 'v'}, '<tab>', '>><esc>', { silent = false, desc = "Indent right" })
utils.map({'n', 'v'}, '<s-tab>', '<<<esc>', { silent = false, desc = "Indent left" })
utils.map(
  'i', '<s-tab>', '<esc><<', { silent = false, desc = "Indent left in insert mode" }
)
vim.cmd('cmap w!! w !sudo tee > /dev/null %', { desc = "Save file as sudo" })
vim.cmd('cmap <c-p> <c-r>*', { desc = "Paste from system clipboard in command mode" })
utils.map({ "n", "v" }, ';', ':', { silent = false, desc = "Command line mode" })
utils.map(
  'n', ',p', '"0p', { noremap = false, silent = false, desc = "Paste last yanked" }
)
utils.map(
  'n', ',P', '"0P',
  {
    noremap = false,
    silent = false,
    desc = "Paste last yanked before cursor position",
  }
)
if os.getenv("SSH_TTY") then
  local yanks = {'yy', 'yw', 'y^', 'y$', 'yi', 'ya'}
  for _, key in ipairs(yanks) do
    utils.map(
      'n', "<leader>" .. key, '"+' .. key,
      {
        silent = false,
        desc = "Yank to system clipboard if using the default " ..
        "OSC 52 clipboard for Neovim"
      }
    )
  end
  utils.map(
    'v', '<leader>yy', '"+y',
    {
      silent = false,
      desc = "Yank to system clipboard in Visual mode " ..
      "if using the default OSC 52 clipboard for Neovim"
    }
  )
end
utils.map({ 'i', 'x', 'n', 's' }, "<c-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
