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
    event = "VeryLazy", -- or lazy = false if you want it at startup
    cmd = { "MultiTree" }, -- calling :MultiTree auto-loads the plugin so can replace with netrw
    main = "multi-tree",
    init = function()
      -- Disable netrw so directories don’t open there.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Start with a directory: `nvim .` or `nvim path/`.
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Conventional behavior: only hijack when there is exactly one arg and it's a dir.
          if vim.fn.argc() == 1 then
            local arg = vim.fn.argv(0)
            if arg ~= nil and vim.fn.isdirectory(arg) == 1 then
              -- Optional: set cwd to that directory for the session/tab as you prefer.
              -- vim.cmd("cd " .. vim.fn.fnameescape(arg))
              vim.cmd("MultiTree " .. vim.fn.fnameescape(arg)) -- loads plugin via cmd
            end
          end
        end,
        once = true,
      })

      -- Replace :edit . (or :edit <dir>) mid-session in the current window.
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(ev)
          -- Avoid loops and only act on real directory buffers.
          if ev.file == "" then return end
          if vim.bo[ev.buf].filetype == "multi-tree" then return end
          if vim.fn.isdirectory(ev.file) == 1 then
            -- Use schedule to avoid doing too much during the event itself.
            vim.schedule(function()
              vim.cmd("MultiTree " .. vim.fn.fnameescape(ev.file))
            end)
          end
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "multi-tree",
        callback = function(ev)
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({ { "<leader>", group = "multi-tree", mode = "n", buffer = ev.buf } })
          end
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
