local search = require('search')
-- local utils = require('utils')
-- local wk = require("which-key")

-- wk.add({
--     { "<leader>d", group = "c-lang", mode = "n" }
-- })

-- Define the command
vim.api.nvim_create_user_command(
    'Cdef',
    function(opts)
        search.search_cdef(opts.args)
    end,
    { nargs = 1 }
)

-- NOTE: Replaced by lsp server
-- utils.map(
--     'n',
--     '<leader>df',
--     function() search.search_cdef(vim.fn.expand('<cword>')) end,
--     { desc = "Search C function definition under cursor" }
-- )

-- Set the compiler to gcc
vim.cmd('compiler gcc')
