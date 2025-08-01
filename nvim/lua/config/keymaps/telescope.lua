local utils = require('utils')
local builtin = require('telescope.builtin')
local wk = require("which-key")

wk.add({
    { "<leader>p", group = "telescope", mode = "n" }
})

utils.map(
    "n", "<leader>po", "<cmd>Telescope file_browser<cr>",
    { desc = "Run Telescrope file browser mode" }
)
utils.map(
    "n", "<leader>pp", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
    { desc = "Open file_browser with the path of the current buffer" }
)
utils.map('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
utils.map('n', '<leader>pg', builtin.git_files, { desc = "Telescope git find files" })
utils.map('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ")})
end, { desc = "Telescope grep" })
