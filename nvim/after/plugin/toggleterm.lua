local utils = require('utils')

local function toggle_term_with_index(size, direction)
    if tonumber(index) then
        local cmd = ""
        if direction == "tab" then
            cmd = string.format(
                "%sToggleTerm direction=%s", index, direction
            )
        else
            cmd = string.format(
                "%sToggleTerm size=%d direction=%s", index, size, direction
            )
        end
        vim.cmd(cmd)
    else
        print("Invalid input! Please enter a number.")
    end
end
utils.map('n', '<leader>tm', '<cmd>ToggleTerm<cr>', { desc = "Toggle terminal" })
utils.map(
    'n',
    '<leader>mf',
    '<cmd>ToggleTerm direction=float<cr>',
    { desc = "Open terminal in float mode" }
)
utils.mapfunc(
    'n', '<leader>mv', function()
        utils.toggle_term_with_index(90, "vertical")
    end, { desc = "Open vertical terminal with number" }
)
utils.mapfunc(
    'n', '<leader>mo', function()
        utils.toggle_term_with_index(20, "horizontal")
    end, { desc = "Open horizontal terminal with number" }
)
utils.mapfunc(
    'n', '<leader>mt', function()
        utils.toggle_term_with_index(nil, "tab")
    end, { desc = "Open terminal in new tab with number" }
)
