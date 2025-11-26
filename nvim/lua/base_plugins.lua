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
        style = "dark"
      })
      require("onedark").load()
    end,
  },
  -- end color schemes
  { "ibhagwan/fzf-lua" },
  { "sindrets/diffview.nvim" },
  -- Code comment
  {
    "folke/ts-comments.nvim",
    opts = {},
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
    opts = {
      icons = true,
      show_hidden = false,
      indent = 2,
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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "rebelot/heirline.nvim",
        config = function()
          -- Heirline tabline that uses MultiTree’s per-tab titles when available.
          local function mt_label_for_tab(tab)
            local ok, mt = pcall(require, "multi-tree")
            if ok and mt.tab_title then
              return mt.tab_title(tab)
            end
            -- Fallback when multi-tree isn’t loaded yet.
            local win = vim.api.nvim_tabpage_get_win(tab)
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.api.nvim_buf_get_name(buf)
            return (name ~= "" and vim.fn.fnamemodify(name, ":t")) or "[No Name]"
          end

          require("heirline").setup({
            tabline = {
              {
                init = function(self)
                  self.tabs = vim.api.nvim_list_tabpages()
                end,
                provider = function(self)
                  local s, current = "", vim.api.nvim_get_current_tabpage()
                  for _, tab in ipairs(self.tabs) do
                    local nr = vim.api.nvim_tabpage_get_number(tab)
                    s = s .. "%" .. nr .. "T"
                    s = s .. (tab == current and "%#TabLineSel#" or "%#TabLine#")
                    s = s .. " " .. mt_label_for_tab(tab) .. " "
                  end
                  return s .. "%#TabLineFill#%="
                end,
              },
            },
          })
        end,
      },
    },
  },
}
