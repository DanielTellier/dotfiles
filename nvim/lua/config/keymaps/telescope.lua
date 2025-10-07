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
utils.map('n', '<leader>pw', function()
    require("telescope").extensions.file_browser.file_browser()
end, { desc = "Open file_browser with the cwd" })
utils.map('n', '<leader>pp', function()
    require("telescope").extensions.file_browser.file_browser(
        { path = '%:p:h', select_buffer = true }
    )
end, { desc = "Open file_browser with the path of the current buffer" })
utils.map('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
utils.map('n', '<leader>pg', builtin.git_files, { desc = "Telescope git find files" })
utils.map('n', '<leader>pl', builtin.live_grep, { desc = "Telescope live grep" })
utils.map('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope grep" })
utils.map('n', '<leader>pb', builtin.buffers, { desc = "Telescope buffers" })
utils.map('n', '<leader>ph', builtin.help_tags, { desc = "Telescope help tags" })
utils.map('n', '<leader>pm', builtin.marks, { desc = "Telescope marks" })
utils.map(
    'n', '<leader>pd', utils.select_dev_path_and_find_files,
    { desc = "Select development path and find files" }
)
