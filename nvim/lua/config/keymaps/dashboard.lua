local utils = require('utils')

-- open dashboard with leader ;
utils.map("n", "<leader>;", function()
    -- close all open buffers before open dashboard
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        ---@diagnostic disable-next-line: redundant-parameter
        local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
        if buftype ~= "terminal" then
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
    end

    vim.cmd("Dashboard")
end, { desc = "Open Dashboard" })
