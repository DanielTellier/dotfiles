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
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- NOTE: For zbirenbaum/copilot.lua the current model for
        -- completion is 'gpt-41-copilot' and cannot be modified
        -- copilot_model = vim.g.copilot_model,
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
        copilot_no_tab_map = true,
        copilot_node_command = vim.g.node_bin,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "fang2hou/blink-copilot",
        opts = {
          max_completions = 3,
          max_attempts = 4,
          kind_name = "Copilot", ---@type string | false
          kind_icon = " ", ---@type string | false
          kind_hl = false, ---@type string | false
          debounce = 200, ---@type integer | false
          auto_refresh = {
            backward = true,
            forward = true,
          },
        },
      },
      {
        "mikavilpas/blink-ripgrep.nvim",
        version = "*", -- use the latest stable version
      },
    },
    opts = {
      sources = {
        default = {
          "copilot",
          "ripgrep",
        },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
          },
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      -- for curl, log and async functions
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      model = vim.g.copilotchat_model,
      temperature = 0.8, -- lower -> less random, higher -> more random (creative)
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
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    -- TODO: Add the key maps to which key need to do this in config function
    -- config = function()
    --   local utils = require("utils")
    --   local wk = require("which-key")
    --   wk.add({
    --     { "<leader>a", group = "ai", mode = { "n", "t", "i", "x" } }
    --   })
    -- end,
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },
}
