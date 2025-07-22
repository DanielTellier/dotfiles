local utils = require('utils')
local wk = require("which-key")

wk.add({
    { "<leader>g", group = "fugitive", mode = "n" }
})

utils.map(
    "n", "<leader>gs", "<cmd>Git<cr>", { desc = "Open git status dashboard" }
)
