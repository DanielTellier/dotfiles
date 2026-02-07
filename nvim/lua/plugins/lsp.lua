vim.g.lsp_enabled = false

return {
  -- LSP Configuration & Management
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      -- Mason, the installer for LSPs
      {
        "williamboman/mason.nvim",
        config = function()
          -- Can set the below for saving space in home path
          -- local user = vim.fn.getenv("USER") or "unknown"
          -- local mason_root = (
          --     vim.fn.getenv("XDG_CACHE_HOME") or "/tmp/" .. user .. "/.cache"
          -- )
          -- mason_root = mason_root .. "/nvim/mason"
          -- Ensures Mason-installed binaries are available on your PATH
          require("mason").setup({
            PATH = "prepend",
            -- install_root_dir = mason_root,
          })
        end,
      },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      -- Bridge between Mason and lspconfig
      { "williamboman/mason-lspconfig.nvim" },
      -- "Quality of life" plugin to show LSP status updates
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      local utils = require("utils")
      local wk = require("which-key")
      wk.add({
        { "<leader>l", group = "lsp", mode = "n" }
      })
      -- NOTE: Can find all telescope lsp options here:
      -- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#neovim-lsp-pickers
      -- Keymaps will be set inside on_attach to ensure they only apply to LSP buffers
      local on_attach = function(client, bufnr)
        local telescope_builtin = require("telescope.builtin")
        utils.map(
          'n',
          '<leader>ld',
          telescope_builtin.lsp_definitions,
          { buffer = bufnr, desc = 'Go to definition' }
        )
        utils.map(
          'n',
          '<leader>lh',
          vim.lsp.buf.hover,
          { buffer = bufnr, desc = 'Show hover information' }
        )
        utils.map(
          'n',
          '<leader>li',
          telescope_builtin.lsp_implementations,
          { buffer = bufnr, desc = 'Go to implementation' }
        )
        utils.map(
          'n',
          '<leader>lr',
          telescope_builtin.lsp_references,
          { buffer = bufnr, desc = 'Show references' }
        )
        utils.map(
          'n',
          '<leader>ls',
          vim.lsp.buf.rename,
          { buffer = bufnr, desc = 'Rename symbol' }
        )
        utils.map(
          'n',
          '<leader>lc',
          vim.lsp.buf.code_action,
          { buffer = bufnr, desc = 'Code actions' }
        )
        -- Disable diagnostics for all LSP clients (icon indicators)
        vim.diagnostic.enable(false, { bufnr = bufnr })
      end
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Central table for server configurations
      local servers = {
        -- Refined lua_ls setup from your examples
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("lua", true) },
              telemetry = { enable = false },
            },
          },
        },
        -- Refined clangd setup with performance and completion flags
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--pch-storage=memory",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "-j=4", -- Adjust thread count based on your CPU
          },
        },
        -- Pyright works best with default settings, automatically detecting venvs
        pyright = {},
      }

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
      for server_name, server_opts in pairs(servers) do
        local final_config = vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, server_opts or {})

        vim.lsp.config[server_name] = final_config
      end

      local function apply_lsp_status()
        if vim.g.lsp_enabled then
          vim.cmd("doautocmd FileType")
        else
          for _, client in ipairs(vim.lsp.get_clients()) do
            -- Stop all LSP clients except for copilot
            if client.name ~= "copilot" then
              vim.lsp.stop_client(client.id)
            end
          end
        end
      end
      local function toggle_lsp()
        vim.g.lsp_enabled = not vim.g.lsp_enabled
        apply_lsp_status()
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = utils.augroup("lsp"),
        callback = function()
          apply_lsp_status()
        end
      })

      utils.map(
        'n', '<leader>lt', function()
          toggle_lsp()
        end, { desc = 'Toggle lsp' }
      )
      utils.map(
        'n', '<leader>lg', function()
          vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        end, { desc = 'Toggle Diagnostics' }
      )
    end,
  },
}
