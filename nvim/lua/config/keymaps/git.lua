-- Using plugins: "sindrets/diffview.nvim" and "tpope/vim-fugitive"
local utils = require('utils')
local wk = require("which-key")

wk.add({
    { "<leader>g", group = "g" }
})

utils.map(
    "n", "<leader>go", "<cmd>DiffviewOpen<cr>", { desc = "Open git diff view plugin" }
)
utils.map(
    "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close git diff view plugin"}
)
