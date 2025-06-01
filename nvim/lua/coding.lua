local utils = require('utils')
local spec = {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>d", group = "debug" },
        { "<leader>r", group = "refactoring", icon = "" },
      },
    },
  },
  -- Code comment
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
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
                                        cmp.mapping.select_next_item(
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
                    end,
                },
            },
        },
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            dependencies = {
                {
                    "zbirenbaum/copilot.lua",
                    cmd = "Copilot",
                    event = "InsertEnter",
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
                question_header = "## User ",
                answer_header = "## Copilot ",
                error_header = "## Error ",
                model = copilot_model,
                -- Registers copilot-chat source and enables it for copilot-chat filetype (so copilot chat window)
                chat_autocomplete = false,
                debug = false, -- Set to true to see response from Github Copilot API. The log file will be in ~/.local/state/nvim/CopilotChat.nvim.log.
                prompts = prompts,
                mappings = {
                    complete = {
                        detail = "Use @<tab> or /<tab> for options.",
                        insert = '<tab>',
                    },
                    -- Close the chat
                    close = {
                        normal = "q",
                        insert = "<C-c>",
                    },
                    -- Reset the chat buffer
                    reset = {
                        normal = "<C-x>",
                        insert = "<C-x>",
                    },
                    -- Submit the prompt to Copilot
                    submit_prompt = {
                        normal = "<CR>",
                        insert = "<C-CR>",
                    },
                    -- Accept the diff
                    accept_diff = {
                        normal = "<C-y>",
                        insert = "<C-y>",
                    },
                    -- Show help
                    show_help = {
                        normal = "g?",
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

return spec
