local vim = vim
local utils = require('utils')
local copilot_enabled = os.getenv("COPILOT_ENABLED")
vim.g.node_bin = "/usr/bin/node"
if not utils.path_exists(vim.g.node_bin) then
    -- For Mac
    vim.g.node_bin = "/opt/homebrew/opt/node/bin/node"
end
vim.g.copilot_available = copilot_enabled == "true" and utils.path_exists(vim.g.node_bin)

utils.setup_vim_plug()
local Plug = vim.fn['plug#']
vim.call('plug#begin')
    Plug('navarasu/onedark.nvim')
    Plug('nvim-lualine/lualine.nvim')
    Plug('nvim-treesitter/nvim-treesitter')
    Plug('tpope/vim-commentary')
    Plug('tpope/vim-fugitive')
    Plug('tpope/vim-obsession')
    Plug('tpope/vim-repeat')
    Plug('tpope/vim-surround')
    Plug('tpope/vim-unimpaired')
    Plug('windwp/nvim-autopairs')
    if vim.g.copilot_available then
        Plug('hrsh7th/nvim-cmp')
        Plug('nvim-lua/plenary.nvim')
        Plug('CopilotC-Nvim/CopilotChat.nvim')
        Plug('zbirenbaum/copilot-cmp')
        Plug('zbirenbaum/copilot.lua')
    end
vim.call('plug#end')

require('onedark').load()
require('settings')
require('commands')
require('mappings')
require('lualine').setup({
    sections = {
        lualine_c = {'filename', utils.session_status},
        lualine_x = {'encoding', 'filetype'},
    }
})
local autopairs = require('nvim-autopairs')
autopairs.setup({
    enable_check_bracket_line = false,
    ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
})
if vim.g.copilot_available then
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
    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        copilot_no_tab_map = true,
        copilot_node_command = vim.g.node_bin,
        -- See Configuration section for rest
        -- https://github.com/zbirenbaum/copilot.lua/tree/master?tab=readme-ov-file#setup-and-configuration
    })
    local cmp = require("cmp")
    cmp.setup({
        sources = {
            { name = "copilot", group_index = 2 },
        },
        mapping = {
            ["<tab>"] = vim.schedule_wrap(function(fallback)
                if cmp.visible() and utils.has_words_before() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end),
            ['<c-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
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
    require("copilot_cmp").setup()
    require("CopilotChat").setup({
        -- Registers copilot-chat source and enables it for copilot-chat filetype (so copilot chat window)
        chat_autocomplete = false,
        debug = false, -- Set to true to see response from Github Copilot API. The log file will be in ~/.local/state/nvim/CopilotChat.nvim.log.
        prompts = prompts,
        mappings = {
            complete = {
                insert = '<c-j>',
            },
        },
        -- Change the window layout to float and position relative to cursor to make
        -- the window look like inline chat. This will allow you to chat with
        -- Copilot without opening a new window.
        window = {
            layout = 'float',
            relative = 'cursor',
            width = 1,
            height = 0.4,
            row = 1,
        },
        -- See Configuration section for rest
        -- https://github.com/CopilotC-Nvim/CopilotChat.nvim?tab=readme-ov-file#configuration
    })
end
