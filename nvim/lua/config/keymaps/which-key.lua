local utils = require('utils')
local wk = require("which-key")

wk.add({
    { "<leader>k", group = "which-key", mode = "n" }
})

utils.map('n', '<leader>kg', function()
    require("which-key").show({ global = true })
end, { desc = "Display global keymaps" })

utils.map('n', '<leader>kl', function()
    require("which-key").show({ global = false })
end, { desc = "Display local buffer keymaps" })
