-- Bootstrap lazy.nvim
local vim = vim
local utils = require('utils')
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local spec = {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
    {
        "Shatur/neovim-session-manager",
        config = function()
            local config = require("session_manager.config")
            require("session_manager").setup({
                autoload_mode = config.AutoloadMode.CurrentDir,
            })
        end,
    },
    -- color schemes
    {
        "navarasu/onedark.nvim",
        lazy = false,
        config = function()
            require("onedark").setup({
                style = "cool"
            })
            require("onedark").load()
        end,
    },
    -- end color schemes
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "windwp/nvim-ts-autotag" },
    },
    { "L3MON4D3/LuaSnip" },
    { "sindrets/diffview.nvim" },
    -- {
    --     "rmagatti/auto-session",
    --     lazy = false,
    --     dependencies = {
    --         "nvim-telescope/telescope.nvim", -- Only needed if you want to use sesssion lens
    --     },
    --     config = function()
    --         require("auto-session").setup({
    --             auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    --             bypass_save_filetypes = { "netrw" },
    --         })
    --     end,
    -- },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            enable_check_bracket_line = false,
            ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts ={
            sections = {
                lualine_c = {'filename', utils.session_status},
                lualine_x = {'encoding', 'filetype'},
            },
        },
    },
    -- {
    --     "romgrk/barbar.nvim",
    --     dependencies = {
    --         "lewis6991/gitsigns.nvim",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     init = function()
    --         vim.g.barbar_auto_setup = false
    --     end,
    --     opts = {
    --         animation = false,
    --     },
    -- },
    {
        "OXY2DEV/markview.nvim",
        lazy = false, -- Recommended
        -- ft = "markdown" -- If you decide to lazy-load anyway
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
    { "tpope/vim-commentary" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-repeat" },
    { "tpope/vim-surround" },
    { "tpope/vim-unimpaired" },
}
if vim.g.copilot_available then
    local copilot_model = "claude-3.7-sonnet"
    local prompts = {
        -- Code-related prompts
        Explain = "Please explain how the following code works.",
        Review = "Please review the following code and provide suggestions for improvement.",
        Tests = "Please explain how the selected code works, then generate unit tests for it.",
        Refactor = "Please refactor the following code to improve its clarity and readability.",
        FixCode = "Please fix the following code to make it work as intended.",
        Documentation = "Please provide documentation for the following code.",
        SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
        SwaggerNumpyDocs = "Please write numpydoc for the following API using Swagger.",
        -- Text-related prompts
        Summarize = "Please summarize the following text.",
        Spelling = "Please correct any grammar and spelling errors in the following text.",
        Wording = "Please improve the grammar and wording of the following text.",
        Concise = "Please rewrite the following text to make it more concise.",
    }
    local copilot_spec = {
        {
            'zbirenbaum/copilot-cmp',
            config = function ()
                require("copilot_cmp").setup()
            end,
            dependencies = {
                {
                    'hrsh7th/nvim-cmp',
                    config = function()
                        local cmp = require("cmp")
                        cmp.setup({
                            sources = {
                                { name = "copilot", group_index = 2 },
                            },
                            mapping = {
                                ["<tab>"] = vim.schedule_wrap(function(fallback)
                                    if cmp.visible() and utils.has_words_before() then
                                        cmp.select_next_item(
                                            { behavior = cmp.SelectBehavior.Select }
                                        )
                                    else
                                        fallback()
                                    end
                                end),
                                ['<c-b>'] = cmp.mapping(
                                    cmp.mapping.scroll_docs(-4), { 'i', 'c' }
                                ),
                                ['<c-f>'] = cmp.mapping(
                                    cmp.mapping.scroll_docs(4), { 'i', 'c' }
                                ),
                                ['<c-space>'] = cmp.mapping(
                                    cmp.mapping.complete(), { 'i', 'c' }
                                ),
                                ['<c-y>'] = cmp.config.disable,
                                ['<c-e>'] = cmp.mapping({
                                    i = cmp.mapping.abort(),
                                    c = cmp.mapping.close(),
                                }),
                                ["<c-c>"] = cmp.mapping.confirm({ select = true }),
                            },
                            sorting = {
                                priority_weight = 2,
                            },
                        })
                        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
                        cmp.event:on(
                            'confirm_done',
                            cmp_autopairs.on_confirm_done()
                        )
                    end,
                },
            },
        },
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            dependencies = {
                {
                    "zbirenbaum/copilot.lua",
                    config = function()
                        require("copilot").setup({
                            copilot_model = copilot_model,
                            suggestion = { enabled = false },
                            panel = { enabled = false },
                            copilot_no_tab_map = true,
                            copilot_node_command = vim.g.node_bin,
                        })
                    end,
                },
                -- for curl, log and async functions
                { "nvim-lua/plenary.nvim", branch = "master" },
            },
            build = "make tiktoken", -- Only on MacOS or Linux
            opts = {
                model = copilot_model,
                -- Registers copilot-chat source and enables it for copilot-chat filetype (so copilot chat window)
                chat_autocomplete = false,
                debug = false, -- Set to true to see response from Github Copilot API. The log file will be in ~/.local/state/nvim/CopilotChat.nvim.log.
                prompts = prompts,
                mappings = {
                    complete = {
                        insert = '<c-j>',
                    },
                },
                window = {
                    layout = 'horizontal',
                    relative = 'editor',
                    width = 0.3,
                    height = 0.3,
                },
                -- See Configuration section for rest
                -- https://github.com/CopilotC-Nvim/CopilotChat.nvim?tab=readme-ov-file#configuration
            },
        },
    }
    utils.table_concat(spec, copilot_spec)
end
-- Setup lazy.nvim
require("lazy").setup({
    spec = spec,
    {
        rocks = {
            hererocks = true, -- recommended if you do not have global installation of Lua 5.1.
        },
    },
    ui = {
        border = "single",
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "onedark" } },
    -- automatically check for plugin updates
    checker = { enabled = true, notify = false },
})
