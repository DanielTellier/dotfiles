local saga = require('lspsaga')
local action = require("lspsaga.action")

saga.init_lsp_saga()

-- Mappings

vim.keymap.set('n', '<leader>gh', '<cmd>Lspsaga lsp_finder<cr>',
  { silent = true })

-- Code action
vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<cr>",
  { silent = true })
vim.keymap.set("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<cr>",
  { silent = true })

-- Hover doc
vim.keymap.set("n", "<s-k>", "<cmd>Lspsaga hover_doc<cr>", { silent = true })
-- scroll down hover doc or scroll in definition preview
vim.keymap.set("n", "<c-f>", function()
  action.smart_scroll_with_saga(1) end, { silent = true })
-- scroll up hover doc
vim.keymap.set("n", "<c-b>", function()
  action.smart_scroll_with_saga(-1) end, { silent = true })

-- close rename win use <C-c> in insert mode or `q` in normal mode or `:q`
vim.keymap.set("n", "<leader>gr", "<cmd>Lspsaga rename<cr>",
  { silent = true })

-- Show diagnostics
vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>",
  { silent = true })
vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>",
  { silent = true })

-- Jump to errors
vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>",
  { silent = true })
vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>",
  { silent = true })

-- LS Outline
vim.keymap.set("n", "<leader>lso", ":LSoutlineToggle<cr>")

-- LS Float Term
vim.keymap.set("n", "<a-d>",
  "<cmd>Lspsaga open_floaterm custom_cli_command<cr>", { silent = true })
vim.keymap.set("t", "<a-d>",
  "<c-\\><c-n><cmd>Lspsaga close_floaterm<cr>", { silent = true })
