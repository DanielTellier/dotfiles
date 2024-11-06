local function path_exists(path)
    local stat = vim.loop.fs_stat(path)
    return stat ~= nil
end

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local ask_copilot = function()
    -- CopilotChat quick chat
    local input = vim.fn.input("Ask Copilot: ")
    if input ~= "" then
        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
    end
end

-- Hard coded to false since not paying for copilot
local have_copilot = false
local node_bin = "/usr/bin/node"
if not path_exists(node_bin) then
    -- For Mac
    node_bin = "/opt/homebrew/opt/node/bin/node"
end

require('settings')
require('commands')
require('mappings')
if have_copilot and path_exists(node_bin) then
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
        copilot_node_command = node_bin,
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
                if cmp.visible() and has_words_before() then
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
            ["<cr>"] = cmp.mapping.confirm({ select = true }),
        },
        sorting = {
            priority_weight = 2,
        },
    })
    local autopairs = require('nvim-autopairs')
    autopairs.setup({
        enable_check_bracket_line = false,
        ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    })
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )
    require("copilot_cmp").setup()
    -- Registers copilot-chat source and enables it for copilot-chat filetype (so copilot chat window)
    require("CopilotChat.integrations.cmp").setup()
    require("CopilotChat").setup({
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
    local utils = require('utils')
    utils.mapfunc('n', '<leader>cci', function() ask_copilot() end, { silent = false, desc = 'CopilotChat - Ask input' })
    utils.map('n', '<leader>ccD', '<cmd>CopilotChatDebugInfo<cr>', { desc = 'CopilotChat - Debug info' })
    for _, mode in ipairs({'n', 'v'}) do
        -- Code related commands
        utils.map(mode, '<leader>cce', '<cmd>CopilotChatExplain<cr>', { desc = 'CopilotChat - Explain code' })
        utils.map(mode, '<leader>cct', '<cmd>CopilotChatTests<cr>', { desc = 'CopilotChat - Generate Tests' })
        utils.map(mode, '<leader>ccr', '<cmd>CopilotChatReview<cr>', { desc = 'CopilotChat - Review code' })
        utils.map(mode, '<leader>ccR', '<cmd>CopilotChatRefactor<cr>', { desc = 'CopilotChat - Refactor code' })
        utils.map(mode, '<leader>ccf', '<cmd>CopilotChatFixCode<cr>', { desc = 'CopilotChat - Fix code' })
        utils.map(mode, '<leader>ccd', '<cmd>CopilotChatDocumentation<cr>', { desc = 'CopilotChat - Add documentation for code' })
        utils.map(mode, '<leader>cca', '<cmd>CopilotChatSwaggerApiDocs<cr>', { desc = 'CopilotChat - Add Swagger API documentation' })
        utils.map(mode, '<leader>ccA', '<cmd>CopilotChatSwaggerNumpyDocs<cr>', { desc = 'CopilotChat - Add Swagger API documentation with Numpy Documentation' })
        -- Text related commands
        utils.map(mode, '<leader>ccs', '<cmd>CopilotChatSummarize<cr>', { desc = 'CopilotChat - Summarize text' })
        utils.map(mode, '<leader>ccS', '<cmd>CopilotChatSpelling<cr>', { desc = 'CopilotChat - Correct spelling' })
        utils.map(mode, '<leader>ccw', '<cmd>CopilotChatWording<cr>', { desc = 'CopilotChat - Improve wording' })
        utils.map(mode, '<leader>ccc', '<cmd>CopilotChatConcise<cr>', { desc = 'CopilotChat - Make text concise' })
    end
    utils.map('x', '<leader>ccv', ':CopilotChatVisual', { silent = false, desc = 'CopilotChat - Open in vertical split' })
    utils.map('x', '<leader>ccx', ':CopilotChatInPlace<cr>', { desc = 'CopilotChat - Run in-place code' })
end
