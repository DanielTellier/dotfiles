local utils = require('utils')
local wk = require("which-key")

wk.add({
    { "<leader>a", group = "copilot", mode = { "n", "x", "v" } },
})

local ask_copilot = function()
    local input = vim.fn.input("Ask Copilot: ")
    if input ~= "" then
        vim.cmd("CopilotChat " .. input)
    end
end
local quick_copilot = function()
    local input = vim.fn.input("Quick Copilot: ")
    if input ~= "" then
        require("CopilotChat").ask(
            input, { selection = require("CopilotChat.select").buffer }
        )
    end
end
local toggle_copilot = function()
    local chat = require("CopilotChat")
    chat.toggle()
end

utils.map({ "n", "v" }, "<leader>at", function()
    toggle_copilot()
end, { desc = "CopilotChat - Toggle Copilot" })
utils.map("x", "<leader>av",
    "<cmd>CopilotChatVisual<cr>",
    { desc = "CopilotChat - Open in vertical split" }
)
utils.map("x", "<leader>ai",
    "<cmd>CopilotChatInline<cr>",
    { desc = "CopilotChat - Inline chat" }
)
utils.map({ "n", "v" }, "<leader>aq", function()
    quick_copilot()
end, { desc = "CopilotChat - Quick chat" })
utils.map({ "n", "v" }, "<leader>aa", function()
    ask_copilot()
end, { desc = "CopilotChat - Ask chat" })

-- Prompt Keymaps
utils.map("n", "<leader>ap", function()
    require("CopilotChat").select_prompt({
        context = {
            "buffers",
        },
    })
end, { desc = "CopilotChat - Prompt actions" })
utils.map("x", "<leader>ap", function()
    require("CopilotChat").select_prompt()
end, { desc = "CopilotChat - Prompt actions" })
utils.map(
    { "n", "v" },
    "<leader>ae",
    "<cmd>CopilotChatExplain<cr>",
    { desc = "CopilotChat - Explain code" }
)
utils.map(
    { "n", "v" },
    "<leader>aT",
    "<cmd>CopilotChatTests<cr>",
    { desc = "CopilotChat - Generate tests" }
)
utils.map(
    { "n", "v" },
    "<leader>ar",
    "<cmd>CopilotChatReview<cr>",
    { desc = "CopilotChat - Review code" }
)
utils.map(
    { "n", "v" },
    "<leader>aR",
    "<cmd>CopilotChatRefactor<cr>",
    { desc = "CopilotChat - Refactor code" }
)
utils.map(
    { "n", "v" },
    "<leader>ab",
    "<cmd>CopilotChatBetterNamings<cr>",
    { desc = "CopilotChat - Better Naming" }
)
utils.map(
    { "n", "v" },
    "<leader>ac",
    "<cmd>CopilotChatCommit<cr>",
    { desc = "CopilotChat - Git commit suggestion" }
)
utils.map(
    { "n", "v" },
    "<leader>af",
    "<cmd>CopilotChatFixCode<cr>",
    { desc = "CopilotChat - Fix Code" }
)
utils.map(
    { "n", "v" },
    "<leader>ad",
    "<cmd>CopilotChatDocumentation<cr>",
    { desc = "CopilotChat - Add docs to code" }
)
utils.map(
    { "n", "v" },
    "<leader>as",
    "<cmd>CopilotChatSummarize<cr>",
    { desc = "CopilotChat - Summarize text" }
)
utils.map(
    { "n", "v" },
    "<leader>aS",
    "<cmd>CopilotChatSummarize<cr>",
    { desc = "CopilotChat - Correct Spelling" }
)
utils.map(
    { "n", "v" },
    "<leader>aw",
    "<cmd>CopilotChatWording<cr>",
    { desc = "CopilotChat - Improve Wording" }
)
utils.map(
    { "n", "v" },
    "<leader>aC",
    "<cmd>CopilotChatConcise<cr>",
    { desc = "CopilotChat - Make text concise" }
)
