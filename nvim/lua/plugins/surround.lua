return {
  "echasnovski/mini.surround",
  recommended = true,
  version = false,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    mappings = {
      add = "", -- Add surrounding in Normal and Visual modes (see below)
      delete = "ds", -- Delete surrounding
      find = "", -- Find surrounding
      find_left = "", -- Find surrounding to the left
      highlight = "", -- Highlight surrounding
      replace = "cs", -- Replace surrounding
      update_n_lines = "", -- Update `n_lines` (disabled)
      suffix_last = "", -- Disabled
      suffix_next = "", -- Disabled
    },
    search_method = "cover_or_next",
  },
  config = function(_, opts)
    local utils = require('utils')
    require("mini.surround").setup(opts)

    -- Remap adding surrounding to Visual mode selection
    -- vim.keymap.del("x", "ys")
    -- <C-u> is used to clear the command line before executing the Lua function
    utils.map(
      "x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { noremap = false }
    )

    -- Make special mapping for "add surrounding for line"
    -- vim.keymap.set("n", "yss", "ys_", { remap = true })
  end,
}
