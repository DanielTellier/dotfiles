local utils = require('utils')
utils.map(
    "n", "<leader>gs", "<cmd>Git<cr>", { desc = "Open git status dashboard" }
)
