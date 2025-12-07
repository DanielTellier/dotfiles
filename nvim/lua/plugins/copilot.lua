if not vim.g.copilot_available then
  return {}
end

local utils = require('utils')
local common_system_prompt = [[Analyze the code for:
### CODE QUALITY
* Function and variable naming (clarity and consistency)
* Code organization and structure
* Documentation and comments
* Consistent formatting and style

### RELIABILITY
* Error handling and edge cases
* Resource management
* Input validation

### MAINTAINABILITY
* Code duplication (but don't overdo it with DRY, some duplication is fine)
* Single responsibility principle
* Modularity and dependencies
* API design and interfaces
* Configuration management

### PERFORMANCE
* Algorithmic efficiency
* Resource usage
* Caching opportunities
* Memory management

### SECURITY
* Input sanitization
* Authentication/authorization
* Data validation
* Known vulnerability patterns

### TESTING
* Unit test coverage
* Integration test needs
* Edge case testing
* Error scenario coverage

### POSITIVE HIGHLIGHTS
* Note any well-implemented patterns
* Highlight good practices found
* Commend effective solutions
]]

local prompts = {
  -- Code related prompts
  ["Explain"] = {
    description = "Explain how the code works",
    prompt = "Please explain how this code works in detail.",
    system_prompt = [[You are an expert programmer skilled at explaining complex
code in a clear and concise manner. Break down the explanation into logical components
and highlight key concepts.
]],
  },
  ["Review"] = {
    description = "Review the provided code",
    prompt = "Review the provided code and suggest improvements.",
    system_prompt = common_system_prompt .. [[
Format findings as markdown and with:
- Issue: [description]
- Impact: [specific impact]
- Suggestion: [concrete improvement with code example/suggestion]
]],
  },
  ["Tests"] = {
    description = "Create test cases for the code",
    prompt = "Explain how the selected code works, then generate unit tests for it.",
    system_prompt = common_system_prompt .. [[
Format findings as markdown and with:
Test Description: [description for each test case]
Test Case:
[Test code for specific test case]
]],
  },
  ["Refactor"] = {
    description = "Refactor the code",
    prompt = "Refactor the following code to improve its clarity and readability.",
    system_prompt = common_system_prompt .. [[
Format findings as markdown and with:
Refactor Description:
[description refactoring]

Refactoring:
[refactor of code]
]],
  },
  ["FixCode"] = {
    description = "Fix the code",
    prompt = "Fix the following code to make it work as intended.",
    system_prompt = common_system_prompt .. [[
Format findings as markdown and with:
Fix Description:
[description of what is fixed]

Fixes:
[fixes of code]
]],
  },
  ["BetterNamings"] = {
    description = "Add better naming to the code",
    prompt = "Provide better names for the following variables and functions.",
    system_prompt = common_system_prompt .. [[
Format findings as markdown and with:
Better Naming Description:
[description of what is renamed]

Renamings:
[renaming of code]
]],
  },
  ["Documentation"] = {
    description = "Add docs to the code",
    prompt = "Provide documentation for the following code.",
    system_prompt = common_system_prompt .. [[
Format findings as markdown and with:
Docs Description:
[description of what is documented]

Documentation:
[code with docs]
]],
  },
  -- Text related prompts
  ["Summarize"] = {
    description = "Summarize the text",
    prompt = "Summarize the following text.",
    system_prompt = [[You are an expert writer skilled at explaining complex
text/code in a clear and concise manner. Break down the explanation into logical components
and highlight key concepts.
]],
  },
  ["Spelling"] = {
    description = "Correct spelling of the text",
    prompt = "Correct any grammar and spelling errors in the following text.",
    system_prompt = [[You are an expert writer skilled at writing complex
text/code in a clear and concise manner. Break down the text into logical components
and highlight key concepts.
]],
  },
  ["Wording"] = {
    description = "Improve wording of the text",
    prompt = "Improve the grammar and wording of the following text.",
    system_prompt = [[You are an expert writer skilled at writing complex
text/code in a clear and concise manner. Break down the text into logical components
and highlight key concepts.
]],
  },
  ["Concise"] = {
    description = "Make the text more concise",
    prompt = "Rewrite the following text to make it more concise.",
    system_prompt = [[You are an expert writer skilled at writing complex
text/code in a clear and concise manner. Break down the text into logical components
and highlight key concepts.
]],
  },
}

return {
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
              ["<tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item(
                    { behavior = cmp.SelectBehavior.Select }
                  )
                elseif utils.has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { 'i', 's' }),
              ["<s-tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item(
                    { behavior = cmp.SelectBehavior.Select }
                  )
                elseif utils.has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { 'i', 's' }),
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
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            copilot_model = vim.g.copilot_model,
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
      model = vim.g.copilot_model,
      context = "buffers",
      -- Registers copilot-chat source and enables it for copilot-chat filetype (so copilot chat window)
      chat_autocomplete = false,
      debug = false, -- Set to true to see response from Github Copilot API. The log file will be in ~/.local/state/nvim/CopilotChat.nvim.log.
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
      prompts = prompts,
      mappings = {
        complete = {
          detail = "Use @<c-i> or /<c-i> for options.",
          insert = '<c-i>',
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
    config = function(_, opts)
      local chat = require("CopilotChat")
      local hostname = io.popen("hostname"):read("*a"):gsub("%s+", "")
      local user = hostname or vim.env.USER or "User"
      opts.question_header = "  " .. user .. " "
      opts.answer_header = "  Copilot "
      local commit_prompt = [[#git:staged
You are a Git expert. Write a concise commit message for the staged changes.

Format:
- Title: type(scope): brief description (50 chars max)
- Body: As few sentences as possible (ideally 1-2 sentences) to explaining what and why (wrap at 72 chars)

Requirements:
- Use conventional commits: feat, fix, docs, style, refactor, test, chore, perf, ci, build
- Title in imperative mood (Add, Fix, Update)
- Body should be a high-level summary, not a detailed breakdown
- Be brief but clear
- Mention breaking changes if any

Example:
feat(auth): Add OAuth Google integration

Implement Google OAuth 2.0 flow replacing basic auth.
]]
      -- Override the git prompts message
      opts.prompts.Commit = {
        prompt = commit_prompt,
      }
      chat.setup(opts)
      local select = require("CopilotChat.select")
      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })
      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })
      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end,
      })
    end,
  },
}
