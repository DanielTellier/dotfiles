local search = require('search')

-- Define the command
vim.api.nvim_create_user_command(
  'Cdef',
  function(opts)
    search.search_cdef(opts.args)
  end,
  { nargs = 1 }
)

-- Key mapping for C function definition under cursor
vim.api.nvim_set_keymap(
  'n',
  '<leader>df',
  ':Cdef ' .. vim.fn.expand('<cword>') .. ':cw<CR>',
  { noremap = true, silent = true }
)

-- Set the compiler to gcc
vim.cmd('compiler gcc')
