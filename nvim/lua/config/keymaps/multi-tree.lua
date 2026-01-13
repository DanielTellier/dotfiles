local utils = require('utils')
local wk = require("which-key")

wk.add({
  { "<leader>z", group = "multi-tree", mode = "n" }
})

utils.map(
  "n", "<leader>zz", "<cmd>MultiTree<cr>",
  { desc = "Open multi-tree given cwd" }
)
utils.map(
  "n", "<leader>zt", "<cmd>tabnew | tabmove0 | MultiTree<cr>",
  { desc = "Open multi-tree given cwd at first tab" }
)
utils.map(
  "n", "<leader>zT", ":tabnew | tabmove0 | MultiTree ",
  { silent = false, desc = "Open multi-tree with a provided path at first tab" }
)
utils.map(
  "n", "<leader>ze", ":MultiTree ",
  { silent = false, desc = "Open multi-tree in the current window with a provided path" }
)
utils.map(
  "n", "<leader>zv", ":vs | MultiTree ",
  { silent = false, desc = "Open multi-tree in a vertical split with a provided path" }
)
utils.map(
  "n", "<leader>zo", ":sp | MultiTree ",
  { silent = false, desc = "Open multi-tree in a horizontal split with a provided path" }
)
