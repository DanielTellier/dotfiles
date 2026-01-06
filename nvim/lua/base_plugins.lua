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
  -- Navigate text with flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      {
        "s", mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end, desc = "Flash"
      },
      {
        "S", mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end, desc = "Flash Treesitter"
      },
      {
        "r", mode = "o",
        function()
          require("flash").remote()
        end, desc = "Remote Flash" },
      {
        "R", mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end, desc = "Treesitter Search"
      },
    },
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
        },
      })
    end,
  },
  -- end color schemes
  { "ibhagwan/fzf-lua" },
  { "sindrets/diffview.nvim" },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
  },
  { "tpope/vim-commentary" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  {
    "DanielTellier/multi-tree.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>em",
        function()
          require("multi-tree").open(vim.loop.cwd())
        end, desc = "Open MultiTree at CWD"
      },
      {
        "<leader>eM",
        function()
          require("multi-tree").open(vim.fn.expand("%:p:h"))
        end, desc = "Open MultiTree at file dir"
      },
    },
  },
}
