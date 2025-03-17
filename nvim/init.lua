local vim = vim
local utils = require('utils')
local copilot_enabled = os.getenv("COPILOT_ENABLED")
vim.g.node_bin = "/usr/bin/node"
if not utils.path_exists(vim.g.node_bin) then
    -- For Mac
    vim.g.node_bin = "/opt/homebrew/opt/node/bin/node"
end
vim.g.copilot_available = copilot_enabled == "true" and utils.path_exists(vim.g.node_bin)

require('settings')
require('commands')
require('mappings')
require('config.lazy')
