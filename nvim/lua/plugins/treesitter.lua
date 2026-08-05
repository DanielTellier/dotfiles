local utils = require('utils')

local parsers = {
  "bash",
  "c",
  "comment",
  "css",
  "diff",
  "graphql",
  "html",
  "java",
  "javascript",
  "json",
  "json5",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "toml",
  "vim",
}

return {
  -- Syntax highlighting and indentation
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    build = ":TSUpdate",
    lazy = false, -- nvim-treesitter `main` does not support lazy-loading
    config = function()
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = utils.augroup("treesitter"),
        desc = "Enable treesitter highlighting and indentation",
        callback = function(event)
          local buf = event.buf
          if not vim.treesitter.language.get_lang(vim.bo[buf].filetype) then
            return
          end
          if not pcall(vim.treesitter.start, buf) then
            return
          end
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,           -- Auto close tags
          enable_rename = true,          -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local objects = {
        f = { query = "@function.outer", inner = "@function.inner", desc = "function" },
        c = { query = "@class.outer", inner = "@class.inner", desc = "class" },
        a = { query = "@parameter.inner", desc = "parameter" },
      }

      for key, obj in pairs(objects) do
        if obj.inner then
          utils.map({ "x", "o" }, "a" .. key, function()
            select.select_textobject(obj.query, "textobjects")
          end, { desc = "Select outer part of a " .. obj.desc })
          utils.map({ "x", "o" }, "i" .. key, function()
            select.select_textobject(obj.inner, "textobjects")
          end, { desc = "Select inner part of a " .. obj.desc })
        end

        local upper = key:upper()
        utils.map({ "n", "x", "o" }, "]" .. key, function()
          move.goto_next_start(obj.query, "textobjects")
        end, { desc = "Next " .. obj.desc .. " start" })
        utils.map({ "n", "x", "o" }, "]" .. upper, function()
          move.goto_next_end(obj.query, "textobjects")
        end, { desc = "Next " .. obj.desc .. " end" })
        utils.map({ "n", "x", "o" }, "[" .. key, function()
          move.goto_previous_start(obj.query, "textobjects")
        end, { desc = "Previous " .. obj.desc .. " start" })
        utils.map({ "n", "x", "o" }, "[" .. upper, function()
          move.goto_previous_end(obj.query, "textobjects")
        end, { desc = "Previous " .. obj.desc .. " end" })
      end
    end,
  },
}
