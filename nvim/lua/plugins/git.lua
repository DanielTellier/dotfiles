return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<leader>g", "", desc = "+git" },
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit" },
    { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull" },
    { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
    { "<leader>gB", "<cmd>Neogit branch<cr>", desc = "Branch manager" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open git diff view plugin" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close git diff view plugin" },
  },
  opts = {
    kind = "split_above",
    disable_insert_on_commit = true,
    integrations = { telescope = true, diffview = true },
  },
}
