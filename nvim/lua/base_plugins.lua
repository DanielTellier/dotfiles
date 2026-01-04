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
    init = function()
      -- Disable netrw so directories don’t open there.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local function open_mt(file)
        if not file then return end
        local fullpath = vim.fn.fnamemodify(file, ":p")
        local buf = vim.fn.bufnr(fullpath)
        if buf == -1 or not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if vim.bo[buf].filetype == "multi-tree" then return end
        if vim.fn.isdirectory(file) == 1 then
          require("multi-tree").open(vim.fn.fnameescape(file))
          -- Clean up the original buffer.
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end

      -- Start with a directory: `nvim .` or `nvim path/`.
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Conventional behavior: only hijack when there is exactly one arg and it's a dir.
          if vim.fn.argc() == 1 then
            local arg = vim.fn.argv(0)
            if not arg then return end
            open_mt(arg)
          end
        end,
        once = true,
      })

      -- Replace :edit . (or :edit <dir>) mid-session in the current window.
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(ev)
          open_mt(ev.file)
        end,
      })
    end,
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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
}
