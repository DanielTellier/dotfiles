local utils = require('utils')
local wk = require("which-key")
local telescope = require("telescope")
local builtin = require('telescope.builtin')

wk.add({
  { "<leader>p", group = "telescope", mode = "n" }
})

utils.map('n', '<leader>pw', function()
  telescope.extensions.file_browser.file_browser()
end, { desc = "Open file_browser with the cwd" })
utils.map('n', '<leader>pp', function()
  telescope.extensions.file_browser.file_browser(
    { path = '%:p:h', select_buffer = true }
  )
end, { desc = "Open file_browser with the path of the current buffer" })
utils.map('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
utils.map('n', '<leader>pF', builtin.git_files, { desc = "Telescope git find files" })
utils.map('n', '<leader>po', builtin.oldfiles, { desc = "Telescope old files" })

utils.map('n', '<leader>pg', builtin.live_grep, { desc = "Telescope live grep" })
utils.map('n', '<leader>pG', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope grep" })
utils.map('n', '<leader>pe', "<cmd>Telescope egrepify<cr>", { desc = "Open egrepify" })
utils.map(
  'n',
  '<leader>ps',
  builtin.current_buffer_fuzzy_find,
  { desc = "Telescope current buffer fuzzy find" }
)

utils.map('n', '<leader>pv', "<cmd>Telescope env<cr>", { desc = "Telescope env" })

utils.map('n', '<leader>pb', builtin.buffers, { desc = "Telescope buffers" })
utils.map('n', '<leader>ph', builtin.help_tags, { desc = "Telescope help tags" })
utils.map('n', '<leader>pm', builtin.marks, { desc = "Telescope marks" })
utils.map('n', '<leader>pM', builtin.man_pages, { desc = "Telescope man pages" })
utils.map('n', '<leader>pk', builtin.keymaps, { desc = "Telescope keymaps" })

utils.map(
  'n',
  '<leader>pc',
  builtin.git_bcommits,
  { desc = "Telescope current buffer git commits" }
)
utils.map(
  'n',
  '<leader>pC',
  builtin.git_commits,
  { desc = "Telescope git commits" }
)

utils.map(
  'n', '<leader>pd', utils.select_dev_path_and_find_files,
  { desc = "Select development path and find files" }
)
