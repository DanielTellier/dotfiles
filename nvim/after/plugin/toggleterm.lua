local utils = require('utils')
utils.map('n', '<leader>tm', '<cmd>ToggleTerm<cr>', { desc = "Toggle terminal" })
utils.map(
    'n',
    '<leader>mf',
    '<cmd>ToggleTerm direction=float<cr>',
    { desc = "Open terminal in float mode" }
)
utils.mapfunc(
    'n', '<leader>mv', function()
        utils.toggle_term_with_number(90, "vertical")
    end, { desc = "Open vertical terminal with number" }
)
utils.mapfunc(
    'n', '<leader>mo', function()
        utils.toggle_term_with_number(20, "horizontal")
    end, { desc = "Open horizontal terminal with number" }
)
utils.mapfunc(
    'n', '<leader>mt', function()
        utils.toggle_term_with_number(nil, "tab")
    end, { desc = "Open terminal in new tab with number" }
)
