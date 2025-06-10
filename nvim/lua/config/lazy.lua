local utils = require('utils')
local M = {}

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
    local function _load(mod)
        if require("lazy.core.cache").find(mod)[1] then
            require(mod)
        end
    end

    _load("config." .. name)

    local pattern = "NvimIde" .. name:sub(1, 1):upper() .. name:sub(2)
    vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

local function setup_keymaps(config_path)
    local key_files = utils.get_files_from_path(config_path)
    for _, file in ipairs(key_files) do
        local keymap = vim.fn.fnamemodify(file, ":r")
        if keymap == "copilot" and not vim.g.copilot_available then
            goto continue
        end
        M.load("keymaps." .. keymap)
        ::continue::
    end
end

function M.setup()
    -- autocmds can be loaded lazily when not opening a file
    local lazy_autocmds = vim.fn.argc(-1) == 0
    if not lazy_autocmds then
        M.load("autocmds")
    end

    local group = vim.api.nvim_create_augroup("NvimIde", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "VeryLazy",
        callback = function()
            if lazy_autocmds then
                M.load("autocmds")
            end
            local config_path = vim.fn.stdpath("config") .. "/lua/config/keymaps"
            setup_keymaps(config_path)
        end,
    })
end

return M
