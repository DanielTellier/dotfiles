local utils = require('utils')
utils.map(
    "n", "<leader>po", "<cmd>Telescope file_browser<cr>",
    { desc = "Run Telescrope file browser mode" }
)
utils.map(
    "n", "<leader>pp", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
    { desc = "Open file_browser with the path of the current buffer" }
)
