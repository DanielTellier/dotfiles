local utils = require('utils')
local builtin = require('telescope.builtin')
utils.map('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
utils.map('n', '<leader>gf', builtin.git_files, { desc = "Telescope git find files" })
utils.map('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ")})
end, { desc = "Telescope grep" })

