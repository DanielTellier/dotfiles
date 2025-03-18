local utils = require('utils')
local builtin = require('telescope.builtin')
utils.mapfunc('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
utils.mapfunc('n', '<leader>gf', builtin.git_files, { desc = "Telescope git find files" })
utils.mapfunc('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ")})
end, { desc = "Telescope grep" })

