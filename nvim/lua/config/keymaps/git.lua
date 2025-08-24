-- Using plugins: "sindrets/diffview.nvim" and "tpope/vim-fugitive"
local utils = require('utils')
local wk = require("which-key")

wk.add({
    { "<leader>g", group = "git", mode = "n" }
})

utils.map(
    "n", "<leader>gg", "<cmd>Git<cr>", { desc = "Open git status dashboard" }
)
utils.map(
    "n", "<leader>gs", "<cmd>Git status<cr>", { desc = "Git status" }
)
utils.map(
    "n", "<leader>gl", "<cmd>Git log<cr>", { desc = "Git log" }
)
utils.map(
    "n", "<leader>gd", "<cmd>Git diff<cr>", { desc = "Git diff" }
)
utils.map(
    "n", "<leader>ga", "<cmd>Git add ", { silent = false, desc = "Git add" }
)
utils.map(
    "n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" }
)
utils.map(
    "n", "<leader>gu", "<cmd>Git pull<cr>", { desc = "Git pull" }
)
utils.map(
    "n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" }
)

utils.map(
    "n", "<leader>go", "<cmd>DiffviewOpen<cr>", { desc = "Open git diff view plugin" }
)
utils.map(
    "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close git diff view plugin"}
)
