local utils = require('utils')
local wk = require("which-key")

wk.add({
    { "<leader>p", group = "persistence" }
})

utils.map("n", "<leader>ps", function()
    require("persistence").save()
end, { desc = "Save session" })
utils.map("n", "<leader>pl", function()
    require("persistence").load({ last = true })
end, { desc = "Restore last session" })
utils.map("n", "<leader>pc", function()
    require("persistence").select()
end, { desc = "Select session to restore" })
utils.map("n", "<leader>pq", function()
    require("persistence").stop()
end, { desc = "Stop persistence" })
