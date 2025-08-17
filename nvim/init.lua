-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.lsp_enabled = false
vim.g.session_dir = vim.fn.stdpath("state") .. "/sessions"
-- Ensure the directory exists
if vim.fn.isdirectory(vim.g.session_dir) == 0 then
    vim.fn.mkdir(vim.g.session_dir, 'p')
end
local utils = require('utils')
local copilot_enabled = os.getenv("COPILOT_ENABLED")
vim.g.node_bin = "/usr/bin/node"
if not utils.path_exists(vim.g.node_bin) then
    -- For Mac
    vim.g.node_bin = "/opt/homebrew/opt/node/bin/node"
end
vim.g.copilot_available = copilot_enabled == "true" and utils.path_exists(vim.g.node_bin)
if vim.g.copilot_available then
    -- To list available models, run: <cmd>CopilotChatModels
    vim.g.copilot_model = "claude-sonnet-4"
end

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy").load("options")

if vim.g.deprecation_warnings == false then
  vim.deprecate = function() end
end

local spec = {
    { import = "plugins" },
    { import = "editor" },
    { import = "coding" },
}

require("lazy").setup({
    spec = spec,
    {
        rocks = {
            hererocks = true, -- recommended if you do not have global installation of Lua 5.1.
        },
    },
    ui = {
        border = "single",
    },
    checker = { enabled = true, notify = false }, -- automatically check for plugin updates
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "onedark" } },
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

require("config.lazy").setup()
