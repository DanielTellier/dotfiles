local utils = require('utils')

local wk = require("which-key")
wk.add({
    { "<leader>c", group = "copilot" }
})

local ask_copilot = function()
    -- CopilotChat quick chat
    local input = vim.fn.input("Ask Copilot: ")
    if input ~= "" then
        require("CopilotChat").ask(
            input, { selection = require("CopilotChat.select").buffer }
        )
    end
end
utils.map("n", "<leader>cci", function()
    ask_copilot()
end, { desc = "CopilotChat: Ask Copilot" })
utils.map(
    "n",
    "<leader>ccD",
    "<cmd>CopilotChatDebugInfo<cr>",
    { desc = "CopilotChat - Debug Info" }
)
utils.map(
    { "n", "v" },
    "<leader>cce",
    "<cmd>CopilotChatExplain<cr>",
    { desc = "CopilotChat - Explain code" }
)
utils.map(
    { "n", "v" },
    "<leader>cct",
    "<cmd>CopilotChatTests<cr>",
    { desc = "CopilotChat - Generate tests" }
)
utils.map(
    { "n", "v" },
    "<leader>ccr",
    "<cmd>CopilotChatReview<cr>",
    { desc = "CopilotChat - Review code" }
)
utils.map(
    { "n", "v" },
    "<leader>ccR",
    "<cmd>CopilotChatRefactor<cr>",
    { desc = "CopilotChat - Refactor code" }
)
utils.map(
    { "n", "v" },
    "<leader>ccb",
    "<cmd>CopilotChatBetterNamings<cr>",
    { desc = "CopilotChat - Better Naming" }
)
utils.map(
    { "n", "v" },
    "<leader>cgc",
    "<cmd>CopilotChatCommit<cr>",
    { desc = "CopilotChat - Git commit suggestion" }
)
utils.map(
    { "n", "v" },
    "<leader>ccf",
    "<cmd>CopilotChatFixCode<cr>",
    { desc = "CopilotChat - Fix Code" }
)
utils.map(
    { "n", "v" },
    "<leader>ccd",
    "<cmd>CopilotChatDocumentation<cr>",
    { desc = "CopilotChat - Add docs to code" }
)
utils.map(
    { "n", "v" },
    "<leader>ccs",
    "<cmd>CopilotChatSummarize<cr>",
    { desc = "CopilotChat - Summarize text" }
)
utils.map(
    { "n", "v" },
    "<leader>ccS",
    "<cmd>CopilotChatSummarize<cr>",
    { desc = "CopilotChat - Correct Spelling" }
)
utils.map(
    { "n", "v" },
    "<leader>ccw",
    "<cmd>CopilotChatWording<cr>",
    { desc = "CopilotChat - Improve Wording" }
)
utils.map(
    { "n", "v" },
    "<leader>ccc",
    "<cmd>CopilotChatConcise<cr>",
    { desc = "CopilotChat - Make text concise" }
)
