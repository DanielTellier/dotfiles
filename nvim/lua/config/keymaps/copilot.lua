local utils = require('utils')
local wk = require("which-key")

wk.add({
    { "<leader>c", group = "copilot", mode = { "n", "x", "v" } },
})

utils.map("n", "<leader>cm",
    "<cmd>CopilotChatModels<cr>",
    { desc = "CopilotChat - View/Change the current model" }
)

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

utils.map({ "n", "v" }, "<leader>ct", function()
    toggle_copilot()
end, { desc = "CopilotChat - Toggle Copilot" })
utils.map("x", "<leader>cv",
    "<cmd>CopilotChatVisual<cr>",
    { desc = "CopilotChat - Open in vertical split" }
)
utils.map("x", "<leader>ci",
    "<cmd>CopilotChatInline<cr>",
    { desc = "CopilotChat - Inline chat" }
)
utils.map({ "n", "v" }, "<leader>cq", function()
    quick_copilot()
end, { desc = "CopilotChat - Quick chat" })
utils.map({ "n", "v" }, "<leader>ca", function()
    ask_copilot()
end, { desc = "CopilotChat - Ask chat" })

-- Prompt Keymaps
utils.map("n", "<leader>cp", function()
    require("CopilotChat").select_prompt({
        context = {
            "buffers",
        },
    })
end, { desc = "CopilotChat - Prompt actions" })
utils.map("x", "<leader>cp", function()
    require("CopilotChat").select_prompt()
end, { desc = "CopilotChat - Prompt actions" })
utils.map(
    { "n", "v" },
    "<leader>ce",
    "<cmd>CopilotChatExplain<cr>",
    { desc = "CopilotChat - Explain code" }
)
utils.map(
    { "n", "v" },
    "<leader>cT",
    "<cmd>CopilotChatTests<cr>",
    { desc = "CopilotChat - Generate tests" }
)
utils.map(
    { "n", "v" },
    "<leader>cr",
    "<cmd>CopilotChatReview<cr>",
    { desc = "CopilotChat - Review code" }
)
utils.map(
    { "n", "v" },
    "<leader>cR",
    "<cmd>CopilotChatRefactor<cr>",
    { desc = "CopilotChat - Refactor code" }
)
utils.map(
    { "n", "v" },
    "<leader>cb",
    "<cmd>CopilotChatBetterNamings<cr>",
    { desc = "CopilotChat - Better Naming" }
)
utils.map(
    { "n", "v" },
    "<leader>cc",
    "<cmd>CopilotChatCommit<cr>",
    { desc = "CopilotChat - Git commit suggestion" }
)
utils.map(
    { "n", "v" },
    "<leader>cf",
    "<cmd>CopilotChatFixCode<cr>",
    { desc = "CopilotChat - Fix Code" }
)
utils.map(
    { "n", "v" },
    "<leader>cd",
    "<cmd>CopilotChatDocumentation<cr>",
    { desc = "CopilotChat - Add docs to code" }
)
utils.map(
    { "n", "v" },
    "<leader>cs",
    "<cmd>CopilotChatSummarize<cr>",
    { desc = "CopilotChat - Summarize text" }
)
utils.map(
    { "n", "v" },
    "<leader>cS",
    "<cmd>CopilotChatSummarize<cr>",
    { desc = "CopilotChat - Correct Spelling" }
)
utils.map(
    { "n", "v" },
    "<leader>cw",
    "<cmd>CopilotChatWording<cr>",
    { desc = "CopilotChat - Improve Wording" }
)
utils.map(
    { "n", "v" },
    "<leader>cC",
    "<cmd>CopilotChatConcise<cr>",
    { desc = "CopilotChat - Make text concise" }
)
