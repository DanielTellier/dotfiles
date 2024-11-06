local search = require('search')

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

-- Python function definition mapping under cursor
vim.api.nvim_set_keymap('n', '<leader>df', ':Pydef <c-r><c-w><cr>:cw<cr>', { noremap = true, silent = true })

-- Python class definition mapping under cursor
vim.api.nvim_set_keymap('n', '<leader>dc', ':Pyclass <c-r><c-w><cr>:cw<cr>', { noremap = true, silent = true })

-- Set compiler to python
vim.cmd('compiler python')
