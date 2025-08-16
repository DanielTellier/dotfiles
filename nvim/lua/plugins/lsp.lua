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
                    -- Ensures Mason-installed binaries are available on your PATH
                    require("mason").setup({ PATH = "prepend" })
                end,
            },
            -- Bridge between Mason and lspconfig
            { "williamboman/mason-lspconfig.nvim" },
            -- "Quality of life" plugin to show LSP status updates
            { "j-hui/fidget.nvim", opts = {} },
            { "hrsh7th/cmp-nvim-lsp" },
        },
        config = function()
            -- Keymaps will be set inside on_attach to ensure they only apply to LSP buffers
            local on_attach = function(client, bufnr)
                local utils = require("utils")
                local telescope_builtin = require("telescope.builtin")
                local wk = require("which-key")
                wk.add({
                    { "<leader>l", group = "lsp", buffer = bufnr, mode = "n" }
                })
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
            end

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Central table for server configurations
            local servers = {
                -- Refined lua_ls setup from your examples
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
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

                require("lspconfig")[server_name].setup(final_config)
            end
        end,
    },
}
