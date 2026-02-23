return {
  -- Which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      defaults = {},
      ---@type false | "classic" | "modern" | "helix"
      preset = vim.g.which_key_preset or "helix", -- default is "classic"
      -- Custom helix layout
      win = vim.g.which_key_window or {
        width = { min = 30, max = 60 },
        height = { min = 4, max = 0.85 },
      },
      spec = {},
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      if not vim.tbl_isempty(opts.defaults) then
        wk.register(opts.defaults)
      end
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      enable_check_bracket_line = false,
      ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    },
  },
  -- color schemes
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "dark",
        highlights = {
          ["@comment.note"] = { fg = "$blue", fmt = "bold,italic" },
          ["@comment.warning"] = { fg = "$yellow", fmt = "bold,italic" },
          ["@comment.todo"] = { fg = "$orange", fmt = "bold,italic" },
          ["@comment.error"] = { fg = "$red", fmt = "bold,italic" },
          ["MatchParen"] = { fg = "$red", bg = "$bg1", fmt = "bold,underline" },
        },
      })
    end,
  },
  -- end color schemes
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "ibhagwan/fzf-lua" },
  { 'numToStr/Comment.nvim' },
  {
    "j-hui/fidget.nvim",
    version = "*", -- alternatively, pin this to a specific version, e.g., "1.6.1"
  },
  {
    "DanielTellier/multi-tree.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
}
