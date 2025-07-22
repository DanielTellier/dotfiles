local search = require('search')
local utils = require('utils')
local wk = require("which-key")

wk.add({
    { "<leader>d", group = "py-lang", mode = "n" }
})

-- Set options
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Define custom commands
vim.api.nvim_create_user_command(
  'Pydef',
  function(opts)
    search.search_pydef(opts.args, 'def')
  end,
  { nargs = '+' }
)
vim.api.nvim_create_user_command(
  'Pyclass',
  function(opts)
    search.search_pydef(opts.args, 'class')
  end,
  { nargs = '+' }
)

utils.map(
  'n',
  '<leader>df',
  function() search.search_pydef(vim.fn.expand('<cword>'), 'def') end,
  { desc = "Search Python function definition under cursor" }
)
utils.map(
  'n',
  '<leader>dc',
  function() search.search_pydef(vim.fn.expand('<cword>'), 'class') end,
  { desc = "Search Python class definition under cursor" }
)

-- Set compiler to python
vim.cmd('compiler python')
